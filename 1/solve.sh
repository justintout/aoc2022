#!/bin/bash
curl -s -H "Connection: close" --cookie "session=$AOC_SESSION" 'https://adventofcode.com/2022/day/1/input' \
    | tee input.txt \
    | tee >(awk -f max.awk > 1.txt) \
    | awk -f sum-top-3.awk > 2.txt
printf "DAY 1:\n\tLEVEL 1: %d\n\tLEVEL 2: %d" $(<1.txt) $(<2.txt)
