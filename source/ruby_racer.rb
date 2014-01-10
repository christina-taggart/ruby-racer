require_relative 'racer_utils'

class Player
  attr_accessor :name, :track, :position

  def initialize(name, track_length)
    @name = name
    @position = 0
    @track_length = track_length
    @track = create_track
  end

  def create_track
    track = []
    (@track_length * 2).times do |n|
      n.even? ? track << " " : track << "|"
    end

    track.join
  end

  def advance(spaces_to_move)
    @track = create_track
    @position += spaces_to_move
  end

end

class RubyRacer

  attr_reader :players_hash

  def initialize(player_names, length = 30)
    p1 = Player.new(player_names[0], length)
    p2 = Player.new(player_names[1], length)
    @length = length
    @players_hash = { p1.name => p1, p2.name => p2 }
    @die = Die.new
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    winner ? true : false
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    @players_hash.values.each do |player|
      return player.name if player.position >= @length - 1
    end

    nil
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player_name)
    @die.roll
    player = @players_hash[player_name]
    player.advance(@die.roll)
  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    @players_hash.values.each do |player|
      if player.position > @length
        player.position = @length
      end
      player.track[player.position * 2] = player.name
      puts player.track
    end
  end
end

player_names = ['a', 'b']

game = RubyRacer.new(player_names)
# This clears the screen, so the fun can begin
clear_screen!

until game.finished?
  player_names.each do |player_name|
    # This moves the cursor back to the upper-left of the screen
    move_to_home!

    # We print the board first so we see the initial, starting board
    game.print_board
    game.advance_player!(player_name)

    # We need to sleep a little, otherwise the game will blow right past us.
    # See http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-sleep
    sleep(0.5)
  end
end

# The game is over, so we need to print the "winning" board
clear_screen!
move_to_home!
game.print_board

puts "Player '#{game.winner}' has won!"