require 'spec_helper'

describe Card do
  specify { have_field(:type) }
  specify { have_field(:country) }
  specify { have_field(:exp_year) }
  specify { have_field(:exp_month) }
  specify { have_field(:last4) }
end
