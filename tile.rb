
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



require_relative 'board'

class Tile

  def to_s
    location
  end

  def initialize row, col
    @row = row
    @col = col

    @location = @@locations[row][col]
  end

  def == j
    @row == j.row && @col == j.col
  end

  def self.locations
    @@locations
  end

  def location
    @location 
  end

  def row
    @row
  end

  def col
    @col
  end

  def self.build_locations
    @@locations = {}

    @@locations[Board::ROW_8] = {}
    @@locations[Board::ROW_7] = {}
    @@locations[Board::ROW_6] = {}
    @@locations[Board::ROW_5] = {}
    @@locations[Board::ROW_4] = {}
    @@locations[Board::ROW_3] = {}
    @@locations[Board::ROW_2] = {}
    @@locations[Board::ROW_1] = {}

    @@locations[Board::ROW_8][Board::COL_A] = "A8"
    @@locations[Board::ROW_8][Board::COL_B] = "B8"
    @@locations[Board::ROW_8][Board::COL_C] = "C8"
    @@locations[Board::ROW_8][Board::COL_D] = "D8"
    @@locations[Board::ROW_8][Board::COL_E] = "E8"
    @@locations[Board::ROW_8][Board::COL_F] = "F8"
    @@locations[Board::ROW_8][Board::COL_G] = "G8"
    @@locations[Board::ROW_8][Board::COL_H] = "H8"

    @@locations[Board::ROW_7][Board::COL_A] = "A7"
    @@locations[Board::ROW_7][Board::COL_B] = "B7"
    @@locations[Board::ROW_7][Board::COL_C] = "C7"
    @@locations[Board::ROW_7][Board::COL_D] = "D7"
    @@locations[Board::ROW_7][Board::COL_E] = "E7"
    @@locations[Board::ROW_7][Board::COL_F] = "F7"
    @@locations[Board::ROW_7][Board::COL_G] = "G7"
    @@locations[Board::ROW_7][Board::COL_H] = "H7"

    @@locations[Board::ROW_6][Board::COL_A] = "A6"
    @@locations[Board::ROW_6][Board::COL_B] = "B6"
    @@locations[Board::ROW_6][Board::COL_C] = "C6"
    @@locations[Board::ROW_6][Board::COL_D] = "D6"
    @@locations[Board::ROW_6][Board::COL_E] = "E6"
    @@locations[Board::ROW_6][Board::COL_F] = "F6"
    @@locations[Board::ROW_6][Board::COL_G] = "G6"
    @@locations[Board::ROW_6][Board::COL_H] = "H6"

    @@locations[Board::ROW_5][Board::COL_A] = "A5"
    @@locations[Board::ROW_5][Board::COL_B] = "B5"
    @@locations[Board::ROW_5][Board::COL_C] = "C5"
    @@locations[Board::ROW_5][Board::COL_D] = "D5"
    @@locations[Board::ROW_5][Board::COL_E] = "E5"
    @@locations[Board::ROW_5][Board::COL_F] = "F5"
    @@locations[Board::ROW_5][Board::COL_G] = "G5"
    @@locations[Board::ROW_5][Board::COL_H] = "H5"

    @@locations[Board::ROW_4][Board::COL_A] = "A4"
    @@locations[Board::ROW_4][Board::COL_B] = "B4"
    @@locations[Board::ROW_4][Board::COL_C] = "C4"
    @@locations[Board::ROW_4][Board::COL_D] = "D4"
    @@locations[Board::ROW_4][Board::COL_E] = "E4"
    @@locations[Board::ROW_4][Board::COL_F] = "F4"
    @@locations[Board::ROW_4][Board::COL_G] = "G4"
    @@locations[Board::ROW_4][Board::COL_H] = "H4"

    @@locations[Board::ROW_3][Board::COL_A] = "A3"
    @@locations[Board::ROW_3][Board::COL_B] = "B3"
    @@locations[Board::ROW_3][Board::COL_C] = "C3"
    @@locations[Board::ROW_3][Board::COL_D] = "D3"
    @@locations[Board::ROW_3][Board::COL_E] = "E3"
    @@locations[Board::ROW_3][Board::COL_F] = "F3"
    @@locations[Board::ROW_3][Board::COL_G] = "G3"
    @@locations[Board::ROW_3][Board::COL_H] = "H3"

    @@locations[Board::ROW_2][Board::COL_A] = "A2"
    @@locations[Board::ROW_2][Board::COL_B] = "B2"
    @@locations[Board::ROW_2][Board::COL_C] = "C2"
    @@locations[Board::ROW_2][Board::COL_D] = "D2"
    @@locations[Board::ROW_2][Board::COL_E] = "E2"
    @@locations[Board::ROW_2][Board::COL_F] = "F2"
    @@locations[Board::ROW_2][Board::COL_G] = "G2"
    @@locations[Board::ROW_2][Board::COL_H] = "H2"

    @@locations[Board::ROW_1][Board::COL_A] = "A1"
    @@locations[Board::ROW_1][Board::COL_B] = "B1"
    @@locations[Board::ROW_1][Board::COL_C] = "C1"
    @@locations[Board::ROW_1][Board::COL_D] = "D1"
    @@locations[Board::ROW_1][Board::COL_E] = "E1"
    @@locations[Board::ROW_1][Board::COL_F] = "F1"
    @@locations[Board::ROW_1][Board::COL_G] = "G1"
    @@locations[Board::ROW_1][Board::COL_H] = "H1"

  end

  build_locations
end

