#!/bin/bash

# analyze.sh - count the number of occurances of a word in a document, and compare it to the document's size

# Eric Lease Morgan <emorgan@nd.edu>
# June 18, 2015 - first cut
# July  9, 2015 - added ability to have synonyms in my dictionary


# configure
CORPUS='./corpus/'
VIRTUES='./etc/lexicon.txt'
PRECISION='%.4f'

# create the dictionary
DICTIONARY=$( cat $VIRTUES )

# output a header
printf "file\tsize\t"
for RECORD in ${DICTIONARY[@]}; do

	for WORD in ${RECORD[@]}; do
	
		printf "$WORD (count)\t"
		printf "$WORD (ratio)\t"
	
	done
	
done
printf "total (count)\ttotal (ratio)\n"

# process each file in the corpus
for FILE in $CORPUS/*.txt; do

	# re-inititialize
	TOTAL=0
	
	# get the key and length; output
	KEY=$( basename $FILE .txt )
	LENGTH=$( cat $FILE | wc -w )
	printf "$KEY\t$LENGTH\t"
	
	# process each word in the DICTIONARY
	for RECORD in ${DICTIONARY[@]}; do

		for WORD in ${RECORD[@]}; do
		
			# re-initialize
			COUNT=0
			RATIO=0
		
			# count the number of occurance of the word in the text
			COUNT=$( egrep -ico $WORD $FILE )
		
			# update the total and calculate the ratio
			if [ $COUNT -ne 0 ]; then
					
				# update the total
				TOTAL=$((TOTAL + COUNT))
				RATIO=$( echo "($COUNT/$LENGTH)*100" | bc -l )
			
			fi

			# report on count and ratio
			printf "$COUNT\t"
			printf $PRECISION $RATIO
			printf "\t"
	
		done
		
	done
	
	# output the total number of "hits"
	printf "$TOTAL\t"
	
	# calculate the total ratio and output
	RATIO=$( echo "($TOTAL/$LENGTH)*100" | bc -l )
	printf $PRECISION $RATIO
	printf "\n";
	
done

# quit
exit 0


