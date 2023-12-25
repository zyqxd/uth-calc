class Player
  include Helpers::CardHelper

  def initialize(idx, board, strategy = nil)
    @player = idx
    @board = board
    # TODO
    @strategy = strategy
    @hand = []
  end

  def deal_hand(deck)
    @hand = [deck.draw, deck.draw]
  end

  def full_hand
    @hand + @board.cards
  end

  def rank
    PokerHand.new(full_hand).rank
  end

  def <=>(other)
    PokerHand.new(full_hand) <=> other
  end

  def to_s
    "Player #{ @player }: #{ hand_state_str(@hand) }"
  end
end