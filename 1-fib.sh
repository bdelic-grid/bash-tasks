#!/bin/bash

fib_rec() {
	if [ $1 -eq 0 ]; then
		echo 0
	elif [ $1 -eq 1 ]; then
		echo 1
	else
		local tmp1=$(fib_rec $(( $1 - 1 )))
		local tmp2=$(fib_rec $(( $1 - 2 )))
		echo $(( tmp1 + tmp2 ))
	fi
}

fib() {
	a=0
	b=1
	for (( i = 0; i < $1; i++ )) ; do
		tmp=$(( a + b ))
		a=$b
		b=$tmp
	done

	echo $a
}

fib_rec $1


