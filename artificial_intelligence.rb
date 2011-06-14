
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


require 'intelligence'
require 'tile'
require 'king'
require 'queen'
require 'pawn'
require 'rook'
require 'bishop'
require 'knight'

class ArtificialIntelligence  < Intelligence

  CASTLE_VALUE = 8000

  def new_pawns board, player
    return false  
    accumulator = 0
    (1..8).each do |j|
      tile = Tile.new player.pawn_row, j
      content = board.content_at tile

      p tile 
      if content.nil?
        accumulator+=1
      end

      if accumulator == 3
        return false
      end
    end
    
    return true
  end

  def choose board, moves_list, player
    if new_pawns board, player
      moves_list.each do |move|
        if [Board::COL_C, Board::COL_D, Board::COL_E, Board::COL_F].include? move.from.col 
          content = board.content_at move.from
          
          if content.class == Pawn
            return move
          end
        end
      end
    end

    best_move = nil
    best_score = nil
    
    levels_amount = eval_board_complexity board, player
    moves_list = remove_kamikaze_moves board, moves_list, player

    i = 1
    j = moves_list.size
    moves_list.each do |move|
      board.graphical_board.reset_colors
      board.graphical_board.buttons_hash[move.from.row][move.from.col].from
      board.graphical_board.buttons_hash[move.to.row][move.to.col].to
      new_board = board.do_move  move
      STDOUT << "#{move.to_s} [#{i}/#{j}]  "
      i+= 1
      current_score = recursive_heuristic new_board, player.opponent, levels_amount, levels_amount

      STDOUT << current_score.to_s << "\n"
      if best_move.nil?
        best_move = move
        best_score = current_score
      end

      if current_score > best_score
        best_score = current_score
        best_move = move
      end
    end

    best_move
  end

  def recursive_heuristic board, player, level, max_level
    sum = heuristic board, player

    if level == 0
      return sum
    end

    moves= board.moves_for_player player


    children = []
      
    moves.each do |move|
      new_board = board.do_move move
      children << new_board
    end

    best = children.first
    best_h = heuristic best, player
    children.each do |child|
      current_h =  heuristic child, player
      sum += current_h
      if current_h > best_h
        best = child
      end 
    end

    unless best.nil?
      sum += recursive_heuristic best, player.opponent, level-1, max_level
    end

    return sum
  end

  def heuristic board, player
    i = heuristic_p board, player
    j = heuristic_p board, player.opponent
    result = j - i 

    unless go_farther
      return result
    end

    moves = board.moves_for_player player

    moves.each do |move|
      content = board.content_at move.to

      unless content.nil?
        value = value_of content
        result += value
      end
    end

    # eval castle position

    row = player.initial_king_row

    rook_a_tile = Tile.new row, Board::COL_A
    rook_h_tile = Tile.new row, Board::COL_H
    king_tile = Tile.new row, Board::COL_E

    rook_a_tile_content = board.content_at rook_a_tile
    rook_h_tile_content = board.content_at rook_h_tile
    king_tile_content = board.content_at king_tile

    if king_tile_content.class == Rook &&
        (rook_a_tile_content.class == King ||
        rook_h_tile_content.class == King
        )
      result += CASTLE_VALUE
    end

    result
  end

  def heuristic_p board, player
    val = 0
    board.board.each do |row, cols|
      cols.each do |col, content|
        if content != nil && content.player == player
          val += value_of content
        end
      end
    end
    val
  end


# pawn     100
# bishop   1000
# knight   2000
# rook     5000
# queen    10000
# king     1000000
  def value_of piece
    values = {}
    values[King] = 1000000
    values[Pawn] = 100
    values[Bishop] = 1000
    values[Knight] = 2000
    values[Rook] = 5000
    values[Queen] = 10000

    values[piece.class]
  end

  def remove_kamikaze_moves board, moves_list, player
    safe_moves = []
    moves_list.each do |move|
      from_piece = board.content_at move.from
      to_piece = board.content_at move.to

      if to_piece != nil && 
         (value_of from_piece) < (value_of to_piece)
        safe_moves << move 
        next
      end

      new_board = board.do_move move 
      possible_moves = new_board.moves_for_player player.opponent
      safe = true
      possible_moves.each do |possible_move|
        if possible_move.to== move.to
          safe = false
          break
        end
      end

      if safe == true
        safe_moves << move
      end
    end
    safe_moves
  end

  def eval_board_complexity board, player
    count = 0
    (3..6).each do |i|
      (0..8).each do |j|
        tile = Tile.new i, j
        content = board.content_at  tile
        unless content.nil?
          count += 1
        end
      end
    end

    p = rand 4
    if count < p
      m = rand 3
      return m
    else
      m2 = rand 8
      return m2
    end
  end

  def go_farther 
    k = rand 1000
    l = rand 400
    k < l
  end
end


