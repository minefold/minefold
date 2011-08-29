tmp_password = 'carlsmum'

chris = User.create username: 'chrislloyd',
                       email: 'chris@minefold.com'
                    password: tmp_password,
       password_confirmation: tmp_password

dave = User.create username: 'whatupdave',
                      email: 'dave@minefold.com'
                   password: tmp_password,
      password_confirmation: tmp_password

World.create name: 'Minefold',
          creator: chris
