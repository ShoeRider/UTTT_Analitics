import csv
import argparse
import tensorflow as tf
import numpy as np

import tensorflow as tf
from sklearn.model_selection import train_test_split
from sklearn.model_selection import KFold
def read_csv(file_path):
    """
    Reads a CSV file and returns a list of lists containing the data.

    Args:
        file_path (str): Path to the input CSV file.

    Returns:
        list: A list of lists, where each inner list represents a row of the CSV file.
    """
    result = []
    try:
        with open(file_path, mode='r', newline='', encoding='utf-8') as file:
            reader = csv.reader(file)
            for row in reader:
                if row:  # Ignore empty rows
                    if row[-1] == '':  # Check if the last item is empty
                        row = row[:-1]  # Remove the last item
                    result.append(row)
    except FileNotFoundError:
        raise RuntimeError(f"Could not open file: {file_path}")
    return result


def Process_UTTT_Move():

    return {}

class UTTT:
    def __init__(self):
        # Initialize a 3x3x3x3 matrix with spaces
        self.Boards = [[[[0 for _ in range(3)] for _ in range(3)] for _ in range(3)] for _ in range(3)]
        self.WinningPlayer = None
        self.MovesRemaining = 0
        self.isGameFinished = False

    def test_for_winner(self):
        """
        Placeholder function to test for a winner.
        """
        pass

    def generate_game_row_representation(self, row):
        """
        Generate the string representation of a single row in the game.
        """
        game_rep = ""
        for sub_row in range(3):
            for col in range(3):
                for sub_col in range(3):
                    # Access the character at the correct index
                    game_character = str(self.Boards[row][col][sub_row][sub_col])

                    # Ensure game_character is a string
                    if isinstance(game_character, str):
                        game_rep += game_character
                    else:
                        game_rep += ' '  # Default to space if not a string

                    game_rep += "|"
                game_rep += "   "
            game_rep += "\n---------------------------\n"
        return game_rep

    def generate_string_representation(self):
        """
        Generate the string representation of the entire game state.
        """
        self.test_for_winner()
        game_rep = "UTTT Winner: "

        # Add the winning player representation or "C" if no winner
        if self.WinningPlayer:
            game_rep += self.WinningPlayer  # Assuming WinningPlayer is a string
        else:
            game_rep += "C"
        game_rep += "\n"

        # Add moves remaining and active game status
        game_rep += f"MovesRemaining: {self.MovesRemaining}\n"
        game_rep += f"ActiveGame: {int(self.isGameFinished)}\n"

        '''# Add the 3x3 board representation
        for row in range(3):
            for col in range(3):
                if all(isinstance(self.Boards[row][col], list) for _ in range(3)):
                    position = self.Boards[row][col][0]
                    game_rep += f"{position}|"
                else:
                    game_rep += "C|"
            game_rep += "\n--------\n"

        game_rep += "\n\n"
        '''

        # Add the full game representation row by row
        for row in range(3):
            game_rep += self.generate_game_row_representation(row)
            game_rep += "---------------------------\n"

        return game_rep

    def RotateMove_Helper(self,SubSTR):
        #First Loop
        if SubSTR=="00":
            return "02"
        elif SubSTR=="02":
            return "22"
        elif SubSTR=="22":
            return "20"
        elif SubSTR=="20":
            return "00"

        #Second Loop
        if SubSTR=="01":
            return "12"
        elif SubSTR=="12":
            return "21"
        elif SubSTR=="21":
            return "10"
        elif SubSTR=="10":
            return "01"
        #Last Move "11"->"11"
        return "11"
    def RotateMove(self,MoveSTR):

        return ""
    def Rotate_GameHistory(self,MoveList):
        NewList = []
        for Move in MoveList:
            R90 = self.RotateMove(Move)
            R180 = self.RotateMove(R90)
            R270 = self.RotateMove(R180)

            NewList.append(Move)
        return ""

def Process_Move(XGameStates,OGameStates,Move,ActivePlayer,FirstMove=False):
    PastGameAttention = [[[[0 for _ in range(3)] for _ in range(3)] for _ in range(3)] for _ in range(3)]
    MoveMade = [[[[0 for _ in range(3)] for _ in range(3)] for _ in range(3)] for _ in range(3)]

    if(not FirstMove):
        for sub_row in range(3):
            for sub_col in range(3):
                PastGameAttention[int(Move[0])][int(Move[1])][sub_row][sub_col] = 1

    MoveMade[int(Move[0])][int(Move[1])][int(Move[2])][int(Move[3])] = 1
    return {
        "PastGameAttention": PastGameAttention,
        "XGameStates": XGameStates,
        "OGameStates": OGameStates,
        "MoveMade": MoveMade,
        "ActivePlayer":ActivePlayer
    }

