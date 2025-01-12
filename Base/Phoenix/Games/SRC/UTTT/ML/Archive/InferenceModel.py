#python .\src\Train_OnAugmentedData.py -i .\data\Test.tfrecord
import tensorflow as tf
import argparse
import Prep_UTTT
import Train_Model
import Run_Train
import Build_Model
import csv
import os
import sys

def InferenceUTTTModel(input_str):
    print(f"Called Process_String{input_str}")
    print(sys.path)
    return [ord(char) for char in input_str]

X_DataLen = 1053
Y_DataLen = 81
def set_visible_gpus(cuda_devices):
    """
    Sets the visible CUDA devices based on the provided input.

    Args:
        cuda_devices (str): Comma-separated string of GPU indices to make visible.
                            Example: "0,1" to make GPU 0 and GPU 1 visible.
    """
    os.environ["CUDA_VISIBLE_DEVICES"] = cuda_devices
    print(f"CUDA_VISIBLE_DEVICES set to: {cuda_devices}")

    # Enable memory growth for the visible GPUs
    gpus = tf.config.list_physical_devices('GPU')
    if gpus:
        try:
            for gpu in gpus:
                tf.config.experimental.set_memory_growth(gpu, True)
            print(f"Memory growth enabled for GPUs: {cuda_devices}")
        except RuntimeError as e:
            print(f"Error setting memory growth: {e}")
    else:
        print("No GPUs found. Please check your CUDA_VISIBLE_DEVICES setting.")


def Get_Model(args):
    print(f"Attempting to Fetch Model.")
    try:
        if hasattr(args, 'im') and args.im:
            print(f"The 'im' parameter was provided with value: {args.im}")
            model = tf.keras.models.load_model(args.im)
            return model
        else:
            print("The 'im' parameter was NOT provided with value")
    except Exception as e:
        print(f"An error occurred: {e}")
        if hasattr(args, 'im') and args.im:
            print(f"The 'im' parameter was provided with value: {args.im}")
            # Load the model without optimizer state
            print(f"Loading Model: {args.im}")
            model = tf.keras.models.load_model(args.im, compile=False)
        else:
            print("Model Not Provided. Building Model...")
        return model
    return None

def PrepInference(gameMoves):
    return 0

def Inference(Model, processedGame):
    flattened_array = np.array(processedGame).flatten('C')
    ReShape = flattened_array.reshape(-1, 81)
    # Print the first row with a newline after every 81st item
    # Iterate over all rows of the reshaped matrix
    for row in ReShape:
        for i in range(len(row)):
            print(row[i], end=" ")
            if (i + 1) % 81 == 0:
                print()  # Print a newline after every 81 elements (end of row)

    #print(ReShape[0].flatten('C'), sep=" ")
    #print(ReShape, sep=" ")
    print("MoveMade:")
    print(*np.array(Split_game_data["test"]["y"][index]).flatten('C'), sep=" ")

    #print(*np.array(Prep_UTTT.get_output_matrix(model, processedGame)).flatten('C'), sep="`n\n")
    #print(np.round(Prep_UTTT.get_output_matrix(model, processedGame), 3)[0].reshape(-1, 81), sep=" ")
    for row in np.round(Prep_UTTT.get_output_matrix(model, processedGame), 3):
        for i in range(len(row)):
            print(row[i], end=" ")
            if (i + 1) % 9 == 0:
                print()  # Print a newline after every 81 elements (end of row)



def train_Loop():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Inference UTTT Model")
    parser.add_argument("-i", required=True, help="Input Reference Game History.")
    parser.add_argument("-im", required=True, help="Input tensorflow model.")
    parser.add_argument("--CUDA", type=str, required=False, help="Comma-separated list of GPU indices to use.")
    args = parser.parse_args()

    Game_MoveMemory = 5
    RotateGames     = True

    #Set CUDA devices
    print(f"args.CUDA:{args.CUDA}")
    if(args.CUDA):
        set_visible_gpus(args.CUDA)

    Model = Get_Model(args)
    Model.summary()



#if __name__ == "__main__":
#    train_Loop()
