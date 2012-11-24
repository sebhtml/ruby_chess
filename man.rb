
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



require_relative 'move'
require_relative 'board'

class Man
  IMAGE_PATH = 'pixmaps/'
  IMAGE_EXT = '.png'

  def self.convert_to_vectors_list arrays_list
    v_list = []
    arrays_list.each do |vector|
      vectorial_move = VectorialMove.new vector[0], vector[1]
      v_list << vectorial_move
    end
    v_list
  end

  def self.build black_image, white_image, moves
    @black_image = black_image
    @white_image = white_image
    @moves = moves
  end

  def moves_history
    @moves_history
  end

  def  render_moves board, tile, vectorial_moves
    moves = []
    vectorial_moves.each do |move|
      new_row = tile.row+move.delta_x
      new_col = tile.col+move.delta_y
      
      unless Board::ROW_8 <= new_row && new_row <= Board::ROW_1 &&
        Board::COL_A <= new_col && new_col <= Board::COL_H
        next
      end

      if board.board[new_row][new_col] != nil &&
       board.board[new_row][new_col].player == @player
        next  
      end

      from = tile
      to = Tile.new new_row, new_col
      move = Move.new from, to
      moves << move
    end

    moves
  end

  def self.possible_moves
    []
  end
 
  def player
    @player
  end

  def color
    @player.color
  end

  def possible_moves board, tile
    self.class.possible_moves
  end
 
  def initialize player
    @moves_history = Array.new
    @player = player

    if @player.black?
      @image = self.class.black_image
    else
      @image =  self.class.white_image
    end
  end

  def image
    IMAGE_PATH+    @image+    IMAGE_EXT
  end

  def letter
    @image
  end

  def self.black_image
    @black_image
  end

  def self.white_image 
    @white_image
  end

  def add_move move
    @moves_history << move
  end

 private
  def remove_moves_with_collisions board, moves
    good_moves = [] 
    moves.each do |move|
      delta_row =  move.to.row - move.from.row
      delta_col = move.to.col - move.from.col

      row_increment= delta_row > 0 ? +1 : -1
      col_increment  = delta_col > 0 ? +1 : -1
      
      row_increment = delta_row == 0 ? delta_row : row_increment
      col_increment = delta_col == 0 ? delta_col : col_increment

      row_iterator = move.from.row + row_increment
      col_iterator = move.from.col + col_increment
    
      final_row = move.to.row 
      final_col = move.to.col

      is_good = true

      while row_iterator != final_row ||
            col_iterator != final_col
      
            #board.graphical_board.flash_piece row_iterator, col_iterator
        content = board.cartesian_content row_iterator, col_iterator

        if content != nil
          is_good = false
          break
        end
        row_iterator += row_increment
        col_iterator += col_increment
      end

      if is_good == true
        good_moves << move
      end
      #board.graphical_board.reset_colors
    end
  
    good_moves
  end
  
end

