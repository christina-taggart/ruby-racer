require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :race_length

  def initialize(players, length = 30)
    @board = []
    @race_length = length - 1
    players.each do |player|
      @board << create_track(player)
    end
    @die = Die.new
  end

  def create_track(player)
    track = [player]
    @race_length.times {track << "_"}
    return track
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    @board.any? { |row| row[-1] != "_" }
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    if finished?
      @board.select {|row| row[-1] != "_"}.map { |winner_row| p winner_row[-1] }
    else
      nil
    end
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    current_row = @board.select { |row| row.include?(player) }[0]

    new_pos = @die.roll + current_row.index(player)

    new_pos = current_row.length-1 if new_pos >= current_row.length

    current_row[new_pos] = player
    current_row[current_row.index(player)] = "_"

  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    @board.each {|row| reputs row.to_s }
  end
end

players = ['a', 'b', 'c', 'd']

game = RubyRacer.new(players, 10)

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
puts "======= Winning Game Board ========="
game.print_board

puts "Player '#{game.winner}' has won!"
