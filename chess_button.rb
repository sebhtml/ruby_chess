
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



require 'gtk2'
require_relative 'tile'

class ChessButton < Gtk::Button
  FROM_COLOR= Gdk::Color.new 50000, 20000, 20000
  
  OVER_COLOR = Gdk::Color.new  60000, 30000, 30000
  SELECTED_COLOR = Gdk::Color.new 63000, 48000, 30000
  TO_COLOR = Gdk::Color.new 10000, 40000, 20000

  BLUE =  Gdk::Color.new 60000, 30000, 50000

  COLOR_1= Gdk::Color.new 30000, 30000, 63000
  COLOR_2= Gdk::Color.new 30000, 63000, 30000

  def initialize chess, row, col
    super()
    @chess = chess
    @tile = Tile.new row, col
    @row = row
    @col = col

    signal_connect "clicked" do |w, e|
      @chess.catch_click row, col
    end

    color = nil

    if (row+col) %2 == 0
      @color =  COLOR_2
    else
      @color =  COLOR_1
    end
       
    restore
  end

  def flash
    modify_bg Gtk::STATE_NORMAL, OVER_COLOR
  end

  def  apply_from_color
    [Gtk::STATE_ACTIVE, Gtk::STATE_PRELIGHT, Gtk::STATE_NORMAL].each do |i|
      modify_bg i, FROM_COLOR
    end

    show
  end

  def apply_to_color
    [Gtk::STATE_ACTIVE, Gtk::STATE_PRELIGHT, Gtk::STATE_NORMAL].each do |i|
      modify_bg i, TO_COLOR
    end
    
    show
  end

  def location
    @tile.location
  end

  def from
    modify_bg Gtk::STATE_NORMAL, SELECTED_COLOR
  end

  def to
    modify_bg Gtk::STATE_NORMAL, SELECTED_COLOR
  end

  def blue
    modify_bg Gtk::STATE_NORMAL, BLUE
  end

  def restore
    modify_bg Gtk::STATE_NORMAL, @color
    modify_bg Gtk::STATE_ACTIVE, SELECTED_COLOR
    modify_bg Gtk::STATE_PRELIGHT, OVER_COLOR
  end
end

