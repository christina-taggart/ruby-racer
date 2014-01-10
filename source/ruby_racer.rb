require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length

  def initialize(players, length = 30)
    @players = {}
    players.each{ |player| @players[player] = 0 }
    @length = length
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    @players.each{|name, position| return true if position == @length - 1}
    false
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    @players.each do |name, position|
      return name if position == @length - 1
    end
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    dice = Die.new
    @players[player] += dice.roll
    @players[player] = @length - 1 if @players[player] >= @length
  end

  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    board = []
    @players.each do |name, position|
      track = Array.new(@length)
      track[position] = name
      board << track
    end
    string_board = ""
    board.each{ |track| string_board << track.join("| ") + "\n"}

    reputs(string_board)
  end
end

players = ('a'..'z').to_a

game = RubyRacer.new(players, 50)

# This clears the screen, so the fun can begin
clear_screen!

until game.finished? #=> continue looping until "True"
  players.each do |player| #=> loop for each player, in this case [a,b]
    # This moves the cursor back to the upper-left of the screen
    move_to_home!

    # We print the board first so we see the initial, starting board
    game.print_board #=> puts starting board on screen
    game.advance_player!(player) #=> roll dice, advance (player) diceroll spaces and
                                 #=> reprint board with (player) in new space
    sleep(0.005)
  end
end

# The game is over, so we need to print the "winning" board
system("clear")
game.print_board

puts "Player '#{game.winner}' has won!"