def Make_Move(XGameStates,OGameStates,Move,GameMemoryCount,ActivePlayer):

    for i in range(GameMemoryCount - 2, -1, -1):
        print("Moving game:",i," To:",i+1)
        XGameStates[i+1] = XGameStates[i]
        OGameStates[i+1] = OGameStates[i]

    if ActivePlayer == 'X':
        XGameStates[0].Boards[int(Move[0])][int(Move[1])][int(Move[2])][int(Move[3])] = 1
    if ActivePlayer == 'O':
        OGameStates[0].Boards[int(Move[0])][int(Move[1])][int(Move[2])][int(Move[3])] = 1
    #print(TestGameState.generate_string_representation())
    #print(OGameStates[0].generate_string_representation())


def Process_UTTT_Game(Moves,GameMemoryCount):
    FirstMove = True
    TrainingData = []
    Players = {'X','O'}
    ActivePlayer = 'X'
    # 3
    # - History
    XGameStates = [UTTT() for _ in range(GameMemoryCount)]
    OGameStates = [UTTT() for _ in range(GameMemoryCount)]

    for Move in Moves:
        TrainingInstance = Process_Move(XGameStates,OGameStates,Move,ActivePlayer,FirstMove)
        TrainingData.append(TrainingInstance)

        Process_Move(XGameStates,OGameStates,Move,GameMemoryCount,ActivePlayer)

        # Switch ActivePlayer between 'X' and 'O'
        ActivePlayer = 'O' if ActivePlayer == 'X' else 'X'
        FirstMove = False
    return TrainingData


def prepare_training_data(game_data,GameHistory=3):
    """
    Prepares x_train and y_train for model training.

    Args:
        game_data (list): A list of dictionaries with keys:
            - "PastGameAttention": 3x3x3x3 matrix of 0,1
            - "XGameStates": 3x3x3x3x3 matrix of 0,1
            - "OGameStates": 3x3x3x3x3 matrix of 0,1
            - "MoveMade": 3x3x3x3 matrix of 0,1
            - "ActivePlayer": 'X' or 'Y'

    Returns:
        x_train (np.ndarray): Array of shape (num_samples, 7, 3, 3, 3, 3).
        y_train (np.ndarray): Array of shape (num_samples, 3, 3, 3, 3).
    """
    x_train = []
    y_train = []

    for item in game_data:
        # Extract matrices
        #print(item)
        #print(item["PastGameAttention"])
        past_game_attention = np.array(item["PastGameAttention"])  # Shape: (3, 3, 3, 3)
        array = np.array(past_game_attention)

        GameHistory_Array = []
        for x in range(GameHistory):
            # Convert the current GameHistory_Array to a NumPy array (if not empty)
            if 'X' == item["ActivePlayer"]:
                if len(GameHistory_Array) == 0:
                    GameHistory_Array = np.array([np.array(item["XGameStates"][x].Boards), np.array(item["OGameStates"][x].Boards)])
                else:
                    # Ensure consistent dimensionality and stack new matrices along a new axis
                    GameHistory_Array = np.concatenate([
                        GameHistory_Array,
                        np.expand_dims(np.array(item["XGameStates"][x].Boards), axis=0)
                    ])
                    GameHistory_Array = np.concatenate([
                        GameHistory_Array,
                        np.expand_dims(np.array(item["OGameStates"][x].Boards), axis=0)
                    ])

            if 'O' == item["ActivePlayer"]:
                if len(GameHistory_Array) == 0:
                    GameHistory_Array = np.array([np.array(item["OGameStates"][x].Boards), np.array(item["XGameStates"][x].Boards) ])
                else:
                    # Ensure consistent dimensionality and stack new matrices along a new axis
                    GameHistory_Array = np.concatenate([
                        GameHistory_Array,
                        np.expand_dims(np.array(item["OGameStates"][x].Boards), axis=0)
                    ])
                    GameHistory_Array = np.concatenate([
                        GameHistory_Array,
                        np.expand_dims(np.array(item["XGameStates"][x].Boards), axis=0)
                    ])
        # Concatenate PastGameAttention, XGameStates, and OGameStates along axis 0
        combined_input = np.concatenate(
            [past_game_attention[np.newaxis, ...], GameHistory_Array], axis=0
        )  # Shape: (7, 3, 3, 3, 3)

        move_made = np.array(item["MoveMade"])  # Shape: (3, 3, 3, 3)
        x_train.append(combined_input)
        y_train.append(move_made)

    # Convert lists to numpy arrays
    x_train = np.array(x_train)  # Shape: (num_samples, 7, 3, 3, 3, 3)
    y_train = np.array(y_train)  # Shape: (num_samples, 3, 3, 3, 3)

    return x_train, y_train

