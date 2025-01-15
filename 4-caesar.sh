#!/bin/bash

while getopts ":s:i:o:" opt; do
  case $opt in
    s)
	  SHIFT=$OPTARG
      ;;
    i)
      INPUT=$OPTARG
	  ;;
	o)
	  OUTPUT=$OPTARG
	  ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [[ ! -f "$INPUT" ]]; then
	echo "Input file does not exist!"
	exit 2
fi

# shifting left
if [[ "$SHIFT" -lt 0 ]]; then
	SHIFT=$((26 + SHIFT))
fi

if [[ "$SHIFT" -gt 25 ]]; then
	SHIFT=$((SHIFT % 26))
fi

INPUTTEXT=""
while IFS='' read -r line; do
	INPUTTEXT+="$line\\n"
done < "$INPUT"

# no need to shift if $SHIFT is 0 (or any product of 26) 
if [[ "$SHIFT" -eq 0 ]]; then
	echo "$INPUTTEXT" > "$OUTPUT"
	exit 0
fi

result=""
for(( i=0; i < ${#INPUTTEXT}; i++ )); do
	# take one by one character
	char="${INPUTTEXT:$i:1}"
	
	if [[ "$char" =~ [a-zA-Z] ]]; then
		# interpret $char as ASCII
		ascii=$(printf "%d" "'$char")

		if [[ "$char" =~ [A-Z] ]]; then
			# uppercase	
			base=65
		else
			# lowercase	
			base=97
		fi

		newChar=$(( (ascii - base + SHIFT) % 26 + base ))
		# convert $char to octal representation
		# example: $newChar=66 (B in ASCII) -> printf '%03o' "$newChar" -> 102 -> \\$(102) -> \102 -> B (in octal, as interpreted by Bash)
		result+=$(printf "\\$(printf '%03o' "$newChar")")
	else
		# other characters
		result+="$char" 
	fi
done

echo "$result" > "$OUTPUT"


