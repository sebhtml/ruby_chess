
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



require_relative 'man'

class Rook < Man
  build 'r', 'R', possible_moves

  def possible_moves board, tile
   moves = render_moves board, tile, self.class.vectorial_moves
   remove_moves_with_collisions board, moves 
  end

  def self.vectorial_moves
    moves = []
    (0..7).each do |i|
      moves << [0, i]
      moves << [i, 0]
      moves << [0, -i]
      moves << [-i, 0]
    end

    convert_to_vectors_list moves
  end
end
