
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



require 'man'
require 'vectorial_move'

class Pawn < Man
  build 'p', 'P', possible_moves

  def self.possible_moves
    @black_after_move = [[1, 0]]
    @white_after_move = [[-1, 0]]
    @black_before_move = [[1, 0], [2, 0]]
    @white_before_move = [[-1, 0], [-2, 0]]
  end

  def self.black_before_move
    @black_before_move
  end

  def self.white_before_move
    @white_before_move
  end

  def self.black_after_move
    @black_after_move
  end

  def self.white_after_move 
    @white_after_move 
  end

  def possible_moves board, tile
   mov_m =  moving_moves board, tile
   att_m = attach_moves board, tile
   vectorial_moves = mov_m+att_m
   vectorial_moves = self.class.convert_to_vectors_list vectorial_moves
   moves = render_moves board, tile, vectorial_moves
   moves = remove_moves_with_collisions board, moves 
   moves.each do |move|
   
     if (board.content_at move.to) != nil &&
        move.from.col == move.to.col
       moves.delete move
     end
   end

   moves
  end

  private

  def moving_moves board, tile
    moves = [] 
    if @player.black?
      if @moves_history.empty?
        moves = self.class.black_before_move
      else
        moves = self.class.black_after_move
      end
    else
      if @moves_history.empty?
        moves = self.class.white_before_move
      else
        moves =self.class.white_after_move
      end
    end
    moves
  end

  def attach_moves board, tile
    row = tile.row
    col = tile.col
    att_m = []
    if @player.black?
      if (board.cartesian_content row+1, col-1)!= nil
        m1 = [+1, -1]
        att_m << m1
      elsif (board.cartesian_content row+1, col+1) != nil
        m2 = [+1, +1]
        att_m << m2
      end
    else
      if (board.cartesian_content row-1, col-1)  != nil 
        m1 = [-1, -1]
        att_m << m1
      elsif (board.cartesian_content row-1, col+1) != nil 
        m2 = [-1, +1]
        att_m << m2
      end
    end

    att_m
  end
  possible_moves
end

