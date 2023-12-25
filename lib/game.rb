class Game
  attr_reader :deck, :value, :players, :dealer, :board

  # Assume bet size of 1
  # both ante and blind are 1 => one hand is 2
  # If dealer makes, ante is paid 1:1
  # If deal does not, ante is pushed (returned)
  def initialize(hands)
    @hands = hands
    restart
  end

  def restart
    @board = Board.new
    @dealer = Dealer.new(@board)
    @players = (0...@hands).map { |idx| [idx, Player.new(idx, @board)] }.to_h
    @deck = Deck.new
    @value = 0
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
    dealer_hand = PokerHand.new(@dealer.full_hand)

    @players.each do |idx, player|
      player_hand = PokerHand.new(player.full_hand)
      payout = Payout.new(player_hand, dealer_hand).value

      puts "Player #{ idx } #{ payout > 0 ? 'WINS' : 'LOSES' } #{ payout }"
      @value += payout
    end

    nil
  end

  def deal_players(print = true)
    starting_idx = (0...@hands).to_a.sample

    (0...@hands).each do |idx|
      player_idx = (starting_idx + idx) % 6

      @players[player_idx].deal_hand(@deck)
    end

    print_state if print
  end

  def deal_flop(print = true)
    @board.deal_flop(@deck)

    print_state if print
  end

  def deal_postflop(print = true)
    @board.deal_postflop(@deck)

    print_state if print
  end

  def deal_dealer(print = true)
    @dealer.deal_hand(@deck)

    print_state if print
  end

  def print_state
    puts "=== GAME STATE ==="
    puts @dealer
    puts @board

    @players.each do |_idx, player|
      puts player
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