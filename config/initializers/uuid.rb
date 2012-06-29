# The UUID generator uses a state file to hold the MAC address and sequence
# number. On Heroku state isn't shared between processes so it's best to turn
# it off.

# Read more at: https://github.com/assaf/uuid

UUID.state_file = false
