require_relative 'racer_utils'

class RubyRacer
  attr_reader  :length, :player_hash
  # attr_accessor :player_hash

  def initialize(players, length = 30)
    @player_hash = Hash[players.map.with_index { |x, i| [x, 0] }]
    @length = length
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    #return a value either true or false
    #false if race is still occuring
    #true if one of the players has reached the end
    max_score = @player_hash.max_by{|k,v| v}
       max_score[1] > 30
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    champion = @player_hash.max_by{|k,v| v}
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!
     # roll the dice for each player (one at a time)
     # add the value to the players distance
    @player_hash.map do |player, distance|
      @player_hash[player] += (rand(5) + 1)
    end

  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    @player_hash.each do |player, distance|
      track = []
      real_track = ""
        @length.times {track << "|     "}

      track[distance] = "|    #{player}"
        real_track = track.join
        puts real_track
      end

  end
end

players = ['a', 'b', 'c']

game = RubyRacer.new(players, 15)

# This clears the screen, so the fun can begin
clear_screen!

until game.finished?
    game.player_hash.each do |player, distance|
    # This moves the cursor back to the upper-left of the screen
    move_to_home!

    # We print the board first so we see the initial, starting board
    game.print_board

    game.advance_player!

    # We need to sleep a little, otherwise the game will blow right past us.
    # See http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-sleep
    sleep(0.5)
  end
end

# The game is over, so we need to print the "winning" board
system("clear")
game.print_board

puts "Player '#{game.winner}' has won!"



