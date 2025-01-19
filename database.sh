#!/bin/bash
# 
# USAGE:
# ./database.sh create_db <db_name>				 - creates a directory with a name db_name
# ./database.sh create_table <db_name> <table_name> [<columns>] - creates a txt file ./db_name/table_name.txt with a header consisting of given columns
# ./database.sh insert_data <db_name> <table_name> [<values>]	 - inserts values to table_name.txt; separate values using space
# ./database.sh select_data <db_name> <table_name>		 - prints table_name.txt
# ./database.sh delete_data <db_name> <table_name> <condition>	 - deletes a row from table_name.txt based on the condition, any column can be given in condition; condition format: column=value
#
# ERROR CODES EXPLAINED:
# 1-10 - error with arguments 
# 10-20 - error working with DB
# 20-30 - error with row/field size 

# checks if DB exists
function checkIfDBExists {
		local DBPATH="$1"
		if [[ ! -d "$DBPATH" ]]; then
				echo "DB does not exist, please create one!"
				exit 12
		fi				
}

# checks if table in DB exists
function checkIfTableExists {
		local TABLENAME="$1"
		if [[ -f "$DBPATH/$TABLENAME.txt" ]]; then
				echo "Table with that name in that DB already exists!"
				exit 13		
		fi
}

# checks if table does not exist
function checkIfTableNExists {
		local TABLENAME="$1"
		if [[ ! -f "$DBPATH/$TABLENAME.txt" ]]; then
				echo "Table with that name doesn't exist, create one!"	
				exit 14
		fi
}

# checks if line length exceeds 39 characters
function checkLineLength {
		local LINE="$1"
		# line length excluding stars should not exceed 39 characters
		if [[ $(( ${#LINE} - 4 )) -gt 39 ]]; then
				echo "Line length should not exceed 39 characters! Operation aborted!"
				exit 21
		fi
}

# checks if field length exceeds 8 characters
function checkFieldLength {
		local FIELD="$1"
		if [[ "${#FIELD}" -gt 8 ]]; then
				echo "Field length should not exceed 8 characters! Operation aborted!"
				exit 22
		fi
}

# checks for exact number of arguments of a function
function checkNoArguments {
		local REQ="$1"
		local LENGTH="${#@}"
		if [[ ! "$REQ" -eq "$LENGTH"-1 ]]; then 
				echo "Invalid number of arguments! Try again!"
				exit 2
		fi
}

# checks for minimal number of arguments of a function
function checkMinArguments {
		local REQ="$1"
		local LENGTH="${#@}"
		if [[ ! "$REQ" -le "$LENGTH"-1 ]]; then
				echo "Not enough arguments! Try again!"
				exit 2
		fi
}

function create_db {
		local DBPATH="$1"
		
		if [[ -d "$DBPATH" ]]; then
				echo "DB already exists!"
				exit 11
		fi

		mkdir "./$DBPATH"
		echo "DB created!"
}

function create_table {
		local DBPATH="$2"
		local TABLENAME="$3"

		checkIfDBExists "$DBPATH"
		checkIfTableExists "$TABLENAME"

		local FIELDS=()
		for((i=4; i<=$#; i++)); do
				FIELDS+=("${!i}")
				checkFieldLength "${!i}"
		done

		local HEADER="** "
		for field in "${FIELDS[@]}"; do
				field=$(printf "%-8s" "$field")
				HEADER+="$field|"
		done

		HEADER="${HEADER%|} **"

		checkLineLength "$HEADER"

		echo "$HEADER" > "$DBPATH/$TABLENAME.txt"

		echo "Table created!"
}

function insert_data {
		local DBPATH="$2"
		local TABLENAME="$3"

		checkIfDBExists "$DBPATH"
		checkIfTableNExists "$TABLENAME"
	
		# TODO check if the given row has the correct format

		local FIELDS=()
		for((i=4; i<=$#; i++)); do
				FIELDS+=("${!i}")
				checkFieldLength "${!i}"
		done
		
		local LINE="** "
		for field in "${FIELDS[@]}"; do
				field=$(printf "%-8s" "$field")
				LINE+="$field|"	
		done
		LINE="${LINE%|} **"

		checkLineLength "$LINE"

		echo "$LINE" >> "$DBPATH/$TABLENAME.txt"
		echo "Line added!"
}

function select_data {
		local DBPATH="$2"
		local TABLENAME="$3"
		cat "$DBPATH/$TABLENAME.txt"
}

function delete_data {
		local DBPATH="$2"
		local TABLENAME="$3"
		local CONDITION="$4"

		checkIfDBExists "$DBPATH"
		checkIfTableNExists "$TABLENAME"

		local FIELD
		FIELD=$(echo "$CONDITION" | cut -d'=' -f1)
		local VALUE
		VALUE=$(echo "$CONDITION" | cut -d'=' -f2)

		local COLUMNNUMBER
		COLUMNNUMBER=$(head -n 1 "$DBPATH/$TABLENAME.txt" | tr -s ' ' | tr '|' '\n' | nl -v 0 | grep -w "$FIELD" | cut -f1 | xargs) 
		if [[ -z "$COLUMNNUMBER" ]]; then
				echo "There is no field $FIELD in table $TABLE!"
				exit 15
		fi

		local FILE="$DBPATH/$TABLENAME.txt"
		local TEMP
		TEMP=$(mktemp)

		# copy header
		head -n 1 "$FILE" > "$TEMP"

		tail -n +2 "$FILE" | while IFS='|' read -r line; do
				IFS='|' read -r -a columns <<< "$line"
				for i in "${!columns[@]}"; do
						if [[ $i -eq $COLUMNNUMBER ]]; then
								local col=""
								# remove leading stars
								if [[ ${columns[$i]} == \*\** ]]; then
									col="${columns[$i]#\*\*}"
								#remove trailing stars
								elif [[ ${columns[$i]} == *\*\* ]]; then 	
									col="${columns[$i]%\*\*}"
								else
									col="${columns[$i]}"
								fi
								
								# trim
								col=$(echo "$col" | xargs)
								VALUE=$(echo "$VALUE" | xargs)
	
								if [[ ! $col == $VALUE ]]; then
									echo "$line" >> "$TEMP"
								fi
						fi
				done
		done
		echo "$FILE"	
		mv "$TEMP" "$FILE"
}



# ---------------------MAIN---------------------
case $1 in
		create_db)
				checkNoArguments 2 "$@"
				create_db "$2"
				;;
		create_table)
				checkMinArguments 4 "$@"
				create_table "$@"
				;;
		insert_data)
				checkMinArguments 4 "$@"
				insert_data "$@"
				;;
		select_data)
				checkNoArguments 3 "$@"
				select_data "$@"
				;;
		delete_data)
				checkNoArguments 4 "$@"
				delete_data "$@"
				;;
		*)
				echo "Invalid option"
				exit 1
				;;
esac
