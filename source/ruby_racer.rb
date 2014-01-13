require_relative 'racer_utils'

class RubyRacer

  attr_reader :players, :length, :die

  def initialize(players, length = 30)
    @players = players.map {|player| Player.new(player)}
    @length = length
    @die = Die.new
    @space = ' |'
    @unit = @space.length
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    winner != nil
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    winner = @players.select {|player| player.position >= @length}
    return winner if winner != []
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    player.position += @die.roll
    player.position = length if player.position >= length # basically we don't want a player to go "past" the board
    player.track = @space*(@length-1)
    player.track[player.position*@unit] = player.symbol if player.position*@unit <= player.track.length
    player.track[player.track.length] = player.symbol if player.position*@unit > player.track.length
  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def create_tracks
    players.each {|player| player.track = @space*(@length)}
  end

  def print_board
    players.each{|player| puts player.track}
  end
end

class Player

  attr_reader :name, :symbol
  attr_accessor :win, :position, :track

  def initialize(name)
    @name = name
    @win = false
    @position = 0
    @track
    @symbol = @name[0]
  end

end

players = ['Matt','David','Rick']

game = RubyRacer.new(players)
game.create_tracks
# game.print_board

while !game.finished?
  game.players.each {|player| game.advance_player!(player)}
  game.print_board
  sleep(1.0)
  clear_screen!
  move_to_home!
end
puts "Final Results:"
game.print_board

# game.players.each {|player| p "#{player.name} is at position #{player.position}"}

# game.players.each {|player| p "#{player.name} won?: #{player.win}"}
# p game.winner
# p game.finished?
# a.win = true
# game.players.each {|player| p "#{player.name} won?: #{player.win}"}
# p game.winner
# p game.finished?







# This clears the screen, so the fun can begin
# clear_screen!

# until game.finished?
#   players.each do |player|
#     # This moves the cursor back to the upper-left of the screen
#     move_to_home!

#     # We print the board first so we see the initial, starting board
#     game.print_board
#     game.advance_player!(player)

#     # We need to sleep a little, otherwise the game will blow right past us.
#     # See http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-sleep
#     sleep(0.5)
#   end
# end

# # The game is over, so we need to print the "winning" board
# game.print_board

# puts "Player '#{game.winner}' has won!"
