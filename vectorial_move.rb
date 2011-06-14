
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



class VectorialMove
  def initialize delta_x, delta_y
    @delta_x = delta_x
    @delta_y = delta_y
  end

  def delta_x
    @delta_x
  end

  def delta_y
    @delta_y
  end

  def to_s
    delta_x.to_s+" "+delta_y.to_s
  end

  def == j
    delta_x == j.delta_x && delta_y == j.delta_y
  end
end

