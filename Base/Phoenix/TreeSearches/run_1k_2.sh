#!/bin/bash

# Define the command to be executed
COMMAND="./Bin/UTTT_PMCTS_ContinueGenerateSearchGame -sd 4500000 -m 15 -t 24 -rd 0 -g 1 -p ./UTTT_Results/UTTT_4.5M_PMCTS_BookMoveSet2.csv"
# Loop to execute the command 1000 times
for ((i=1; i<=1000; i++))
do
    echo "Running iteration $i..."
    # Open a new terminal and run the command
    $COMMAND
    # Optional: Uncomment the next line to add a delay between commands
    # sleep 1
done

echo "All 1000 iterations completed."
