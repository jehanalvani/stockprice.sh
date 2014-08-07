stockprice.sh
=============

BASH script for displaying historical daily stock prices. References the Yahoo Finance API. 

stockprice.sh expects two variables to be passed into it: first, a valid stock symbol; second, the number of days of stock prices to retrieve.

I use this to pipe output into `spark`.

Usage:

	> stockprice.sh $symbol $days_to_read [-q]

$symbol (required) is the stock ticker symbol of the company you want to track
$days_to_read (required) is the number of days of data you want to read out of the file
-q (currently, must be the third option) will run in "quiet" mode, which returns only the closing stock prices for each day, omitting date and headers.