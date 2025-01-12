import sys



# example_script.py
def process_string(input_str):
    print(f"Called Process_String{input_str}")
    print(sys.path)
    return [ord(char) for char in input_str]

