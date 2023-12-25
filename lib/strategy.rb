class Strategy
  attr_accessor :ante, :blind, :play

  CARDS = {
    'A' => Card.new('A', 'S'),
    'K' => Card.new('K', 'S'),
    'Q' => Card.new('Q', 'S'),
    'J' => Card.new('J', 'S'),
    'T' => Card.new('T', 'S'),
    '9' => Card.new('9', 'S'),
    '8' => Card.new('8', 'S'),
    '7' => Card.new('7', 'S'),
    '6' => Card.new('6', 'S'),
    '5' => Card.new('5', 'S'),
    '4' => Card.new('4', 'S'),
    '3' => Card.new('3', 'S'),
    '2' => Card.new('2', 'S'),
  }

  def initialize
    @ante = 1
    @blind = 1
    @play = 0
  end

  # [x] Suited King + Any raise
  # [x] Suited Q6 or better raise
  # [x] Suited J8 or better raise
  # [x] Unsuited K5 or better raise
  # [x] Unsuited Q8 or better raise
  # [x] Unsuited JT or better raise
  # [x] All others check
  def preflop(hand)
    hand = hand.sort.reverse
    suited = hand[0].suit == hand[1].suit

    # Pair of 3's or better
    if hand[0].face == hand[1].face && hand[0] >= CARDS['3']
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
      elsif hand[1] >= CARDS['5']
        @play = 4
      end

    # Any Queen
    elsif hand[0].face == 11
      # Q6s or better
      if suited && hand[1] >= CARDS['6']
        @play = 4

      # Q8o or better
      elsif hand[1] >= CARDS['8']
        @play = 4
      end

    # Any Jack
    elsif hand[0].face == 10
      # J8s or better
      if suited && hand[1] >= CARDS['8']
        @play = 4

      # JT or better
      elsif hand[1] >= CARDS['T']
        @play = 4
      end

    # Check
    else
      @play = 0
    end
  end

  # [x] No Pair always check
  # [x] One Pair raise if pair uses one of your cards. check if pair is on the board
  # [x] Two Pair always raise
  # [x] Trips raise if the trips uses one of your cards. check if trips is on the board
  # [x] All hands greater than Trips always raise
  def postflop(hand, board)
    return if play != 0

    combined = hand + board.cards
    if !['Three of a kind', 'Pair', 'Highest Card'].include?(combined.rank)
      @play = 2

    elsif combined.rank == 'Pair'
      @play = 2 if board.rank != 'Pair'

    elsif combined.rank == 'Three of a kind'
      @play = 2 if board.rank != 'Three of a kind'

    else # if combined.rank == 'Highest Card'
      @play = 0
    end
  end

  # [x] Your hand is better than Trips always raise
  # [x] You have Trips raise if the trips uses one of your cards or your lowest kicker is a 9. Otherwise, fold
  # [-] You have Two Pair raise if your 5-card hand is better than the board's 5-card hand, Raise if your kicker is a jack or better. Otherwise, fold
  # [x] You have a Pair raise if pair uses one of your cards or you have at least a Jack. Otherwise, fold
  # [ ] Scare Board and you have less than a pair always fold
  # [ ] The board is unpaired raise if you have 2nd nut kicker. Otherwise, fold
  # [ ] The board is paired raise if you have 3rd nut kicker. Otherwise, fold
  def river(hand, board, game)
    return if play != 0

    sorted_hand = hand.sort
    combined = hand + board.cards
    if !['Three of a kind', 'Pair', 'Two Pair', 'Highest Card'].include?(combined.rank)
      @play = 1

    elsif combined.rank == 'Three of a kind'
      @play = 1 if board.rank != 'Three of a kind' || sorted_hand[0] >= CARDS['9']

    elsif combined.rank == 'Two Pair'
      @play = 1 if combined > board # TODO or kicker is a jack or better

    elsif combined.rank == 'Pair'
      @play = 1 if board.rank != 'Pair' || sorted_hand[0] >= CARDS['J']

    else #if combined.rank == 'Highest Card'

      # if !game
      # TODO this is wrong, need to figure out scare board
      @play = 1 if sorted_hand[1] >= CARDS['J']
    end
  end
end