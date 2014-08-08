stockprice.sh
=============

BASH script for displaying historical daily stock prices. References the Yahoo Finance API. 


I use this to pipe output into `spark`, eg. 

	> stockprice.sh -s AAPL -d 10 -q | tail -r | spark
	> ▅█▆▆▂▃▂▂▁▁
	>

Usage:

	> stockprice.sh [-s SYMBOL -d DAYS [-q]]

`$symbol` (required) is the stock ticker symbol of the company you want to track		
`$days_to_read` is the number of days of data you want to read out of the file. Defaults to 1. 
`-q` Will run in "quiet" mode, which returns only the closing stock prices for each day, omitting date and headers.		