def Compile_Data_main():
    """
    Main function that handles command-line arguments and reads the input CSV file.
    """
    parser = argparse.ArgumentParser(description="Process input and output CSV files.")
    parser.add_argument("-i", required=True, help="Path to the input CSV file.")
    parser.add_argument("-o", required=True, help="Path to the output CSV file.")

    args = parser.parse_args()

    input_path = args.i
    result_path = args.o

    print(f"InputPath: {input_path}")
    print(f"ResultPath: {result_path}")

    data = read_csv(input_path)

    ProcessedData = []
    # Iterate through each row and print it
    for row in data:
        ProcessedDataInstanceList = Process_UTTT_Game(row,3)
        for instance in ProcessedDataInstanceList:
            ProcessedData.append(instance)
        #print(" ".join(row))
    #print(ProcessedData[0][0])
    array = np.array(ProcessedData)
    print("Dimensions:", array.shape)  # Output: (1, 2, 2, 2)
    return ProcessedData








def build_model(input_shape=(7, 3, 3, 3, 3), output_shape=(3, 3, 3, 3)):
    """
    Builds a neural network model for training on the given input and output shapes.

    Args:
        input_shape (tuple): Shape of the input tensor (default: (7, 3, 3, 3, 3)).
        output_shape (tuple): Shape of the output tensor (default: (3, 3, 3, 3)).

    Returns:
        tf.keras.Model: Compiled model.
    """
    reshaped_input_shape = (3, 3, 3, 21)  # Combine 7 channels into the last axis
    output_units = int(tf.reduce_prod(output_shape))  # Ensure output units is an integer

    model = tf.keras.Sequential([
        # Input layer
        tf.keras.layers.InputLayer(input_shape=input_shape),

        # Reshape input to combine 7 channels
        tf.keras.layers.Reshape(reshaped_input_shape),

        # 3D Convolutional layers
        tf.keras.layers.Conv3D(32, kernel_size=3, activation='relu', padding='same'),
        tf.keras.layers.Conv3D(64, kernel_size=3, activation='relu', padding='same'),
        tf.keras.layers.Conv3D(128, kernel_size=3, activation='relu', padding='same'),

        # Flatten features to a dense layer
        tf.keras.layers.Flatten(),
        tf.keras.layers.Dense(512, activation='relu'),

        # Output dense layer reshaped to the desired output dimensions
        tf.keras.layers.Dense(output_units, activation='softmax'),
        tf.keras.layers.Reshape(output_shape),
    ])

    # Compile the model
    model.compile(
        optimizer='adam',
        loss='categorical_crossentropy',
        metrics=['accuracy']
    )
    print(f"Expected Reshape Output Shape: {output_shape}, Total Units in Dense Layer: {tf.reduce_prod(output_shape)}")
    print(f"Input Shape for Model: {input_shape}")
    return model

def split_data(game_data, test_size=0.2, random_state=42):
    """
    Splits the game data into training and testing datasets.

    Args:
        game_data (list): List of game data dictionaries.
        test_size (float): Proportion of the dataset to include in the test split (default: 0.2).
        random_state (int): Seed for reproducibility (default: 42).

    Returns:
        dict: A dictionary with 'train' and 'test' keys containing their respective data.
    """
    # Prepare the input (x) and output (y) from the game data
    x, y = prepare_training_data(game_data)

    # Split into training and testing sets
    x_train, x_test, y_train, y_test = train_test_split(
        x, y, test_size=test_size, random_state=random_state
    )

    return {
        "train": {"x": x_train, "y": y_train},
        "test": {"x": x_test, "y": y_test},
    }
