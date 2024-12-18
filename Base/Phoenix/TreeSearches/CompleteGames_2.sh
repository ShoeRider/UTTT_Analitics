#!/bin/bash

# Path to the file to read
file_path="./UTTT_Results/UTTT_4.5M_2.5M_2.5M_PMCTS_BookMoveSet2.csv"


# Check if the file exists
if [[ ! -f $file_path ]]; then
  echo "File not found: $file_path"
  exit 1
fi
# 4.5 M -15
# 2.5 M -15
# 2.5 M -15
# 2.5 M -15
output_Path="./UTTT_Results/UTTT_4.5M_2.5M_2.5M_2.5M_PMCTS_BookMoveSet2.csv"
#output_Path="./UTTT_Results/UTTT_4.5M_1k_PMCTS_BookMoveSet1.csv"
Depth=2500000
UTTT_Commands=()

# Read the file line by line
while IFS= read -r line; do
  # Print each line
  echo "$line"
  COMMAND="./Bin/UTTT_PMCTS_ContinueGenerateSearchGame -sd $Depth -pg $line -m 15 -t 24 -rd 0 -g 1 -p $output_Path > /dev/null 2>&1"
  #echo $COMMAND
  # Loop to execute the command 1000 times
  for ((i=1; i<=1; i++))
  do
      #echo "Running iteration $i..."
      UTTT_Commands+=("$COMMAND")
      #echo "$COMMAND"
      # Optional: Uncomment the next line to add a delay between commands
      # sleep 1
  done

done < "$file_path"





# Maximum number of concurrent commands
max_commands=3

# Function to run commands with limited concurrency
run_limited_concurrency() {
    local active_commands=0

    for cmd in "${UTTT_Commands[@]}"; do
        echo $cmd
        # Start the command in the background
        eval "$cmd" &

        # Increment the active commands counter
        ((active_commands++))

        # If the limit is reached, wait for any one command to finish
        if [[ $active_commands -ge $max_commands ]]; then
            wait -n  # Wait for any one command to finish
            ((active_commands--))  # Decrement the active commands counter
        fi
    done

    # Wait for all remaining commands to complete
    wait
}

# Execute the function
run_limited_concurrency
