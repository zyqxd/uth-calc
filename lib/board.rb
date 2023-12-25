class Board
  include Helpers::CardHelper

  def initialize
    @preflop_cards = []
    @postflop_cards = []
  end

  def deal_flop(deck)
    deck.burn
    @preflop_cards << deck.draw
    @preflop_cards << deck.draw
    @preflop_cards << deck.draw
  end

  def deal_postflop(deck)
    deck.burn
    @postflop_cards << deck.draw
    deck.burn
    @postflop_cards << deck.draw
  end

  def has_cards?
    @preflop_cards.size > 0 || @postflop_cards.size > 0
  end

  def full?
    cards.size == 5
  end

  def cards
    @preflop_cards + @postflop_cards
  end

  def to_s
    "Board   : #{ cards_str(@preflop_cards, 3) } | #{ cards_str(@postflop_cards, 2) }"
  end
end