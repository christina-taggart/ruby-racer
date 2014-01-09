# encoding: utf-8
require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length, :board

  def initialize(players, length = 30)
    @player1 = [players[0], 0]
    @player2 = [players[1], 0]
    @length = length
    @board = Array.new(2) { Array.new(length, "") }
    @board[0][@player1[1]] = "1"
    @board[1][@player2[1]] = "2"
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    @player1[1] >= 30 ? true : false
    @player2[1] >= 30 ? true : false
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    if @player1[1] >= 30
      return @player1
    elsif @player2[1] >= 30
      return @player2
    else
      return nil
    end
  end

  # # Rolls the dice and advances +player+ accordingly
  # def advance_player!(player)
  #     player == 'a' ? 0 : 1
  #     dice = Die.new
  #     @board[player] += dice.roll
  #     flush!
  #     # @board[0].each_with_index { |chr, idx|  }
  #     @board[0][@player[1]] = "1"

  # end


  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    if player == 'a'
      playera_dice = Die.new
      @board[0][@player1[1]] = ""
      @player1[1] += playera_dice.roll
      @board[0][@player1[1]] = "1"
      @board[0].each_with_index {|chr, idx| @board[0][idx] = "" if chr.nil? }
    elsif player == 'b'
      playerb_dice = Die.new
      @board[1][@player2[1]] = ""
      @player2[1] += playerb_dice.roll
      @board[1][@player2[1]] = "2"
      @board[1].each_with_index {|chr, idx| @board[1][idx] = "" if chr.nil? }
    end
  end


  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    @board.each { |row| flush!; reputs row.to_s }
  end
end

players = ['a', 'b']

game = RubyRacer.new(players)

# This clears the screen, so the fun can begin
clear_screen!

until game.finished?
  players.each do |player|
    # This moves the cursor back to the upper-left of the screen
    move_to_home!

    # We print the board first so we see the initial, starting board
    game.print_board
    game.advance_player!(player)

    # We need to sleep a little, otherwise the game will blow right past us.
    # See http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-sleep
    sleep(0.25)
  end
end

# The game is over, so we need to print the "winning" board
clear_screen!
move_to_home!
game.print_board

puts "Player '#{game.winner}' has won!"




