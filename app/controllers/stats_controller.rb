require 'stats'

class StatsController < ApplicationController
  respond_to :html, :js, :json

  def sessions
    weeks = 1
    sessions = {}
    ServerSession.unscoped.
        where('server_sessions.ended_at is not null').
        where('server_sessions.server_id is not null').
        where('server_sessions.started_at > ?', [Time.now - weeks.weeks]).
        joins(:server => :creator).
        includes(:server => :creator).
        find_each do |s|

      if !s.server.nil? && s.server.creator.customer?
        sessions[s.server.creator_id] ||= []
        sessions[s.server.creator_id] << (s.ended_at - s.started_at)
      end
    end

    hours = sessions.select{|_, sessions| sessions.size > 0 }.map do |_, sessions|
      (sessions.sum / 60 / 60).floor
    end.sort

    # ignore servers with 0 hours (this includes the 30 min free servers)
    non_zeros = hours.map{|i| i / 4.0 }.map(&:round).reject{|h| h == 0}

    @mean = non_zeros.mean
    @stdev = non_zeros.standard_deviation

    @histogram = histogram(
      [
        0..5, 6..10, 11..15, 16..20, 21..25, 26..30, 31..35, 36..40, 41..45,
        46..50, 51..55, 56..60, 61..65, 66..70, 71..80
      ],
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
