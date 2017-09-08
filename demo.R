source("config/Config.R")

####################################
######### RETIREMENT FUND ##########
####################################
# Retirement Fund (request 500k allocation)
bmc.retirement <- BlueMagicPortfolio(usd_allocation = 500000,
                                     weights        = c(1, 0, 0))

# output requested usd / btc allocations to follow the retirement fund.
bmc.retirement$requested_allocations

# Output current bmc allocations (all funds)
bmc.retirement$blue_magic_allocations

# Shows the requested user weights that were given as input
bmc.retirement$weights

# shows the total dollar allocation amount (given as input)
bmc.retirement$usd_allocation

# Shows corresponding btc amount (calculated from dollar amount)
bmc.retirement$btc_allocation


####################################
########### DYNAMIC FUND ###########
####################################
# Dynamic Fund (request 200 bitcoin allocation)
bmc.dynamic <- BlueMagicPortfolio(btc_allocation = 200,
                                  weights        = c(0, 1, 0))

# Output requested usd / btc allocations to follow the dynamic fund.
bmc.dynamic$requested_allocations


####################################
########### EXTREME FUND ###########
####################################
# Extreme Fund (request 100k allocation)
bmc.extreme <- BlueMagicPortfolio(usd_allocation = 100000,
                                  weights        = c(0, 0, 1))
# Output requested usd / btc allocations to follow the extreme fund.
bmc.extreme$requested_allocations


####################################
########### WEIGHTS MIX ############
####################################
# Equal weights between the three funds: (1, 1, 1)-ratio. Request 1M allocation.
bmc.mixed <- BlueMagicPortfolio(usd_allocation = 1000000,
                                weights        = c(1, 1, 1))
bmc.mixed$requested_allocations