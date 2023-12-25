class Game
  attr_reader :deck, :value

  # Assume bet size of 1
  # both ante and blind are 1 => one hand is 2
  # If dealer makes, ante is paid 1:1
  # If deal does not, ante is pushed (returned)
  def initialize(hands)
    @value = 0
    @hands = hands
    restart
  end

  def restart
    @dealers_cards = []
    @preflop_cards = []
    @postflop_cards = []
    @player_cards = (0..@hands - 1).map { |idx| [idx, []] }.to_h
    {
      0 => [],
      1 => [],
      2 => [],
      3 => [],
      4 => [],
      5 => [],
    }
    @deck = Deck.new
  end

  def play
    deal_players(false)
    deal_flop(false)
    deal_postflop(false)
    deal_dealer(false)

    print_state
    payout
  end

  def payout
    dealer_hand = PokerHand.new(@dealers_cards + @preflop_cards + @postflop_cards)

    @player_cards.each do |player, hand|
      player_hand = PokerHand.new(hand + @preflop_cards + @postflop_cards)
      payout = Payout.new(player_hand, dealer_hand).value

      puts "Player #{ player } #{ payout > 0 ? 'WINS' : 'LOSES' } #{ payout }"
      @value += payout
    end
  end

  def deal_players(print = true)
    starting_player = (0..5).to_a.sample

    (0..5).each do |player|
      player_idx = (starting_player + player) % 6

      @player_cards[player_idx] << deck.draw
      @player_cards[player_idx] << deck.draw
    end

    print_state if print
  end

  def deal_flop(print = true)
    @deck.burn
    @preflop_cards << @deck.draw
    @preflop_cards << @deck.draw
    @preflop_cards << @deck.draw

    print_state if print
  end

  def deal_postflop(print = true)
    @deck.burn
    @postflop_cards << @deck.draw
    @deck.burn
    @postflop_cards << @deck.draw

    print_state if print
  end

  def deal_dealer(print = true)
    @dealers_cards << @deck.draw
    @dealers_cards << @deck.draw

    print_state if print
  end

  def print_state
    puts "=== GAME STATE ==="
    puts "Dealer  : #{ hand_state_str(@dealers_cards) }"
    puts "Board   : #{ cards_str(@preflop_cards, 3) } | #{ cards_str(@postflop_cards, 2) }"

    (0..5).each do |player|
      puts player_state_str(player)
    end
  end

  def player_state_str(player)
    hand = @player_cards[player]
    "Player #{ player }: #{ hand_state_str(hand) }"
  end

  def hand_state_str(hand)
    if !(@preflop_cards.size > 0 || @postflop_cards.size > 0)
      cards_str(hand, 2)
    else
      poker_hand = PokerHand.new(hand + @preflop_cards + @postflop_cards)
      "#{ cards_str(hand, 2) } [#{ poker_hand.rank }]"
    end
  end

  def cards_str(cards, count)
    if cards.length == 0
      count.times.map { '??' }.join(', ')
    else
      cards.join(', ')
    end
  end

  def inspect
    print_state
    ""
  end
end
# TODO
# Fix bug for 7 hand evaluation in poker_hands
# 3.0.6 :022 > hand1 = PokerHand.new("Jh 6d Jd 6c Jc Ts Th")
# 3.0.6 :023 > hand2 = PokerHand.new("Jh 6d Jd 6c Jc 9s 9h")
# 3.0.6 :024 > hand1 > hand2
#  => false