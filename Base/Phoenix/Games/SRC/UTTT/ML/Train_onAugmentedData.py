#python .\src\Train_OnAugmentedData.py -i .\data\Test.tfrecord
import tensorflow as tf
import argparse
import Prep_UTTT
import Train_Model
import Run_Train
import Build_Model
import csv
X_DataLen = 1053
Y_DataLen = 81

# Function to parse a single example
def parse_example(example_proto):

    feature_description = {
        'feature1': tf.io.FixedLenFeature([X_DataLen], tf.float32),
        'feature2': tf.io.FixedLenFeature([Y_DataLen], tf.float32),
    }

    parsed_features = tf.io.parse_single_example(example_proto, feature_description)
    feature1 = parsed_features['feature1']  # No reshape needed
    feature2 = parsed_features['feature2']  # No reshape needed
    return feature1, feature2



import argparse
import tensorflow as tf
import os
def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Train UTTT Model")
    parser.add_argument("-i", required=False, help="Input TFRecord file.")
    parser.add_argument("--CUDA", type=str, required=False, help="Comma-separated list of GPU indices to use.")
    args = parser.parse_args()

    batch_size = 1500
    Game_MoveMemory = 5
    num_models = 5  # Number of models to train
    best_accuracy = 0.0
    best_model = None

    # Create a dataset from the TFRecord file
    dataset = tf.data.TFRecordDataset([args.i])
    dataset = dataset.map(parse_example)
    dataset = dataset.batch(batch_size).prefetch(buffer_size=tf.data.experimental.AUTOTUNE)

    # Create the test dataset
    test_dataset = tf.data.TFRecordDataset(["./data/Test2_1.tfrecord"])
    test_dataset = test_dataset.map(parse_example)
    test_dataset = test_dataset.batch(batch_size).prefetch(buffer_size=tf.data.experimental.AUTOTUNE)

    for i in range(num_models):
        print(f"Training model {i + 1}/{num_models}...")
        
        # Initialize the model
        model = Run_Train.SetGet_Model(args, Game_MoveMemory)

        # Train the model
        model.fit(dataset, epochs=50)

        # Evaluate the model on the test dataset
        print(f"Evaluating model {i + 1}/{num_models} on test data...")
        test_loss, test_accuracy = model.evaluate(test_dataset)

        print(f"Model {i + 1} Test Accuracy: {test_accuracy}")

        # Check if this is the best model
        if test_accuracy > best_accuracy:
            best_accuracy = test_accuracy
            best_model = model
            print(f"New best model found with accuracy: {best_accuracy}")

    # Save the best model
    if best_model:
        print(f"Saving the best model with accuracy: {best_accuracy}")
        best_model.save("Best_UTTT_Model.keras")
    else:
        print("No models were trained successfully.")

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

def train_Loop():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Train UTTT Model")
    parser.add_argument("-i", required=True, help="Input TFRecord file.")
    parser.add_argument("-om", required=True, help="output tensorflow model.")
    parser.add_argument("--CUDA", type=str, required=False, help="Comma-separated list of GPU indices to use.")
    args = parser.parse_args()

    Game_MoveMemory = 5
    RotateGames     = True

    #Set CUDA devices
    print(f"args.CUDA:{args.CUDA}")
    if(args.CUDA):
        set_visible_gpus(args.CUDA)

    gpus = tf.config.list_physical_devices('GPU')
    if gpus:
        for gpu in gpus:
            tf.config.experimental.set_memory_growth(gpu, True)

    batch_size = 1500
    Game_MoveMemory = 5
    num_models = 1  # Number of models to train
    best_accuracy = 0.0
    best_model = None

    # Create a dataset from the TFRecord file
    dataset = tf.data.TFRecordDataset([args.i])
    dataset = dataset.map(parse_example)
    dataset = dataset.batch(batch_size).prefetch(buffer_size=tf.data.experimental.AUTOTUNE)

    # Create the test dataset
    test_dataset = tf.data.TFRecordDataset(["./data/Test2_1.tfrecord"])
    test_dataset = test_dataset.map(parse_example)
    test_dataset = test_dataset.batch(batch_size).prefetch(buffer_size=tf.data.experimental.AUTOTUNE)

    
    

    for i in range(num_models):
        print(f"Training model {i + 1}/{num_models}...")
        
        # Example Usage
        dense_block_units = Build_Model.Plot_Y_Lists(2, 1600, 100)
        #dense_block_units = [1600, 1600, 1600, 1600]  # List of units for each dense block
        builder = Build_Model.DenseModelBuilder(dense_block_units, Game_MoveMemory=5)
        model = builder.build()
        model.summary()

        # Train the model
        model.fit(dataset, epochs=100)

        # Evaluate the model on the test dataset
        print(f"Evaluating model {i + 1}/{num_models} on test data...")
        test_loss, test_accuracy = model.evaluate(test_dataset)

        print(f"Model {i + 1} Test Accuracy: {test_accuracy}")

        # Check if this is the best model
        if test_accuracy > best_accuracy:
            best_accuracy = test_accuracy
            best_model = model
            print(f"New best model found with accuracy: {best_accuracy}")
    
            best_model.save(args.om)

if __name__ == "__main__":
    train_Loop()
