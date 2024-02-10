#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <size> <filename>"
    exit 1
fi

size=$1
filename=$2

# Generate random string
random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c "$size")

# Write the string to the file
echo "$random_string" > "$filename"
echo "Random string of size $size written to $filename"