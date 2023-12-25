module Helpers::CardHelper
  def cards_str(cards, count)
    if cards.length == 0
      count.times.map { '??' }.join(', ')
    else
      cards.join(', ')
    end
  end

  def hand_state_str(cards)
    if !@board.has_cards?
      # TODO: coupled to player and dealer hands
      cards_str(cards, 2)
    else
      cards_str(cards, 2) + " [#{ rank }]"
    end
  end
end