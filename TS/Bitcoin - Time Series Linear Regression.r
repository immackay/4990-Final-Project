require(jsonlite)

##############################################
# get.polo.url()
#
#   Creates a poloniex api call url
#   Either for training (train=T) or testing (train=F)
#   Testing end is 90 days past training end
#
# @param start, default=1
#   The start of your training dataset
# @param end, default=1
#   The end of your training dataset
# @param pair, default="USDT_BTC"
#   Token pairs, taken from the market list on https://poloniex.com/
# @param period, default=86400
#   Period of dataset in seconds, default=1 day
# @param train, default=TRUE
#   Whether you want the training or testing url
# @returns string
#   API URL for accessing poloniex data
##############################################
get.polo.url <- function(start=1, end=1, pair="USDT_BTC", period=86400, train=TRUE) {
  # Returns OHLC + Volume
  POLO_URL <- "https://poloniex.com/public?command=returnChartData&currencyPair=%s&start=%d&end=%d&period=%i"
  # Returns tick by tick trades (max 50000)
  # POLO_URL2 <- "https://poloniex.com/public?command=returnTradeHistory&currencyPair=%s&start=%d&end=%d"

  START <- as.numeric(as.POSIXct(sprintf("2013-%d-01", start)), tz="GMT")
  END <- as.numeric(as.POSIXct(sprintf("2017-%d-01", end)), tz="GMT")
  PRED_START <- as.numeric(as.POSIXct(sprintf("2017-%d-01", end)), tz="GMT")
  PRED_END <- as.numeric(as.POSIXct(sprintf("2017-%d-01", end)), tz="GMT")+7776000
  # PERIOD_VALUES <- c(300, 7200, 86400)
  # 5min, 2hours, 24hours
  PREDICTION_LENGTH <- 90*86400/PERIOD # days
  if(train) {
    return(sprintf(POLO_URL, pair, START, END, period))
  }
  else {
    return(sprintf(POLO_URL, pair, PRED_START, PRED_END, period))
  }
}

# -------------------------------
# Data Creation and Visualization
# -------------------------------
df <- fromJSON(get.polo.url(start=1, end=1))
pred_df <- fromJSON(get.polo.url(start=1,end=1,train=F))
train <- ts(df[8])
test <- ts(pred_df[8])

plot(log(c(train, test)), type="l", xlab="Time (Days)", ylab="Log of Volume Weighted Average Price", main="VWAP vs Time")
lines(x=seq(length(train)+1, length(train)+length(test)), y=log(test), col="red")

# -----------
# Differences
# -----------
plot(diff(train), ylab="Lagged Difference of VWAP", xlab="Time (Days)", main="diff(VWAP) vs Time")
abline(h=0)

# --------------
# ACFs and PACFs
# --------------
acf(diff(train), lag.max=50, main="ACF of diff(train)")
pacf(diff(train), lag.max=50, main="PACF of diff(train)")
acf(diff(diff(train)), lag.max=50, main="ACF of diff(diff(train))")
pacf(diff(diff(train)), lag.max=50, main="PACF of diff(diff(train))")

# --------------------
# Model and Prediction
# --------------------
ARIMA <- arima(train, order=c(1,1,0), seasonal=list(order=c(1,1,1), period=41))
print(AIC(ARIMA))
print(BIC(ARIMA))
ARIMA.pred <- predict(ARIMA, n.ahead=PREDICTION_LENGTH)
error <- abs((c(test)-ARIMA.pred$pred))
error <- ((error/max(error))*(min(log(test))/max(log(test))))+min(log(test))
plot(log(test), lwd=2, xlab="Time (Days)", ylab="Log of VWAP", main="Log of Bitcoin VWAP\nPrediction compared to Actual Prices")
lines(x=seq(along=test), log(ARIMA.pred$pred), col="blue", lwd=1)
plot(log(ts(df2[8])), type='l', main="Log of Bitcoin VWAP with ARIMA prediction", ylab="Log of VWAP")
lines(x=seq(length(series)+1, length(series)+length(ARIMA.pred$pred)), y=log(ARIMA.pred$pred), col="red")

# ------------------------
# Recurrent Neural Network
# ------------------------
library(rnn)
df <- fromJSON(get.polo.url(start=1, end=1))
X = matrix(1:680, nrow=34)
Y = matrix(df[1:680,8], nrow=34)

# Conform to interval [0,1]
X <- (X-min(X)) / (max(X)-min(X))
Y <- (Y-min(Y)) / (max(Y)-min(Y))

# Transpose
X <- t(X)
Y <- t(Y)

train <- 1:15
test <- 16:20

model <- trainr(Y = Y[train,],
                X = X[train,],
                learningrate = 0.05,
                hidden_dim = c(16,8),
                numepochs = 1000)

Y.pred <- predictr(model, X)

plot(as.vector(t(Y)), col="red", type="l", main="Actual vs Predicted", ylab="Y, Y.pred")
lines(as.vector(t(Y.pred)), type="l", col="blue")