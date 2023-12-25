class Driver
  attr_accessor :game

  def initialize(hands)
    @hands = hands
    @game = Game.new(hands)

    @hands_played = 0
    @hands_won = 0
    @value = 0
  end

  def play(n = 1)
    n.times { play_hand }

    puts "Total hands played: #{ @hands_played }"
    puts "Ending value      : #{ @value }"
    puts "EV                : #{ ev }"
    puts "Winrate           : #{ (winrate * 100).round(2) }%"
  end

  def play_hand
    game.restart
    game.play(true)

    @hands_played += @hands
    @hands_won += game.hands_won
    @value += game.value
  end

  def ev
    @value / @hands_played.to_f
  end

  def winrate
    @hands_won / @hands_played.to_f
  end
end