#!/bin/bash 

while getopts "o:n:d" opt; do
		case $opt in
				o)
						OPERATOR="$OPTARG"
						;;
				n)
						array+=("$OPTARG")
						while [ "$OPTIND" -le "$#" ] && [ "${!OPTIND:0:1}" != "-" ]; do
								array+=("${!OPTIND}")
								OPTIND="$(expr "$OPTIND" \+ 1)"
						done
						res="${array[0]}"

						for ((i=1; i<${#array[@]}; i++)); do
								num="${array[$i]}"
								case $OPERATOR in
										"+") res=$(( res + num ))
												;;
										"-") res=$(( res - num ))
												;;
										"*") res=$(( res * num ))
												;;
										"%") res=$(( res % num ))
												;;
								esac
						done
						echo "Result: $res"
						;;
				d)
						USER=$(whoami)
						echo "User: $USER"
						echo "Script: $0"
						echo "Operation: $OPERATOR"
						echo "Numbers: " "${array[@]}"
						;;
				\?)
						echo "Invalid option: -$OPTARG" >&2
						exit 1
						;;
				:)
						echo "Option -$OPTARG requires an argument" >&2
						exit 1
						;;
		esac
done
