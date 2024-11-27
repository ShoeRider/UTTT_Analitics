#!/bin/bash

# Path to the file to read
file_path="./UTTT_Results/UTTT_4.5M_PMCTS_BookMoveSet1.csv"
output_Path="./UTTT_Results/UTTT_4.5M_1k_PMCTS_BookMoveSet1.csv"
# Check if the file exists
if [[ ! -f $file_path ]]; then
  echo "File not found: $file_path"
  exit 1
fi

# Read the file line by line
while IFS= read -r line; do
  # Print each line
  echo "$line"
  COMMAND="./Bin/UTTT_PMCTS_ContinueGenerateSearchGame -sd 1000000 -pg $line -m 15 -t 24 -rd 0 -g 1 -p $output_Path"
  echo "$line " >> "$output_Path"
  # Loop to execute the command 1000 times
  for ((i=1; i<=10; i++))
  do
      echo "Running iteration $i..."
      $COMMAND
      # Optional: Uncomment the next line to add a delay between commands
      # sleep 1
  done


  echo "All 1000 iterations completed."
done < "$file_path"