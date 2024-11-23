#!/bin/bash

# Define the command to be executed
COMMAND="./UTTT_PMCTS_ContinueGenerateSearchGame -sd 4500000 -m 15 -t 24 -rd 0 -g 1 -p UTTT_4.5M_PMCTS_BookMoveSet2.csv"

# Loop to execute the command 1000 times
for ((i=1; i<=1000; i++))
do
    echo "Running iteration $i..."
    # Open a new terminal and run the command
    gnome-terminal -- bash -c "$COMMAND; read -p 'Press Enter to close this terminal...'"

    # Wait for the user to close the terminal or proceed automatically
    echo "Waiting for the command to complete in the new terminal..."
    wait
done

echo "All 1000 iterations completed."
