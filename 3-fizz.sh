#!/bin/bash

for ((i=1; i<=100; i++)); do
	if [[ $(( i % 3 )) -eq 0 && $(( i % 5 )) -eq 0 ]]; then
		echo "$i: Fizz Buzz"
	elif [[ $(( i % 3 )) -eq 0 ]]; then
		echo "$i: Fizz"
	else
		echo "$i: Buzz"
	fi
done


