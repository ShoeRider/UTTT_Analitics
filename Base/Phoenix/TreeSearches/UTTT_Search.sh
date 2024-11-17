#!/bin/bash

#bash UTTT_Search.sh
#./UTTT_PMCTS_ContinueGenerateSearchGame -sd 2000000 -m 10 -t 20 -rd 0 -g 1 -p UTTT_2M_PMCTS_BookMoveSet1.csv

# Prompt the user to enter the command
read -p "Enter the command to execute in the loop: " user_command

function alert() {
    tput bel      # Make the terminal bell sound
    sleep 5       # Wait for 5 seconds
    tput bel      # Make the terminal bell sound again
}


# Create a named pipe for inter-process communication
PIPE=$(mktemp -u)
mkfifo "$PIPE"

# Function to handle user input asynchronously
read_input() {
    while true; do
        read -p "Enter input to break the loop: " input
        if [[ -n $input ]]; then
            echo "break" > "$PIPE"
            break
        fi
    done
}

# Start the input reader in the background
read_input &

# Loop to execute the user's command
while true; do
    # Non-blocking read from the pipe
    if read -t 0.1 signal < "$PIPE"; then
        if [[ $signal == "break" ]]; then
            echo "Breaking out of the loop..."
            break
        fi
    fi

    # Execute the user's command
    echo "Executing: $user_command"
    eval "$user_command"
    alert
done

# Clean up
rm -f "$PIPE"
wait
echo "Script finished."
