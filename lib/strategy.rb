class Strategy
  attr_accessor :ante, :blind, :play

  def initialize
    @ante = 1
    @blind = 1
    @play = 0
  end

  # Suited King + Any	raise
  # Suited Q6 or better	raise
  # Suited J8 or better	raise
  # Unsuited K5 or better	raise
  # Unsuited Q8 or better	raise
  # Unsuited JT or better	raise
  # All others check
  THREE = Card.new('3', 'S')
  FIVE = Card.new('5', 'S')
  SIX = Card.new('6', 'S')
  EIGHT = Card.new('8', 'S')
  TEN = Card.new('T', 'S')
  def preflop(hand)
    hand = hand.sort.reverse
    suited = hand[0].suit == hand[1].suit

    # Pair of 3's or better
    if hand[0].face == hand[1].face && hand[0] >= THREE
      @play = 4

    # Any Ace
    elsif hand[0].face == 13
      @play = 4

    # Any King
    elsif hand[0].face == 12
      # Any suited
      if suited
        @play = 4

      # K5o or better
      elsif hand[1] >= FIVE
        @play = 4
      end

    # Any Queen
    elsif hand[0].face == 11
      # Q6s or better
      if suited && hand[1] >= SIX
        @play = 4

      # Q8o or better
      elsif hand[1] >= EIGHT
        @play = 4
      end

    # Any Jack
    elsif hand[0].face == 10
      # J8s or better
      if suited && hand[1] >= EIGHT
        @play = 4

      # JT or better
      elsif hand[1] >= TEN
        @play = 4
      end

    # Check
    else
      @play = 0
    end
  end

  # No Pair	always check
  # One Pair	raise if pair uses one of your cards. check if pair is on the board (community cards).
  # Two Pair	always raise
  # Trips	raise if the trips uses one of your cards. check if trips is on the board (community cards).
  # All hands greater than Trips	always raise
  def postflop(hand, board)
    return if play != 0

    hand = PokerHand.new(hand + board)
    if !['Three of a kind', 'Pair', 'Highest Card'].include?(hand.rank)
      @play = 2

    elsif hand.rank == 'Pair'
      if PokerHand.new(board).rank != 'Pair'
        @play = 2
      end

    elsif hand.rank == 'Three of a kind'
      if PokerHand.new(board).rank != 'Three of a kind'
        @play = 2
      end
    else # if hand.rank == 'Highest Card'
      @play = 0
    end
  end

  def payout(hand, board)
    # min pair or < 21 visible outs
  end
end