# Read the first 4 bytes
# Reverse to determine the block size
# Subtract 7 from the block size and divide by 10 to get the number of rooms
# Start reading in 10 byte chunks to extract the room number and room name
# return map in the following structure
#
# %{
#   50 => "crabshack",
#   99 => "copycrap",
#   "crabshack" => 50,
#   "copycrap" => 99
# }
#
# The data is stored twice as I expect we will need to lookup data in both directions at some point
