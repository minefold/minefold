module TimeHelper

  def time_left(coins)
    d = coins.minutes

    case d
    when (-Float::INFINITY)..0
      "No time"
    when 1...(1.hour)
      pluralize(d / 1.minute, 'min', 'mins')
    when (1.hour)...(10.days)
      pluralize(d / 1.hour, 'hr', 'hrs')
    else
      pluralize(d / 1.day, 'day', 'days')
    end
  end

end
