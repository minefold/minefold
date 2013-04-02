class RenameBonusTypes < ActiveRecord::Migration
  def up
     Bonus.
      where(type: 'Bonuses::LinkedFacebook').
      update_all(type: 'Bonuses::LinkedFacebookAccount')

     Bonus.
      where(type: 'Bonuses::LinkedMinecraft').
      update_all(type: 'Bonuses::LinkedMojangAccount')
  end

  def down
  end
end
