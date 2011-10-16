require 'spec_helper'

describe Card do
  it {should have_field(:type)}
  it {should have_field(:country)}
  it {should have_field(:exp_year)}
  it {should have_field(:exp_month)}
  it {should have_field(:last4)}
end
