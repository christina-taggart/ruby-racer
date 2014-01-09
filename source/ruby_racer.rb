require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length

  def initialize(players, length = 30)
    @tracks = []
    @finish_line = length-1
    players.each_with_index do |player, index|
      @tracks << Array.new(length)
      @tracks[index][0] = player
    end
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    @tracks.each do |track|
      if track[@finish_line] != nil
        return true
      end
    end
    false
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    @tracks.each do |track|
      return track[@finish_line] if track[@finish_line] != nil
    end
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    @tracks.each do |track|
      if track.include?(player)
        spaces = rand(6)+1
        old_space = track.index(player)
        new_space = old_space + spaces
        new_space = @finish_line if new_space > @finish_line
        track.replace(swap(track, old_space, new_space))
      end
    end
  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    @tracks.each do |track|
      player = track.compact[0]
      reputs(track_to_string(track, player))
    end
  end

  private

  # Helper method for advance_player!
  def swap(track, a, b)
    track[a], track[b] = track[b], track[a]
    track
  end

  def track_to_string(track, player)
    track_string = ""
    track.each do |space|
      track_string += "| #{player} |" if space == player
      track_string += "|   |" if space == nil
    end
    track_string
  end
end

players = ['a', 'b', 'c', 'd', 'e']

game = RubyRacer.new(players, 15)

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
system("clear")
game.print_board

puts "Player '#{game.winner}' has won!"


#-----DRIVERS-----