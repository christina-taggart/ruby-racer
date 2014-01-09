require_relative 'racer_utils'

class RubyRacer
  attr_reader :players, :length, :over, :winners

  def initialize(players, length = 50)
    @players = players.map! {|player| Player.new(player)}
    @length = length
    @over = false
  end

  def finished?
    players.each {|player| player.win ? @over = true : @over = false }
  end

  def print_board
    board = ("|_" * @length)[1..-1]
    total_board = []
    players.length.times {total_board << board}

    counter = 0
    new_board = total_board.map do |row|
      position = players[counter].position - 1
      row = ("|_" * @length)[1..-1]
      marker = players[counter].name[0]

      track_unit = 2
      if position >= @length
        position = @length - 1
        @over = true
      end
      row = ("|_" * @length)[1..-1]
      row[position*track_unit] = marker
      puts players[counter].position
      puts row
      counter += 1
    end
  end
end

class Player
  attr_reader :name, :position, :die, :win
  def initialize(name)
    @name = name
    @position = 0
    @die = Die.new
    @win = false
  end

    # Rolls the dice and advances +player+ accordingly
  def advance
    @position += @die.roll
  end

  # Returns the winner if there is one, +nil+ otherwise
  def winner(game)
    @win = true if @position >= game.length
  end
end


game = RubyRacer.new(["Andy", "Matt", "Bob"])
# This clears the screen, so the fun can begin
clear_screen!

until game.over

  game.players.each do |player|
    move_to_home!
    player.advance
    game.print_board
    player.winner(game)
    sleep(0.1)
  end
end

puts "The winning board is:"
game.print_board

winners = game.players.find_all {|player| player.win}
  winners.map! {|winner| winner.name}
  if winners.length > 1
    winners = winners.join(" and ")
  else
    winners = winners[0]
  end


puts "#{winners} won!"
