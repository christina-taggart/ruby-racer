require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length

  def initialize(players, length = 40)
    @die = Die.new
    @length = length
    @players = {}
    players.each {|name| @players[name] = 0 }
    @finshed = false
    @winner = ''
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    @finished
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    @winner
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    new_position = @players[player] + @die.roll

    if new_position >= @length - 1
      @finished = true
      @players[player] = @length - 1
      if @winner == ''
        @winner = player
      end
    else
      @players[player] = new_position
    end
  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    @players.each { |thing| print_board_for_player(thing[1], thing[0]) }
  end

  def print_board_for_player(player_position, player_name)
    track = (" " * @length).split("")
    track[player_position] = player_name
    puts track.join("|")
  end
end

players = ['d', 'a']

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
    sleep(0.2)
  end
end

# The game is over, so we need to print the "winning" board
move_to_home!
game.print_board

puts "Player '#{game.winner}' has won!"