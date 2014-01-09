require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length

  def initialize(players, length = 30)
    @player_a = players[0]
    @player_b = players[1]
    @a_track = Array.new(30)
    @a_track[0] = @player_a
    @b_track = Array.new(30)
    @b_track[0] = @player_b
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    @a_track[29] == "a" || @b_track[29] == "b"
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    return "a" if @a_track[29] == "a"
    return "b" if @b_track[29] == "b"
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    current_track = @a_track if player = "a"
    current_track = @b_track if player = "b"
    spaces = rand(6)+1
    old_space = current_track.index(player)
    new_space = old_space + spaces
    new_space = 29 if new_space > 29
    swap(current_track, old_space, new_space)
    @a_track.replace(current_track) if player = "a"
    @b_track.replace(current_track) if player = "b"
  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    reputs(track_to_string(@a_track))
    reputs(track_to_string(@b_track))
    # p track_to_string(@a_track)
    # p track_to_string(@b_track)
  end

  private

  # Helper method for advance_player!
  def swap(track, a, b)
    track[a], track[b] = track[b], track[a]
  end

  def track_to_string(track)
    track_string = ""
    track.each do |space|
      track_string += "| a |" if space == "a"
      track_string += "| b |" if space == "b"
      track_string += "|   |" if space == nil
    end
    track_string
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


#-----DRIVERS-----