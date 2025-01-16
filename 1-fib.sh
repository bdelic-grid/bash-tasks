#!/bin/bash

fib_rec() {
	if [[ "$1" -eq 0 ]]; then
		echo 0
	elif [[ "$1" -eq 1 ]]; then
		echo 1
	else
		local tmp1=$(fib_rec $(( $1 - 1 )))
		local tmp2=$(fib_rec $(( $1 - 2 )))
		echo $(( tmp1 + tmp2 ))
	fi
}

fib() {
	local a=0
	local b=1
	for (( i = 0; i < $1; i++ )) ; do
		local tmp=$(( a + b ))
		a=$b
		b=$tmp
	done

	echo $a
}

echo "Enter the Fibonacci index:"
read -r n

if [[ "$n" -lt 0 ]]; then
	echo "Please enter a positive number"
	exit 1
fi

res=$( fib "$n" )
res_rec=$( fib_rec "$n" )

echo "Fibonacci $n = $res"
echo "Fibonacci recursive $n = $res_rec"

