#! /bin/bash


# Help function. 

helpfile()
{
cat << EOF
usage: $0 options

BASH script for displaying historical daily stock prices. References the Yahoo Finance API.

OPTIONS:
   -h      Help (Here you are).
   -s      Specify Stock Symbol (eg. AAPL)
   -d      Specify number of days to read
   -q      Quiet mode, which returns only the values per day.
EOF
}


csv_url="http://ichart.yahoo.com/table.csv?s=" # Details: https://code.google.com/p/yahoo-finance-managed/wiki/csvHistQuotesDownload
symbol=
days_to_read=1
quietmode=0


while getopts “hs:d:q” OPTION
do
	case $OPTION in
		h) 
			helpfile
			exit
			;;
		s)
			symbol=$OPTARG
			;;
		d)	
			days_to_read=$OPTARG
			;;
		q)
			quietmode=1
			;;
		?)
			helpfile
			exit 1
			;;
	esac
done

# Adds 1 to days_to_read, to allow for headers in CSV
let days_to_read=$days_to_read+1

# Prompts for stock symbol if symbol is left blank
if [ "$symbol" = "" ]
	then
		read -p "Stock Symbol: " symbol
fi

tempfile=$TEMPDIR$symbol

# Validates $days_to_read 

positive_integer_regex='^[-]?[0-9]*(\.[0-9]*)?$'


if [[ $days_to_read = *[0-9]* && $days_to_read =~ $positive_integer_regex ]]; then

	# Generates HTTP response by CURLing the stock ticker symbol to verify if the symbol is valid. 

	http_response=$(curl --write-out %{http_code} --silent --output /dev/null $csv_url$symbol)
else

    echo "'$days_to_read' isn't a valid number of days to read."
    exit 1
fi


# If HTTP response is 200 or 300 (valid), the script will continue

case $http_response in
[2,3]*)	

	# CURLs the URL ($csv_url), appending the Stock Symbol ($symbol), and writes to the temp file
	curl -s $csv_url$symbol > $tempfile
		
	if [ $quietmode -eq 1 ]
	then
		# Runs in "quiet" mode.
		head -$days_to_read $tempfile | sed '1d' | cut -d, -f5 
	else	
		head -$days_to_read $tempfile | cut -d, -f1,5  | column -s, -t
	fi
	
	exit 0
;;
[4,5]*)	
	echo "HTTP Response "$http_response
	echo "Yahoo doesn't recognize this stock symbol."
	exit 1
;;
esac

