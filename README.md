stockprice.sh
=============

BASH script for displaying historical daily stock prices. References the Yahoo Finance API. 

stockprice.sh expects two variables to be passed into it: first, a valid stock symbol; second, the number of days of stock prices to retrieve.

I use this to pipe output into `spark`.