def train_model(game_data, epochs=5, batch_size=256):
    # Example synthetic game data
    '''game_data = [
        {
            "PastGameAttention": np.random.randint(0, 2, (3, 3, 3, 3)),
            "XGameStates": np.random.randint(0, 2, (3, 3, 3, 3, 3)),
            "OGameStates": np.random.randint(0, 2, (3, 3, 3, 3, 3)),
            "MoveMade": np.random.randint(0, 2, (3, 3, 3, 3)),
            "ActivePlayer": "X",
        },
        # Add more dictionaries as needed
    ]'''

    x_train, y_train = game_data["x"],game_data["y"]

    # Check the shapes
    print(f"x_train shape: {x_train.shape}")  # Expected: (100, 7, 3, 3, 3, 3)
    print(f"y_train shape: {y_train.shape}")  # Expected: (100, 3, 3, 3, 3)

    model = build_model()

    # Print model summary
    model.summary()

    # Train the model
    model.fit(x=x_train, y=y_train, epochs=epochs, batch_size=batch_size, verbose=2)


    return model





import matplotlib.pyplot as plt
import numpy as np

def plot_errors(errors, title="Training and Testing Errors", save_path=None):
    """
    Plots the training and testing errors over epochs.

    Args:
        errors (np.ndarray): A 2,x array where:
            - errors[0]: Training errors over epochs.
            - errors[1]: Testing errors over epochs.
        title (str): Title of the plot (default: "Training and Testing Errors").
        save_path (str): Path to save the plot (optional, default: None).
    """
    epochs = range(1, errors.shape[1] + 1)  # Number of epochs

    plt.figure(figsize=(10, 6))
    plt.plot(epochs, errors[0], label="Training Error", marker='o', linestyle='-')
    plt.plot(epochs, errors[1], label="Testing Error", marker='o', linestyle='--')

    plt.title(title)
    plt.xlabel("Epochs")
    plt.ylabel("Error")
    plt.legend()
    plt.grid(True)

    if save_path:
        plt.savefig(save_path)
        print(f"Plot saved to {save_path}")
    else:
        plt.show()

def train_model_with_kfold(game_data, k=5):
    """
    Trains the model using k-fold cross-validation.

    Args:
        game_data (list): List of game data dictionaries.
        k (int): Number of folds for cross-validation.

    Returns:
        List of trained models, one for each fold.
    """
    # Prepare data
    x_train, y_train = prepare_training_data(game_data)

    # Check the shapes
    print(f"x_train shape: {x_train.shape}")  # Should match (num_samples, 7, 3, 3, 3, 3)
    print(f"y_train shape: {y_train.shape}")  # Should match (num_samples, 3, 3, 3, 3)

    # Initialize k-fold
    kf = KFold(n_splits=k, shuffle=True, random_state=42)
    fold = 1
    models = []

    for train_index, val_index in kf.split(x_train):
        print(f"Training fold {fold}...")

        # Split data into training and validation sets
        x_train_fold, x_val_fold = x_train[train_index], x_train[val_index]
        y_train_fold, y_val_fold = y_train[train_index], y_train[val_index]

        # Build the model
        model = build_model()

        # Print model summary (only for the first fold)
        if fold == 1:
            model.summary()

        # Train the model
        model.fit(
            x=x_train_fold,
            y=y_train_fold,
            validation_data=(x_val_fold, y_val_fold),
            epochs=50,  # Adjust epochs as needed
            batch_size=256,
            verbose=2
        )

        # Save the trained model for this fold
        models.append(model)

        print(f"Finished training fold {fold}.")
        fold += 1

    return models

if __name__ == "__main__":
    game_data = Compile_Data_main()
    Split_game_data = split_data(game_data, test_size=0.2, random_state=42)

    #models = train_model_with_kfold(Split_game_data["train"])
    model = train_model(Split_game_data["train"], epochs=5, batch_size=256)

    print("Evaluate against testing:")
    model.evaluate(Split_game_data["test"]["x"], Split_game_data["test"]["y"], verbose=2)
#import tensorflow as tf
    #print(tf.reduce_sum(tf.random.normal([1000, 1000])))
    model.save('/media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/UTTT/UTTT_Project/UTTT_Analitics/Base/Phoenix/MachineLearning/UTTT/data/4.5_Test0.h5')