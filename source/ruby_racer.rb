require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length

  def initialize(players, length = 30)
    @player1 = players.shift
    @player2 = players.pop
    @length = length
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    if @player1 == nil
      @player1 = true
    elsif @player2 == nil
      @player2 = true
    else
    end
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner

  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player1!(player)
    start = board[0,0]
    to_move = player.roll
    board[0,start + to_move] = current_position
    board[0,current_position+to_move]
  end

  def advance_player2!(player)
    start = board[0,0]
    to_move = player.roll
    board[1,start + to_move] = current_position
    board[1,current_position+to_move]
  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    p board = Array.new(2, Array.new(30, "[ ]"))
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
    sleep(0.5)
  end
end

# The game is over, so we need to print the "winning" board
game.print_board

puts "Player '#{game.winner}' has won!"
