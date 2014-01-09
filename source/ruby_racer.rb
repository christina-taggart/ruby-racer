require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length

  def initialize(players, length = 60)
    @players = Hash[players.map{|p| [p, 0]}]
    @length = length
    @die = Die.new
    @landmine = false
    @boost = false
  end

  # Returns +true+ if one of the players has reached
  # the finish line, +false+ otherwise
  def finished?
    @players.values.max >= @length
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner
    self.finished? ? @players.max_by{ |k, v| v}[0] : nil
  end

  # Rolls the dice and advances +player+ accordingly
  def advance_player!(player)
    @current_player_name = player[0]
    landmine_checker(player)
    boost_checker(player)
    @players[player] += @die.roll
  end

  def boost_checker(player)
    @boost = false
    if rand(5) == 3
      @boost = true
      @players[player] += 10
    end
  end

  def landmine_checker(player)
    @landmine = false
    if rand(5) == 3 && @players[player] >= 6
      @landmine = true
      @players[player] /= 2
    end
  end
  # Prints the current game board
  # The board should have the same dimensions each time
  # and you should use the "reputs" helper to print over
  # the previous board
  def print_board
    system("clear")
    max_name_length = @players.max_by{|k,v| k.length}[0].length

    @players.each do |player|
      name = player[0]
      name_offset = max_name_length - name.length

      player[1] > @length ? car_distance = @length : car_distance = player[1]
      @length - car_distance >= 0 ? offset = @length - car_distance : offset = 0

      if name == @current_player_name
        if @landmine
          special_effect = "LANDMINE!!!"
        elsif @boost
          special_effect = "TURBO-BOOST!!!"
        end
      end

      puts <<-eos
        #{" " * max_name_length}|#{"-" * @length} |
        #{" " * name_offset}#{name}|#{"=" * car_distance}>#{" " * offset}| #{special_effect}
        #{" " * max_name_length}|#{"_" * @length} |
      eos
    end
  end

end

players = ['a', 'b', 'alex', 'patrick']

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
