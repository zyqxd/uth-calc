class Payout
  BLINDS_PAYOUT = {
    'Royal Flush' => 500,
    'Straight Flush' => 50,
    'Four of a kind' => 10,
    'Full house' => 3,
    'Flush' => 1.5,
    'Straight' => 1,
  }

  def initialize(player_hand, dealer_hand)
    @player_hand = player_hand
    @dealer_hand = dealer_hand
    @dealer_qualified = dealer_hand.rank != 'Highest Card'
  end

  def value
    is_win = @player_hand > @dealer_hand
    is_loss = @player_hand < @dealer_hand
    if is_loss
      - ante_value - play_value - 1 # -1 for blind
    elsif is_win && @dealer_qualified
      ante_value + blind_value + play_value
    elsif is_win && !@dealer_qualified
      blind_value + play_value
    else
      0
    end
  end

  def ante_value
    1
  end

  def blind_value
    BLINDS_PAYOUT[@player_hand.rank] || 0
  end

  # TODO
  def play_value
    0
  end
end