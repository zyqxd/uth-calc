class Driver
  attr_accessor :game

  def initialize
    @game = Game.new(6)
  end

  def play
    game.restart
    game.play
  end
end