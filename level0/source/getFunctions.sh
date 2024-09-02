#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
echo "Executable files in the current directory:"
executables=$(find . -maxdepth 1 -type f -executable -exec file {} \; | grep -v 'shell script' | awk -F: '{print $1}')
if [ -z "$executables" ]; then
    echo -e "${RED}No executable files found in the current directory.${NC}"
    exit 1
fi
index=1
declare -A file_map
for file in $executables; do
    echo -e "[${GREEN}$index${NC}] $file"
    file_map[$index]=$file
    ((index++))
done
read -p "Enter the number of the executable file you want to analyze: " choice
if [[ ! $choice =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Invalid input. Please enter a valid number.${NC}"
    exit 1
fi
if (( choice < 1 || choice >= index )); then
    echo -e "${RED}Invalid choice. Please select a number within the range.${NC}"
    exit 1
fi

chosen_file="${file_map[$choice]}"
if [ ! -f "$chosen_file" ]; then
    echo -e "${RED}File '$chosen_file' does not exist.${NC}"
    exit 1
fi

if [ ! -x "$chosen_file" ]; then
    echo -e "${RED}File '$chosen_file' is not executable.${NC}"
    exit 1
fi

filename="dump.s"
objdump -M Intel -d "$chosen_file" > $filename

csu_init_line=$(grep -n "<__libc[a-zA-Z0-9_]*>:" "$filename" | cut -d: -f1 | head -n1)
frame_dummy_line=$(grep -n "<frame_dummy>:" "$filename" | cut -d: -f1)
next_function_line=$(awk 'NR > '$frame_dummy_line' && /^[0-9a-f]+ <.*>:/{print NR; exit}' "$filename")
awk 'NR >= '$next_function_line' && NR < '$csu_init_line'' "$filename" > function.s
awk '/^ 80/ {print "\t\t" substr($0, 33)} !/^ 80/' function.s > temp && mv temp disas.s
rm $filename function.s