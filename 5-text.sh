#!/bin/bash

# USAGE ./5-text.sh -i <input_file> -o <output_file> [vsrlu]?
# v - replaces lowercase with uppercase and vice versa
# -s <word_a> <word_b> - replaces <word_a> with <word_b>
# -r - reverses text lines
# -l - converts all to lowercase
# -u - converts all to uppercase

while getopts ":i:o:s:vrlu" opt; do
    case $opt in
		# input file
		i)
			INPUT=$OPTARG
		    if [[ ! -f "$INPUT" ]]; then
				echo "Input file does not exist!"
				exit 1
			fi

			INPUTTEXT=$(cat "$INPUT")
			;;	
		# output file
		o)
			OUTPUT=$OPTARG
			;;
		# replace lowercase with uppercase and vice versa
    	v)
			INPUTTEXT=$(echo "$INPUTTEXT" | tr '[:upper:][:lower:]' '[:lower:][:upper:]')
			echo "$INPUTTEXT" > "$OUTPUT"
			;;
		# substiture wordA with wordB
	    s)
			array+=("$OPTARG")
			while [ "$OPTIND" -le "$#" ] && [ "${!OPTIND:0:1}" != "-" ]; do
					array+=("${!OPTIND}")
					OPTIND="$(expr "$OPTIND" \+ 1)"
			done
			AFTER=$(echo "$INPUTTEXT" | sed "s/${array[0]}/${array[1]}/g")
			echo "$AFTER" > "$OUTPUT"
			;;
		# reverse text lines
		r)
			awk '{lines[NR] = $0} END {for (i = NR; i > 0; i--) print lines[i]}' "$INPUT" > "$OUTPUT"
		   	;;
		# convert all text to lower case
		l)
			INPUTTEXT=$(echo "$INPUTTEXT" | tr '[:upper:]' '[:lower:]')
			echo "$INPUTTEXT" > "$OUTPUT"
			;;
		# convert all text to upper case
		u)
			INPUTTEXT=$(echo "$INPUTTEXT" | tr '[:lower:]' '[:upper:]')
			echo "$INPUTTEXT" > "$OUTPUT"
			;;
		\?)
		    echo "Invalid argument passed"
		    exit 1
			;;
		esac
done
