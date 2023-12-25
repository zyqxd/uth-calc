class Payout
  BLINDS_PAYOUT = {
    'Royal Flush' => 500,
    'Straight Flush' => 50,
    'Four of a kind' => 10,
    'Full house' => 3,
    'Flush' => 1.5,
    'Straight' => 1,
  }

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
  end

  def value
    is_win = @player.full_hand > @dealer.full_hand
    is_loss = @player.full_hand < @dealer.full_hand
    strategy = @player.strategy

    if is_loss
      - strategy.ante - strategy.blind - strategy.play
    elsif is_win && @dealer.qualified?
      strategy.ante + strategy.play + blind_value(strategy.blind)
    elsif is_win && !@dealer_qualified
      strategy.play + blind_value(strategy.blind)
    else
      0
    end
  end

  def ante_value
    1
  end

  def blind_value(blind)
    (BLINDS_PAYOUT[@player.rank] || 0) * blind
  end
end