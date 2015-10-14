#!/bin/bash

# search.sh - given a stream of text from STDIN, find all the sentences containing a "virtuous" word

# Eric Lease Morgan <emorgan@nd.edu>
# June 18, 2015 - first investigations; working from the shell is interesting!
# July  9, 2015 - added ability to incorporate synonyms


# configure
VIRTUES='./etc/lexicon.txt'

# sanity check; look for STDIN
if [ -t 0 ] | [ -z $1 ]; then

	echo "Usage: cat <file> | $0 <-s|-h>"
	exit 1
	
fi

# create a query with all of the words in a dictionary
DICTIONARY=$( cat $VIRTUES )
QUERY=''
for RECORD in ${DICTIONARY[@]}; do
	for WORD in ${RECORD[@]}; do QUERY="$QUERY|$WORD"; done
done
QUERY=$( echo "$QUERY" | sed -E "s/^\|//g" )

# transform STDIN into a set of sentences; stupid sed!
SENTENCES=$( cat /dev/stdin    |
             tr '\n' ' '       |
             sed -E "s/ +/ /g" |
             tr '.' '\n'       |
             sed -E "s/^ //g"  |
             sed -E "s/$/\./g" )

# branch according to the desired output
if   [ $1 = '-s' ]; then echo "$SENTENCES" | egrep --colour=always -i "$QUERY" | awk '{print $0,"\n"}'
elif [ $1 = '-h' ]; then

	# echo the beginning of html file
	echo "<html><head><title>##TITLE##</title></head><body><h1>##TITLE##</h1><ol>"
	
	# search and then process each hit
	HITS=$( echo "$SENTENCES" | egrep -i "$QUERY" )
	while read -r HIT; do

		# loop through the dictionary
		for RECORD in ${DICTIONARY[@]}; do
		
			for WORD in ${RECORD[@]}; do
		
				# mark-up each hit making them easier to see
				HIT=$( echo "$HIT" | sed "s/$WORD/<strong style='color: red'>$WORD<\/strong>/g" )
			
			done
			
		done
		
		# output the result
		echo "<li style='margin-bottom: 1em'>$HIT</li>"
		
	done <<< "$HITS"
	
	# end the html document
	echo "</ol></body></html>"

else

	# error
	echo "Usage: cat <file> | $0 <-s|-h>"
	exit 1
	
fi

# done
exit 0