#!/bin/bash

# This script prints the 16 standard ANSI colors (0-15) as colored squares.

for i in {0..7}; do
  printf "\e[48;5;${i}m   \e[0m "
done
echo

for i in {8..15}; do
  printf "\e[48;5;${i}m   \e[0m "
done
