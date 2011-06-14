
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



# 8 r n b q k b n r
# 7 p p p p p p p p
# 6
# 5
# 4
# 3
# 2 P P P P P P P P
# 1 R N B Q K B N R
#   a b c d e f g h
#

#TODO :la passe du pion qui bouffe de côté..

class Board
  ROW_8 = 0+1
  ROW_7 = 1+1
  ROW_6 = 2+1
  ROW_5 = 3+1
  ROW_4 = 4+1
  ROW_3 = 5+1
  ROW_2 = 6+1
  ROW_1 = 7+1

  COL_A = 0+1
  COL_B = 1+1
  COL_C = 2+1
  COL_D = 3+1
  COL_E = 4+1
  COL_F = 5+1
  COL_G = 6+1
  COL_H = 7+1

  def graphical_board
    @graphical_board
  end

  def promotion= promotion
    @promotion = promotion
  end

  def moves_for_player_without_check_check player
    pieces = []
    if player.black?
      pieces = black_pieces
    else
      pieces = white_pieces
    end

    king_tile = nil
    moves_list = []
    pieces.each do |tile, piece|
      if piece.class == King
        king_tile = tile
      end

      piece.possible_moves(self, tile).each do |move|
        moves_list << move
      end
    end


    moves_list
  end

  def add_castling_moves moves_list, player
    row = player.initial_king_row 
    
    from = Tile.new row, COL_E

    if player.king.moves_history.empty? &&
        player.rook_a.moves_history.empty?
      b8 = cartesian_content row, COL_B
      c8 = cartesian_content row, COL_C
      d8 = cartesian_content row, COL_D

      if b8.nil? && c8.nil? && d8.nil?
        to = Tile.new row, COL_A
        move= Move.new from, to
        moves_list << move
      end
    end

    if player.king.moves_history.empty? &&
      player.rook_h.moves_history.empty?
      f8 = cartesian_content row, COL_F
      g8= cartesian_content row, COL_G

      if f8.nil? && g8.nil?
        to = Tile.new row, COL_H
        move = Move.new from, to
        moves_list << move
      end
    end

    moves_list
  end

  def where_is_the_king player
    pieces = []
    if player.black?
      pieces = black_pieces
    else
      pieces = white_pieces
    end

    pieces.each do |tile, piece|
      if piece.class == King
        return tile
      end
    end
  end

  def moves_for_player player
    moves_list = moves_for_player_without_check_check player
    moves_list = keep_safe_move_for_check_removal player, moves_list

    if (check_verification player) == false
      moves_list = add_castling_moves moves_list, player
    end
    moves_list
  end

  def check_verification player
    opponent_moves = moves_for_player_without_check_check player.opponent  
    king_tile = where_is_the_king player
    opponent_moves.each do |opponent_move|
      if opponent_move.to == king_tile
        return true
      end
    end

    return false
  end

  # among moves_list, keep those which going to no check
  def keep_safe_move_for_check_removal player, moves_list
    safe_moves = [] 
    
    moves_list.each do |move|
      new_board =  do_move move, true
      if (new_board.check_verification player) == false
        safe_moves << move 
      else
      end
    end
    
    safe_moves 
  end

  def x_player_pieces player
    pieces = {}
    board.each do |row, cols|
      cols.each do |col, content|
        if content != nil && content.player == player
          tile = Tile.new row, col
          pieces[tile] = content
        end
      end
    end

    pieces
  end

  public

  def white_pieces
    x_player_pieces @white_player
  end

  def black_pieces
    x_player_pieces @black_player
  end

  def initialize black_player, white_player, graphical_board
    @graphical_board = graphical_board
    @black_player = black_player
    @white_player = white_player
    @next_board = nil
    @board = {}
    @board[ROW_8]= {}   
    @board[ROW_7]= {}   
    @board[ROW_6]= {}   
    @board[ROW_5]= {}   
    @board[ROW_4]= {}   
    @board[ROW_3]= {}   
    @board[ROW_2]= {}   
    @board[ROW_1]= {}   

    initiate_board black_player, white_player
    @move_for_next_board = nil
  end

  def board
    @board
  end

  def content_at tile
    cartesian_content tile.row, tile.col 
  end

  def cartesian_content row, col
    if board[row] == nil
      return nil
    end

    return board[row][col]
  end

  def do_move move, ai_mode = false
    next_board = self.class.new @black_player, @white_player, @graphical_board
    next_board.do_move_from_board self, move, ai_mode
    next_board
  end

  # ai_mode is for check detection
  def do_move_from_board board, move, ai_mode
    
    board.board.each do |row, cols|
      cols.each do |col, content|
        @board[row][col] = content
      end
    end

    from = move.from
    to = move.to

    piece = board.content_at from
    
    if piece.class == Pawn 
      if move.to.row == ROW_8 || move.to.row == ROW_1
        if ai_mode == true
          promotion = Queen
        else
          promotion = piece.player.intelligence.promotion_chooser
        end

        man = promotion.new piece.player
        piece.player.add_man man

        p man.class.to_s

        @board[to.row][to.col] = man
        @board[from.row][from.col] = nil
        return 
      end
    end

    to_piece = board.content_at to

    if piece.class == King && to_piece.class == Rook &&
       piece.player == to_piece.player


        @board[to.row][to.col] = piece
        @board[from.row][from.col] = to_piece

      return
    end

    @board[to.row][to.col] = @board[from.row][from.col] 
    @board[from.row][from.col] = nil
  end


  def move_for_next_board= move
    @move_for_next_board = move
  end

  def next_board= board
    @next_board = board
  end

  private
  def initiate_board black_player, white_player
    set_player_row ROW_8, ROW_7, black_player
    set_player_row ROW_1, ROW_2, white_player 
  end

  def set_player_row row_1, row_2, player
    @board[row_1][COL_A]= player.rook_a
    @board[row_1][COL_B]= player.knight_b
    @board[row_1][COL_C]= player .bishop_c
    @board[row_1][COL_D]= player .queen
    @board[row_1][COL_E]= player .king
    @board[row_1][COL_F]= player .bishop_f
    @board[row_1][COL_G]= player .knight_g
    @board[row_1][COL_H]= player .rook_h
    @board[row_2][COL_A]= player .pawn_a
    @board[row_2][COL_B]= player .pawn_b
    @board[row_2][COL_C]= player .pawn_c
    @board[row_2][COL_D]= player .pawn_d
    @board[row_2][COL_E]= player .pawn_e
    @board[row_2][COL_F]= player .pawn_f
    @board[row_2][COL_G]= player .pawn_g
    @board[row_2][COL_H]= player .pawn_h
  end
end

