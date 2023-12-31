class Deck
  FULL_DECK = [
    '2H','3H','4H','5H','6H','7H','8H','9H','TH','JH','QH','KH','AH',
    '2D','3D','4D','5D','6D','7D','8D','9D','TD','JD','QD','KD','AD',
    '2C','3C','4C','5C','6C','7C','8C','9C','TC','JC','QC','KC','AC',
    '2S','3S','4S','5S','6S','7S','8S','9S','TS','JS','QS','KS','AS',
  ]

  def initialize
    @cards = FULL_DECK.dup.shuffle.map { |card| Card.new(card) }
  end

  def draw
    raise "NO CARDS LEFT" if @cards.empty?

    @cards.pop
  end

  def burn
    raise "NO CARDS LEFT" if @cards.empty?

    @cards.pop
    nil
  end
end