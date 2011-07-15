user = User.new email: 'dave@minefold.com', username:'whatupdave'
user.password = user.password_confirmation = 'foo'
user.save!