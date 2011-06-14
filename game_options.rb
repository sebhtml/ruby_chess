

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
require 'human'
require 'artificial_intelligence'

class GameOptions < Gtk::Window
  def initialize chess
    super('Ruby Chess')
    chess = chess

    signal_connect "destroy" do
      chess.terminate 
    end
  
    button = Gtk::Button.new

    ok_label = Gtk::Label.new
    ok_label.label = "Start"
    button.add ok_label
    
    black_combobox= Gtk::ComboBox.new
    human_option =  "Human World"
    ai_option = "Artificial Intelligence"
    black_combobox.append_text ai_option
    black_combobox.append_text human_option
    black_combobox.active = 0

    @black_combobox = black_combobox
    white_combobox = Gtk::ComboBox.new
    white_combobox.append_text ai_option
    white_combobox.append_text human_option
    white_combobox.active = 0
    @white_combobox = white_combobox
    white_label = Gtk::Label.new
    white_label.label = 'White'
    black_label = Gtk::Label.new

    label = Gtk::Label.new
    label.label = "Choose stuff"
    black_label.label = 'Black'
    table = Gtk::Table.new 3, 2, false
    table.attach white_label, 0, 1, 0, 1
    table.attach black_label, 0, 1, 1, 2
    table.attach white_combobox, 1, 2, 0, 1
    table.attach black_combobox, 1, 2, 1, 2
    vbox = Gtk::VBox.new 
    vbox.add label
    vbox.add table
    vbox.add button
    add vbox

    button.signal_connect 'clicked' do
      intelligences = [ArtificialIntelligence, Human]
      white_intelligence = intelligences[white_combobox.active]
      black_intelligence = intelligences[black_combobox.active]
      chess.white_intelligence = white_intelligence
      chess.black_intelligence = black_intelligence
      hide 
      chess.run
    end
    show_all
  end

end

