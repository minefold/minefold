class StatsController < ApplicationController
  respond_to :html, :js, :json

  def sessions
    sessions = {}
    ServerSession.unscoped.
        where('started_at is not null').
        where('ended_at is not null').
        where('started_at > ?', [Time.now - 1.week]).
        find_each do |s|

      sessions[s.server_id] ||= []
      sessions[s.server_id] << (s.ended_at - s.started_at)
    end

    hours = sessions.select{|_, sessions| sessions.size > 0 }.map do |_, sessions|
      (sessions.sum / 60 / 60).floor
    end.sort

    # ignore servers with 0 hours (this includes the 30 min free servers)
    non_zeros = hours.reject{|h| h == 0}

    @histogram = histogram(
      [0..5, 6..10, 11..15, 16..20, 21..30, 31..40, 41..50],
      non_zeros)
  end

  # private

  def histogram(bins, values)
    grouped = values.group_by do |v|
      
      bin = bins.find{|b| b.include?(v) }
      bin || "#{bins.last.max}+"
    end

    datapoints = values.size
    percentages = grouped.inject({}) do |h, (bin, values)|
      label = bin.is_a?(Range) ? bin.minmax.join(' - ') : bin.to_s
      h[label] = ((values.size / datapoints.to_f) * 100).round(2)
      h
    end
  end
end
