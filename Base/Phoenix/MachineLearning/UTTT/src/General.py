import threading

def input_with_timeout(prompt, timeout):
    # Create an event that will trigger when input is received
    result = []

    def get_input():
        result.append(input(prompt))  # Save the input to the result list

    # Set up a thread to handle the input
    input_thread = threading.Thread(target=get_input)
    input_thread.daemon = True  # This allows the program to exit even if the thread is running
    input_thread.start()

    input_thread.join(timeout)  # Wait for the thread to finish or timeout

    if result:
        return result[0]  # Return input if provided
    else:
        return None  # Return None if no input was provided in time