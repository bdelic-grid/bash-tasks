#!/bin/bash

# USAGE: ./3-fizz.sh - prints all numbers from 1 to 100, along with Fizz if number is a multiple of 3, Buzz if number is a multiple of 5 and Fizz Buzz if number is multiple of 3 and 5 

for ((i=1; i<=100; i++)); do
	if [[ $(( i % 3 )) -eq 0 && $(( i % 5 )) -eq 0 ]]; then
		echo "$i: Fizz Buzz"
	elif [[ $(( i % 3 )) -eq 0 ]]; then
		echo "$i: Fizz"
	else
		echo "$i: Buzz"
	fi
done


