
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

class BoardSelector < Gtk::Table
  def initialize
    super 1, 5

    label = Gtk::Label.new
    label.label = '1'
    column_1 = Gtk::Label.new
    column_1.label = 'Turn'

    column_2 = Gtk::Label.new
    column_2.label = 'White'

    column_3 = Gtk::Label.new
    column_3.label = 'Black'

    attach column_1, 0, 1, 0, 1
    attach column_2, 1, 3, 0, 1
    attach column_3, 3, 5, 0, 1
    attach label, 0, 1, 1, 2

    button = Gtk::Button.new
    attach button, 1, 2, 1, 2
    show_all

  end
end


