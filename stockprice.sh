#! /bin/bash

symbol=$1
days_to_read=$2
tempfile=$TMPDIR"$symbol.csv"
csv_url="http://ichart.yahoo.com/table.csv?s=" # Details: https://code.google.com/p/yahoo-finance-managed/wiki/csvHistQuotesDownload

# Validates $days_to_read 

positive_integer_regexp='^[-]?[0-9]*(\.[0-9]*)?$'
if [[ $days_to_read = *[0-9]* && $days_to_read =~ $positive_integer_regexp ]]; then

	# Generates HTTP response by CURLing the stock ticker symbol to verify if the symbol is valid. 

	http_response=$(curl --write-out %{http_code} --silent --output /dev/null $csv_url$symbol)

	# If HTTP response is 200 or 300 (valid), the script will continue

	case $http_response in
	[2,3]*)	

		# CURLs the URL ($csv_url), appending the Stock Symbol ($symbol), and writes to the temp file
		curl -s $csv_url$symbol > $tempfile
		
		let lines_to_read="$days_to_read + 1"
		
		if [ $3='-q' ] 
		then
			# Runs in "quiet" mode.
			head -$lines_to_read $tempfile | sed '1d' | cut -d, -f5 
		else	
			head -$lines_to_read $tempfile | cut -d, -f1,5  | column -s, -t
		fi
		
		exit 0
	;;
	[4,5]*)	
		echo "HTTP Response "$http_response
		exit 1
	;;
	esac

else
    echo "'$days_to_read' isn't a valid number of days to read."
    exit 1
fi

