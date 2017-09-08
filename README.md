Blue Magic Capital - Portfolio Allocation
================

The `BlueMagicPortfolio` function can be used to easily copy the fund allocations from the [Blue Magic Capital website](http://bluemagic.info/ "Blue Magic Capital").

Note: The readme file below was last updated on sep 08, 2017. The file does not auto-update. Hence, the outputs below might be outdated. You should run the function locally to request up to date fund-allocation information.

Usage
=====

To use the `BlueMagicPortfolio` function, the user should input the total usd or btc amount to invest in combination with the requested weight structure between the three funds. The function subsequently outputs the corresponding percentage, btc and usd amounts that should be allocated to the individual assets that are contained in the funds.

### Inputs:

-   `usd_allocation`: Total amount of usd to invest.
-   `btc_allocation`: Total amount of btc to invest.
-   `weights`: Weight allocation between the three funds (retirement / dynamic / extreme).

Only one of `usd_allocation` or `btc_allocation` should be given as input. The btc to usd conversion is done using [coinmarketcap.com](https://coinmarketcap.com/) BTC pricing data.

### Outputs:

A list containing the following information:

-   `requested_allocations`: a `data.frame` containing the requested percentage, usd and btc allocations for the assets in the funds.
-   `blue_magic_allocations`: a `data.frame` containing an overview of percentage allocations for the three bmc funds.
-   `weights`: Identical to `weights` inputs.
-   `usd_allocation`: Total usd amount invested.
-   `btc_allocation`: Total btc amount invested.

Note: one of `usd_allocation` or `btc_allocation` is identical to the input value, the other value will be calculated by using the coinmarket.com Bitcoin price.

Examples
========

Retirement Fund
---------------

#### Request 500k USD Allocation

``` r
source("config/Config.R")
# Retirement Fund (request 500k allocation)
bmc.retirement <- BlueMagicPortfolio(usd_allocation = 500000,
                                     weights        = c(1, 0, 0))
# output requested usd / btc allocations to follow the retirement fund.
bmc.retirement$requested_allocations
```

    ##       percentage      btc       usd
    ## BTC      46.8053  54.8753 234026.60
    ## DAR       0.0000   0.0000      0.00
    ## DCR       4.6395   5.4395  23197.68
    ## FCT       3.9796   4.6657  19898.01
    ## FLO       0.0000   0.0000      0.00
    ## GAME      7.3193   8.5812  36596.34
    ## GUP       0.0000   0.0000      0.00
    ## KMD       7.2693   8.5226  36346.37
    ## LSK       9.4891  11.1251  47445.26
    ## MAID      4.7795   5.6036  23897.61
    ## SC        7.0793   8.2999  35396.46
    ## UBQ       0.0000   0.0000      0.00
    ## WAVES     8.6391  10.1287  43195.68
    ## WINGS     0.0000   0.0000      0.00
    ## total   100.0000 117.2416 500000.01

#### BMC Percentage Allocations (All Funds).

``` r
bmc.retirement$blue_magic_allocations
```

    ##       retirement dynamic extreme
    ## BTC        46.81   25.57      NA
    ## DAR           NA      NA    1.87
    ## DCR         4.64   16.34      NA
    ## FCT         3.98      NA      NA
    ## FLO           NA      NA    9.86
    ## GAME        7.32   13.17      NA
    ## GUP           NA      NA    3.62
    ## KMD         7.27      NA      NA
    ## LSK         9.49      NA      NA
    ## MAID        4.78   16.75      NA
    ## SC          7.08    8.90      NA
    ## UBQ           NA      NA    7.12
    ## WAVES       8.64   19.28   44.15
    ## WINGS         NA      NA   33.38

#### Input Portfolio Weights (Retirement / Dynamic / Extreme).

``` r
bmc.retirement$weights
```

    ## [1] 1 0 0

#### Input Total USD Allocation.

``` r
bmc.retirement$usd_allocation
```

    ## [1] 5e+05

#### Total BTC Allocation - Calculated from USD Amount.

``` r
bmc.retirement$btc_allocation
```

    ## [1] 117.2415

Dynamic Fund
------------

#### Request 200 BTC Allocation.

``` r
bmc.dynamic <- BlueMagicPortfolio(btc_allocation = 200,
                                  weights        = c(0, 1, 0))
# Output requested usd / btc allocations to follow the dynamic fund.
bmc.dynamic$requested_allocations
```

    ##       percentage      btc       usd
    ## BTC      25.5674  51.1349 218074.95
    ## DAR       0.0000   0.0000      0.00
    ## DCR      16.3384  32.6767 139356.46
    ## FCT       0.0000   0.0000      0.00
    ## FLO       0.0000   0.0000      0.00
    ## GAME     13.1687  26.3374 112320.97
    ## GUP       0.0000   0.0000      0.00
    ## KMD       0.0000   0.0000      0.00
    ## LSK       0.0000   0.0000      0.00
    ## MAID     16.7483  33.4967 142853.16
    ## SC        8.8991  17.7982  75904.07
    ## UBQ       0.0000   0.0000      0.00
    ## WAVES    19.2781  38.5561 164430.39
    ## WINGS     0.0000   0.0000      0.00
    ## total   100.0000 200.0000 852940.00

Extreme Fund
------------

#### Request 100k USD Allocation.

``` r
bmc.extreme <- BlueMagicPortfolio(usd_allocation = 100000,
                                  weights        = c(0, 0, 1))
# Output requested usd / btc allocations to follow the extreme fund.
bmc.extreme$requested_allocations
```

    ##       percentage     btc    usd
    ## BTC         0.00  0.0000      0
    ## DAR         1.87  0.4385   1870
    ## DCR         0.00  0.0000      0
    ## FCT         0.00  0.0000      0
    ## FLO         9.86  2.3120   9860
    ## GAME        0.00  0.0000      0
    ## GUP         3.62  0.8488   3620
    ## KMD         0.00  0.0000      0
    ## LSK         0.00  0.0000      0
    ## MAID        0.00  0.0000      0
    ## SC          0.00  0.0000      0
    ## UBQ         7.12  1.6695   7120
    ## WAVES      44.15 10.3524  44150
    ## WINGS      33.38  7.8270  33380
    ## total     100.00 23.4482 100000

Mixed Portfolio - Equal Weights
-------------------------------

#### Request 1M USD Allocation.

``` r
# Equal weights between the three funds: (1, 1, 1)-ratio. Request 1M allocation.
bmc.mixed <- BlueMagicPortfolio(usd_allocation = 1000000,
                                weights        = c(1, 1, 1))
bmc.mixed$requested_allocations
```

    ##       percentage      btc        usd
    ## BTC      24.1251  56.5692  241250.58
    ## DAR       0.6233   1.4615    6232.92
    ## DCR       6.9929  16.3971   69928.67
    ## FCT       1.3266   3.1106   13265.78
    ## FLO       3.2864   7.7062   32864.48
    ## GAME      6.8295  16.0141   68295.45
    ## GUP       1.2066   2.8292   12065.86
    ## KMD       2.4232   5.6819   24231.72
    ## LSK       3.1631   7.4170   31631.22
    ## MAID      7.1762  16.8269   71761.88
    ## SC        5.3263  12.4893   53263.12
    ## UBQ       2.3732   5.5647   23731.75
    ## WAVES    24.0217  56.3269  240217.32
    ## WINGS    11.1259  26.0884  111259.25
    ## total   100.0000 234.4830 1000000.00

Donations
---------

If you find this software useful and/or you would like to see additional extensions, feel free to donate some crypto:

-   BTC: 1QHtZLZ15Cmj4FPr5h5exDjYciBDhh7mzA
-   LTC: LhKf6MQ7LY1k8YMaAq9z3APz8kVyFX3L2M
-   ETH: 0x8E44D7C96896f2e0Cd5a6CC1A2e6a3716B85B479
-   DASH: Xvicgp3ga3sczHtLqt3ekt7fQ62G9KaKNB

Or preferably, donate some of my favorite coins :)

-   GAME: GMxcsDAaHCBkLnN42Fs9Dy1fpDiLNxSKX1
-   WAVES: 3PQ8KFdw2nWxQATsXQj8NJvSa1VhBcKePaf

Licensing
---------

Copyright 2017 Essential Data Science Consulting ltd. ([EssentialQuant.com](http://essentialquant.com "EssentialQuant") / <jellenvermeir@essentialquant.com>). This software is copyrighted under the MIT license: View added [LICENSE](./LICENSE) file.
