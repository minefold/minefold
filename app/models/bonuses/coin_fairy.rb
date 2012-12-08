class Bonuses::CoinFairy < Bonus
  self.coins = 20

  # Ewww
  def self.period
    30.days
  end

  def self.eligable_user_query
    table = User.arel_table

    table[:coins].lt(coins).and(
      table[:last_coin_fairy_visit_at].eq(nil).or(
        table[:last_coin_fairy_visit_at].lt(period.ago)))
  end

  def self.next_visit_for(user)
    i, t = 0, user.created_at
    until t.future?
      t += i * period
      i += 1
    end

    return t
  end

  def last_visit_at
    user.last_coin_fairy_visit_at || user.created_at
  end

  def claimable?
    coins > 0 && last_visit_at <= self.class.period.ago
  end

  def coins
    super - user.coins
  end

end
