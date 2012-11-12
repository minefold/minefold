require 'test_helper'

class BonusTest < ActiveSupport::TestCase

  # TODO Refactor out into more tests
  test ".claim!" do
    user = User.make!
    bonus = Class.new(Bonus) do
      def self.name; 'Ate Pie'; end
      def self.credits; 10; end
    end

    # Test that credits are actually incremented
    mock(user).increment_credits!(bonus.credits)

    # Tests wether it still assigns the bonus if the limit is reached
    stub(bonus).claims_left?(user) { true }
    assert_difference ->{ user.bonus_claims.where(bonus_type: bonus.name).count }, 1 do
      bonus.claim!(user)
    end

    stub(bonus).claims_left?(user) { false }
    assert_difference ->{ user.bonus_claims.where(bonus_type: bonus.name).count }, 0 do
      bonus.claim!(user)
    end
  end

end


