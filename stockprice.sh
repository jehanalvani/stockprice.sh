#! /bin/bash

SYMBOL=$1
INPUT_COUNT=$2
TEMPFILE=$TMPDIR"$SYMBOL.csv"


curl -s http://real-chart.finance.yahoo.com/table.csv?s=$SYMBOL > $TEMPFILE

let DAYSTOREAD="$INPUT_COUNT + 1"

head -$DAYSTOREAD $TEMPFILE | sed '1d' | tail -r | cut -d, -f5 