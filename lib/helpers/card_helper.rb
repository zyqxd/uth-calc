module Helpers::CardHelper
  def hand_str(hand, count)
    if hand.size == 0
      count.times.map { '??' }.join(', ')
    else
      hand.just_cards
    end
  end

  def hand_state_str(cards)
    if !@board.has_cards?
      hand_str(cards, 2)
    else
      hand_str(cards, 2) + " [#{ full_hand.rank }]"
    end
  end
end