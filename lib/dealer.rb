class Dealer
  include Helpers::CardHelper

  def initialize(board)
    @board = board
    @hand = []
  end

  def qualified?
    @board.full? &&
      PokerHand.new(full_hand).rank != 'Highest Card'
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
    "Dealer  : #{ hand_state_str(@hand) }#{ qualified? ? ' | Qualified' : '' }"
  end
end