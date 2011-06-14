
=begin

    ruby_chess
    The Chess Board game implemented in the metalanguage ruby
    Using the mighty GTK2 library
    
    Copyright (C) 2006 Sébastien Boisvert
    http://sebhtml.blogspot.com/
    Sebastien.Boisvert<AT>USherbrooke<DOT>CA

    This software is released under the GPL version 2 (1991)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation;  version 2 of the License

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

    An online plain text version is available here:
    http://www.gnu.org/licenses/gpl.txt
=end



require 'help_window'
require 'man_selector'
require 'board_selector'
require 'player'
require 'game_options'
require 'graphical_board'
require 'color'
require 'artificial_intelligence'
require 'human'
require 'board'
require 'chess_window'

class Chess
  SELECT_FROM = 2
  SELECT_TO = 3

  def update_board move
    target = board.content_at move.to
    if target.class == King
      @winner = @current_turn
    end

    piece = board.content_at move.from
    new_board = @boards_list.last.do_move move
    piece = board.content_at move.from
    piece.add_move move
    board.move_for_next_board = move
    board.next_board = new_board
    @boards_list << new_board
  end
    
  def white_intelligence= intelligence
    @white_intelligence = intelligence
  end

  def black_intelligence= intelligence
    @black_intelligence = intelligence
  end

  def show_move
    @label.label += @current_turn.color+" "+
      piece.letter+" "+
        move.from.location + " " +
        move.to.location+ "\n"
  end

  def initialize
    @boards_list = Array.new
    @current_from_button = nil
    @current_to_button = nil

    window = GameOptions.new self
    window.show

    Gtk.main
  end

  def run
    @white_player = Player.new Color::WHITE,  @white_intelligence
    @black_player = Player.new Color::BLACK, @black_intelligence

    @white_player.opponent = @black_player
    @black_player.opponent = @white_player

    help_button = Gtk::Button.new
    label = Gtk::Label.new
    label.label = "About"
    help_button.add label

    help_button.signal_connect 'clicked' do 
      help_window = HelpWindow.new 
      help_window.run
    end

    @graphical_board = GraphicalBoard.new self

    board = Board.new @black_player, @white_player, @graphical_board
    @boards_list <<  board

    @run = true
    chess_window = ChessWindow.new  self

    board_selector = BoardSelector.new
    label = Gtk::Label.new
    @label = label
    hbox = Gtk::HBox.new
    vbox = Gtk::VBox.new
    hbox.add @graphical_board
    vbox2 = Gtk::VBox.new
    #vbox2.add board_selector
    hbox.add vbox2
    vbox2.show_all
    vbox.add hbox
    vbox.add help_button
    chess_window.add vbox

    hbox.show_all
    vbox.show_all
    chess_window.show_all

    @current_turn = @white_player
    @current_state = SELECT_FROM

    @graphical_board.show @boards_list.last

    if @current_turn.ai?
      play_ai 
    end

  end

  def play_ai
    Thread.new do
      play_ai_in_thread
    end
  end

  def do_move  move
      update_board move
      @graphical_board.update @boards_list.last, move.from
      @graphical_board.update @boards_list.last, move.to
      switch_player
  end

  def play_ai_in_thread
    if @winner == nil 

      moves_list = board.moves_for_player @current_turn
      move = @current_turn.play board, moves_list

      if move == nil
        @winner = @current_turn.opponent 
        return 
      end

      do_move move
      if @current_turn.ai?
        play_ai
      end
    else

      @label.label += "
#{@winner} has won the game.
    "
    end
  end

  def declare_winner player
    @winner = player
  end

  # interface for human player
  def catch_click row, col
    if @current_turn.ai?
      return
    end

    moves_list=board.moves_for_player @current_turn
    @current_turn.play board, moves_list
    piece = board.board[row][col]

    tile = Tile.new row, col

    if @current_state == SELECT_FROM
      if piece.nil?
        return
      end

      if piece.player != @current_turn
        return
      end
  
      all_moves = moves_list

      correct = false

      all_moves.each do |move|
        if move.from == tile
          correct = true
          break
        end
      end

      unless correct
        return
      end

      @current_piece = piece
      @from = tile
      @current_state = SELECT_TO
    elsif @current_state == SELECT_TO
      @to = tile
      move = Move.new @from, @to

      possible_moves = moves_list

      state = false 
      possible_moves.each do |move_p|
        if move_p == move
          state = true
          break
        end
      end

      unless state
        @current_state = SELECT_FROM
        return
      end

      do_move move
      @current_state = SELECT_FROM
      
      if @current_turn.ai?
        play_ai
      end
    end
  end

  def switch_player
    if  @current_turn== @white_player
      @current_turn = @black_player
    else
      @current_turn = @white_player
    end
  end

  def board
    @boards_list.last
  end

  def terminate
    @run = false
    Gtk.main_quit
  end
end

