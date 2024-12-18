import argparse
import Prep_UTTT
import Train_Model

import os
import tensorflow as tf
from tensorflow.keras.optimizers import Adam

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

def Set_Model(args):
    try:
        print("Model Not Provided. Building Model...")
        model = Train_Model.build_model(Game_MoveMemory =3)
    except:
        model = Train_Model.build_model(Game_MoveMemory =3, compile=False)
        #model = build_model3(Game_MoveMemory =3)

        # Reinitialize and compile the model
        optimizer = Adam(learning_rate=0.001)  # Adjust learning rate as needed
        model.compile(optimizer=optimizer, loss='categorical_crossentropy', metrics=['accuracy'])
    return model

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

def SetGet_Model(args):
    Game_MoveMemory = 3

    if hasattr(args, 'im') and args.im:
        if os.path.exists(args.im):
            Model = Get_Model(args)
            if Model != None:
                print("Returned Saved Model.")
                return Model
    print("Returned New Model.")
    return Set_Model(args)



def Configure_GradientClipping(model):
    # Print model summary
    model.summary()

    optimizer = Adam(learning_rate=1e-4, clipvalue=1.0)  # Clip gradients by value
    model.compile(optimizer=optimizer, loss="categorical_crossentropy", metrics=["accuracy"])
    return model
def main():

    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Train UTTT Model")
    parser.add_argument("-i", required=True, help="Path to the input CSV file.")
    parser.add_argument("-td", required=False, help=".")
    parser.add_argument("-om", required=True, help=".")
    parser.add_argument("-im", type=str, required=False, help=".")
    parser.add_argument("--CUDA", type=str, required=True, help="Comma-separated list of GPU indices to use.")
    args = parser.parse_args()

    # Set CUDA devices
    set_visible_gpus(args.CUDA)

    Game_MoveMemory = 3
    RotateGames     = True

    print(f"args type: {args.im}")

    gpus = tf.config.list_physical_devices('GPU')
    if gpus:
        for gpu in gpus:
            tf.config.experimental.set_memory_growth(gpu, True)


    model = SetGet_Model(args)
    model = Configure_GradientClipping(model)
    #TODO: Game_MoveMemory=4 generates error...
    #game_data = Prep_UTTT.Compile_Data_parallel(args, RotateGames=RotateGames, Game_MoveMemory = Game_MoveMemory)
    game_data = Prep_UTTT.setget_TrainingData(args, RotateGames=RotateGames, Game_MoveMemory = Game_MoveMemory)
    game_data = Prep_UTTT.filter_and_insert_data(game_data)
    trained_model = Train_Model.Test_Train(args,model, game_data,RotateGames=RotateGames, epochs=1, batch_size=50)
    #.i,args.im,args.om

    # Save model
    trained_model.save(args.o)
    print(f"Model saved to {args.o}")

if __name__ == "__main__":
    main()
