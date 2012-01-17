# Removes credit events

User.all.each {|u| u.unset :credit_events }
