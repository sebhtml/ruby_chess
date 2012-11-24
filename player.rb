
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


require_relative 'color'
require_relative 'artificial_intelligence'
require_relative 'queen'
require_relative 'knight'
require_relative 'king'
require_relative 'pawn'
require_relative 'rook'
require_relative 'bishop'

class Player
  def to_s
    @color
  end
  def initial_king_row
    if @color == Color::BLACK
      Board::ROW_8
    else
      Board::ROW_1
    end
  end

  def pawn_row
    if @color == Color::BLACK
      Board::ROW_7
    else
      Board::ROW_2
    end
  end

  def human?
    @intelligence.class == Human
  end

  def intelligence
    @intelligence
  end

  def initialize color, intelligence
    @intelligence = intelligence.new self
    @color = color
    @moves_history = Array.new
    @king = King.new self
    @queen = Queen.new self
    @pawn_a = Pawn.new self
    @pawn_b = Pawn.new self
    @pawn_c = Pawn.new self
    @pawn_d = Pawn.new self
    @pawn_e = Pawn.new self
    @pawn_f = Pawn.new self
    @pawn_g = Pawn.new self
    @pawn_h = Pawn.new self
    @rook_a = Rook.new self
    @rook_h = Rook.new self
    @knight_b = Knight.new self
    @knight_g = Knight.new self
    @bishop_c = Bishop.new self
    @bishop_f = Bishop.new self
    @extra_stuff = []
  end

  def add_man man
    @extra_stuff << man
  end

  def opponent= opponent
    @opponent = opponent
  end

  def opponent
    @opponent
  end

  def ai?
    @intelligence.class == ArtificialIntelligence
  end

  def play board, moves_list
    @intelligence.choose board, moves_list, self
  end

  def color
    @color
  end

  def king
    @king
  end

  def black?
    @color == Color::BLACK
  end

  def king
    @king
  end
  
  def queen
    @queen
  end
  
  def pawn_a
    @pawn_a
  end

  def pawn_b
    @pawn_b
  end

  def pawn_c
    @pawn_c
  end

  def pawn_d
    @pawn_d
  end

  def pawn_e
    @pawn_e
  end

  def pawn_f
    @pawn_f
  end

  def pawn_g
    @pawn_g
  end

  def pawn_h
    @pawn_h
  end

  def rook_a
    @rook_a
  end

  def rook_h
    @rook_h
  end

  def knight_b
    @knight_b
  end

  def knight_g
    @knight_g
  end

  def bishop_c
    @bishop_c
  end

  def bishop_f
    @bishop_f
  end
end


