require 'spec_helper'

describe TimeHelper do

  describe "#time_left" do

    it 'raises an error when less than 0' do
      expect(time_left(-1)).to eq("No time")
      expect(time_left(0)).to eq("No time")
    end

    it 'pluralizes minutes when less than 1 hour' do
      expect(time_left(1)).to eq('1 min')
      expect(time_left(59)).to eq('59 mins')
    end

    it 'pluralizes hours when less than 240 hrs' do
      expect(time_left(60)).to eq('1 hr')
      expect(time_left(120)).to eq('2 hrs')
      expect(time_left(240 * 60 - 1)).to eq('239 hrs')
    end

    it 'pluralizes days when greater than 10 days' do
      expect(time_left(240 * 60)).to eq('10 days')
    end

  end

end
