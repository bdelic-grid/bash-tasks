#!/bin/bash

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
		    echo "Passed operator: $opt"
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
		    ;;
     esac
done
