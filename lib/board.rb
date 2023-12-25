class Board
  include Helpers::CardHelper

  def initialize
    @flop = PokerHand.new
    @postflop = PokerHand.new
  end

  def deal_flop(deck)
    deck.burn
    @flop << deck.draw
    @flop << deck.draw
    @flop << deck.draw
  end

  def deal_postflop(deck)
    deck.burn
    @postflop << deck.draw
    deck.burn
    @postflop << deck.draw
  end

  def has_cards?
    # Flop is dealt before postflop
    @flop.size > 0
  end

  def full?
    cards.size == 5
  end

  def cards
    @flop + @postflop
  end

  def rank
    cards.rank
  end

  def to_s
    "Board   : #{ hand_str(@flop, 3) } | #{ hand_str(@postflop, 2) }"
  end
end