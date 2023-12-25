class Driver
  attr_accessor :game

  def initialize
    @game = Game.new(6)

    @hands_played = 0
    @hands_won = 0
    @value = 0
  end

  def play
    game.restart
    game.play

    @hands_played += 6
    @value += game.value
    # TODO: Figure out hands won
    # @hands_won += 1 if game.value > 0
  end

  def ev
    @value / @hands_played.to_f
  end

  def winrate
    @hands_won / @hands_played.to_f
  end
end