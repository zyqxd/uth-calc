class Player
  include Helpers::CardHelper

  attr_reader :strategy, :player

  def initialize(idx, board, game = nil)
    @player = idx
    @board = board
    @strategy = Strategy.new
    @hand = PokerHand.new
    @game = game
  end

  def play_preflop
    @strategy.preflop(@hand)
  end

  def play_postflop
    @strategy.postflop(@hand, @board)
  end

  def play_river
    @strategy.river(@hand, @board, @game)
  end

  def deal_hand(deck)
    @hand << deck.draw
    @hand << deck.draw
  end

  def full_hand
    @hand + @board.cards
  end

  def rank
    full_hand.rank
  end

  def <=>(other)
    @hand <=> other
  end

  def to_s
    "Player #{ @player }: #{ hand_state_str(@hand) }"
  end
end