#!/bin/bash

# search2sentences.sh - search a corpus for virtuous words and save the result as html files

# Eric Lease Morgan <emorgan@nd.edu>
# June 19, 2015 - first cut; Ah, the power of the shell!


# configure
INPUT='./corpus'
OUTPUT='./sentences'
SEARCH='./bin/search.sh'

# process each file in the corpus
for FILE in $INPUT/*.txt; do

	# debug
	echo "processing $FILE"
	
	# extract/define a key
	KEY=$( basename $FILE .txt )
	
	# do the work
	cat $FILE | "$SEARCH" -h | sed "s/##TITLE##/$KEY/g" > "$OUTPUT/$KEY.html"
			
done

# quit
exit 0

