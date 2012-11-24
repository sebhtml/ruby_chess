
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
require_relative 'chess_button'

class GraphicalBoard  < Gtk::Table

  def flash_piece row, col
    @buttons_hash[row][col].flash
  end

  def from tile
    @buttons_hash[tile.row][tile.col].from
  end

  def to tile
    @buttons_hash[tile.row][tile.col].to
  end

  def reset_colors
    @buttons_hash.each do |row, cols|
      cols.each do |col, button|
        button.restore
      end
    end
  end

  def initialize chess
    super(10, 10, false)
    self.homogeneous = true

    @buttons_hash = {}
    (1..8).each do |row| 
    @buttons_hash[row] = {}
      (1..8).each do  |col|
        button = ChessButton.new chess, row, col
        button.can_focus = false
        @buttons_hash[row][col] = button
        attach button, col, col+1, row, row+1
      end
    end

    (1..8).each do |i|
      left_label = i.to_s 
      pos = 9 - i
      label = Gtk::Label.new
      label.label = left_label
      attach label, 0, 1, pos, pos+1
    end

    (1..8).each do |i|
      left_label = i.to_s 
      pos = 9 -i
      label = Gtk::Label.new
      label.label = left_label
      attach label, 9, 10, pos, pos+1
    end

    label = 'A'[0]
    (1..8).each do |i|
      gtk_label = Gtk::Label.new
      gtk_label.label = label.chr
      gtk_label2 = Gtk::Label.new
      gtk_label2.label = label.chr
      attach gtk_label, i, i+1, 0, 1
      attach gtk_label2, i, i+1, 9, 10
      label +=1.to_s
    end

    show_all
  end

  def buttons_hash
    @buttons_hash
  end

  def update board, tile
    row = tile.row
    col = tile.col
    button = @buttons_hash[row][col]
    button.remove button.children.first
    content = board.content_at tile
    unless content.nil?
      image = content.image
      button.can_focus = true
      gtk_image = Gtk::Image.new image
      button.add gtk_image
      button.show_all
    end
  end

  def show board
    board.board.each do |row, cols|
      cols.each do |col, content|
        tile = Tile.new row, col 
        update board, tile 
      end
    end
  end
end

