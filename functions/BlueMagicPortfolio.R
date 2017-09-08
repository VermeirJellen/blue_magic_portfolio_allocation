URL_BASE        <- "https://bluemagic.info/funds/"
URL_RETIREMENT  <- paste(URL_BASE, "retirement-fund", sep="")
URL_DYNAMIC     <- paste(URL_BASE, "dynamic-fund", sep="")
URL_EXTREME     <- paste(URL_BASE, "extrem-fund", sep="")

# URL_MOVEMENTS   <- "http://bluemagic.info/blog/movements/"

TABLE_ID_RETIREMENT <- "tablepress-15"
TABLE_ID_DYNAMIC    <- "tablepress-17"
TABLE_ID_EXTREME    <- "tablepress-19"

.ExtractAllocations <- function(response, table_id){
  page       <- htmlParse(response)
  x_coins    <- paste("//table[@id='", table_id, "']//td[@class='column-1']", sep="")
  coins      <- xpathSApply(doc = page, path = x_coins, fun = xmlValue)
  coins      <- gsub("[\\(,\\)]", "", lapply(coins, str_extract, pattern="\\(.*\\)"))
  
  x_alloc    <- paste("//table[@id='", table_id, "']//td[@class='column-5']", sep="")
  allocation <- as.numeric(xpathSApply(doc = page, path = x_alloc, fun = xmlValue))
  
  return (as.data.frame(x = allocation, row.names=coins))
}

BlueMagicPortfolio <- function(usd_allocation = NULL, 
                               btc_allocation = NULL,
                               weights        = c(1, 1, 1))
{
  ################################
  ######## INPUT CHECKING ########
  ################################
  stopifnot(inherits(weights, "numeric"))
  stopifnot(all(weights >= 0) & length(weights) == 3)
  stopifnot(!(is.null(usd_allocation) & is.null(btc_allocation)))
  
  if(!is.null(usd_allocation)){
    stopifnot(inherits(usd_allocation, "numeric"))
    stopifnot(usd_allocation > 0)
  }
  
  if(!is.null(btc_allocation)){
    stopifnot(inherits(btc_allocation, "numeric"))
    stopifnot(btc_allocation > 0)
  }
  
  if(!is.null(usd_allocation) & !is.null(btc_allocation)){
    warning(paste("usd_allocation and btc_allocation input arguments are both non-null:",
                  "Using usd_allocation value to perform the calculations."))
  }
  
  # Check availability of the website
  resp_code <- status_code(GET(URL_BASE))
  if(resp_code == "200"){
    
    ####################################################
    ####### SCRAPE BlUE MAGIC CAPITAL FUND PAGES #######
    ####################################################
    resp_retirement <- GET(URL_RETIREMENT)
    resp_dynamic    <- GET(URL_DYNAMIC)
    resp_extreme    <- GET(URL_EXTREME)
    
    stopifnot(status_code(resp_retirement) == "200")
    stopifnot(status_code(resp_dynamic)    == "200")
    stopifnot(status_code(resp_extreme)    == "200")
    
    tryCatch({
      port_retirement <- .ExtractAllocations(resp_retirement, TABLE_ID_RETIREMENT)
      port_dynamic    <- .ExtractAllocations(resp_dynamic,    TABLE_ID_DYNAMIC)
      port_extreme    <- .ExtractAllocations(resp_extreme,    TABLE_ID_EXTREME)
    },
    error=function(c) stop("Unable to parse Blue Magic fund data.. Aborting")
    )
    
    MergePortfolio <- function(x, y){
      merged <- merge(x, y, by="row.names", all=TRUE)
      rownames(merged) <- merged$Row.names
      merged$Row.names <- NULL
      
      merged
    }
    
    port_merged <- Reduce(MergePortfolio, list(port_retirement,
                                               port_dynamic,
                                               port_extreme))
    names(port_merged) <- c("retirement", "dynamic", "extreme")
    
    #####################################################
    ##### CALCULATE PERCENTAGE PORTFOLIO ALLOCATIONS ####
    #####################################################
    port_alloc <- sweep(port_merged, 2, weights, '*')
    port_alloc <- (port_alloc / sum(rowSums(port_alloc, na.rm = TRUE))) * 100
    port_alloc <- rowSums(port_alloc, na.rm = TRUE)
    
    requested_allocations        <- round(data.frame(port_alloc), 4)
    names(requested_allocations) <- "percentage"
    
    ##########################################################
    ##### FETCH BITCOIN PRICE DATA FROM COINMARKETCAP ########
    ##########################################################
    btc_price_url     <- "https://api.coinmarketcap.com/v1/ticker/bitcoin/?convert=USD"
    btc_price_resp    <- GET(url=btc_price_url)
    btc_response_code <- status_code(btc_price_resp)
    
    if(btc_response_code == 200) {
      
      btc_price <- as.numeric(content(btc_price_resp)[[1]]$price_usd)
      if(is.null(usd_allocation)) {
        usd_allocation = btc_price * btc_allocation
      }
      else {
        btc_allocation = usd_allocation / btc_price
      }
    }
    else {
      warning(paste("Could not retrieve Bitcoin price data:", 
                    "Unable to return BTC allocations."))
    }
    
    #####################################################
    ##### CALCULATE USD & BTC PORTFOLIO ALLOCATIONS #####
    #####################################################
    if(!is.null(btc_allocation)) {
      requested_allocations$btc <- as.numeric(unlist(round((port_alloc * btc_allocation) / 100, 4)))
    }
    
    if(!is.null(usd_allocation)) {
      requested_allocations$usd <- as.numeric(unlist(round((port_alloc * usd_allocation) /100, 2)))
    }
    
    # Add totals
    requested_allocations <- rbind(requested_allocations, 
                                   total = data.frame(t(colSums(requested_allocations))))
    
    ###############################
    #### RETURN RESULTS ###########
    ###############################
    return (list(requested_allocations  = requested_allocations,
                 blue_magic_allocations = port_merged,
                 weights                = weights,
                 usd_allocation         = usd_allocation,
                 btc_allocation         = btc_allocation) )
  }
  else{
    stop(paste("Unable to connect to ",
               URL_BASE, " (", resp_code, ")", sep=""))
  }
}