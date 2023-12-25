class Dealer
  include Helpers::CardHelper

  def initialize(board)
    @board = board
    @hand = PokerHand.new
  end

  def qualified?
    @board.full? && full_hand.rank != 'Highest Card'
  end

  def deal_hand(deck)
    @hand << deck.draw
    @hand << deck.draw
  end

  def full_hand
    @hand + @board.cards
  end

  def rank
    @hand.rank
  end

  def <=>(other)
    @hand <=> other
  end

  def to_s
    "Dealer  : #{ hand_state_str(@hand) }#{ qualified? ? ' | Qualified' : '' }"
  end
end