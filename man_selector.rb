
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
require_relative 'queen'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'
require_relative 'chess_button'

class ManSelector < Gtk::Dialog
  def initialize player, board
    super()
    set_modal true

    choices_list = [Queen, Rook, Bishop, Knight]
    men = {}
    image = {}
    button = {}
    
    choices_list.each do |choice|
      men[choice] = choice.new player
      image[choice] = Gtk::Image.new men[choice].image
      button[choice] = Gtk::Button.new
      button[choice].modify_bg Gtk::STATE_NORMAL, ChessButton::COLOR_1
      button[choice].modify_bg Gtk::STATE_ACTIVE, ChessButton::COLOR_2
      button[choice].modify_bg Gtk::STATE_PRELIGHT, ChessButton::OVER_COLOR

      button[choice].add image[choice]

      button[choice].signal_connect 'clicked' do
        board.promotion= choice
        destroy
      end

      vbox.add button[choice]
    end
    show_all
    signal_connect 'response' do
      destroy
    end
  end
end
