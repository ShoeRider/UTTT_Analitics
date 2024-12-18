import csv
import numpy as np
import copy
import os
import logging



def get_output_matrix(model, input_data):
    """
    Returns the output matrix (predictions) for a given input example.

    Args:
        model (tf.keras.Model): Trained TensorFlow/Keras model.
        input_data (np.ndarray): Input example or batch (must match model's input shape).

    Returns:
        np.ndarray: Output matrix from the model.
    """
    # Ensure input data is in the correct shape for the model
    input_data = np.expand_dims(input_data, axis=0) if len(input_data.shape) < len(model.input_shape) else input_data

    # Get predictions
    output_matrix = model.predict(input_data, verbose=0)

    return output_matrix

def setup_logger(log_file='app.log', log_level=logging.INFO):
    logging.basicConfig(
        filename=log_file,
        level=log_level,
        format='%(asctime)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )



def read_csv(file_path):
    result = []
    try:
        with open(file_path, mode='r', newline='', encoding='utf-8') as file:
            reader = csv.reader(file)
            for row in reader:
                if row:
                    if row[-1] == '':
                        row = row[:-1]
                    result.append(row)
    except FileNotFoundError:
        raise RuntimeError(f"Could not open file: {file_path}")
    return result

class UTTT:
    def __init__(self):
        self.Boards = [[[[0 for _ in range(3)] for _ in range(3)] for _ in range(3)] for _ in range(3)]
        self.WinningPlayer = None
        self.MovesRemaining = 0
        self.isGameFinished = False

    def RotateMove_Helper(self, SubSTR):
        rotation_map = {
            "00": "02", "02": "22", "22": "20", "20": "00",
            "01": "12", "12": "21", "21": "10", "10": "01",
            "11": "11"
        }
        return rotation_map.get(SubSTR, SubSTR)

    def RotateMove(self, MoveSTR):
        return self.RotateMove_Helper(MoveSTR[:2]) + self.RotateMove_Helper(MoveSTR[-2:])

    def Rotate_GameHistory(self, MoveList):
        R90NewList = []
        for Move in MoveList:
            R90 = self.RotateMove(Move)
            R90NewList.append(R90)
        return R90NewList

def Process_Move(XGameStates, OGameStates, Move, ActivePlayer, FirstMove=False):
    PastGameNONAttention = [[[[0 for _ in range(3)] for _ in range(3)] for _ in range(3)] for _ in range(3)]
    PastGameAttention = [[[[0 for _ in range(3)] for _ in range(3)] for _ in range(3)] for _ in range(3)]
    #MoveMade = [[[[0 for _ in range(3)] for _ in range(3)] for _ in range(3)] for _ in range(3)]
    #print("__________")
    #print(np.array(XGameStates[0].Boards).flatten('C'))
    #print(np.array(OGameStates[0].Boards).flatten('C'))
    MoveMade = np.array([[[[0 for _ in range(3)] for _ in range(3)] for _ in range(3)] for _ in range(3)])

    _3x3_0Matrix = np.zeros((3, 3))
    _3x3_1Matrix = [[1 for _ in range(3)] for _ in range(3)]


    if(FirstMove):
        PastGameAttention = [[[[1 for _ in range(3)] for _ in range(3)] for _ in range(3)] for _ in range(3)]

    if(not FirstMove):
        PastGameAttention[int(Move[0])][int(Move[1])] = _3x3_1Matrix

    MoveMade[int(Move[0])][int(Move[1])][int(Move[2])][int(Move[3])] = 1

    #print(MoveMade.flatten('C'))
    return {
        "PastGameNONAttention": PastGameNONAttention,
        "PastGameAttention": PastGameAttention,
        "XGameStates": copy.deepcopy(XGameStates),
        "OGameStates": copy.deepcopy(OGameStates),
        "MoveMade": copy.deepcopy(MoveMade),
        "ActivePlayer":ActivePlayer,
        "FirstMove":FirstMove
    }

def Process_UTTT_Game(Moves, GameMemoryCount):
    FirstMove = True
    TrainingData = []
    ActivePlayer = 'X'

    XGameStates = [UTTT() for _ in range(GameMemoryCount)]
    OGameStates = [UTTT() for _ in range(GameMemoryCount)]

    for Move in Moves:
        TrainingInstance = Process_Move(XGameStates, OGameStates, Move, ActivePlayer, FirstMove)
        TrainingInstance["Move"] = Move
        TrainingData.append(TrainingInstance)

        for i in range(GameMemoryCount - 2, -1, -1):
            XGameStates[i + 1] = copy.deepcopy(XGameStates[i])
            OGameStates[i + 1] = copy.deepcopy(OGameStates[i])

        if ActivePlayer == 'X':
            XGameStates[0].Boards[int(Move[0])][int(Move[1])][int(Move[2])][int(Move[3])] = 1
        if ActivePlayer == 'O':
            OGameStates[0].Boards[int(Move[0])][int(Move[1])][int(Move[2])][int(Move[3])] = 1

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
        #array = np.array(past_game_attention)

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
        #combined_input = CreatePositive_Example(item,GameHistory)

        # Chosen Move:
        x_train.append(combined_input)
        y_train.append(np.array(item["MoveMade"]))

        """if(IncludePossibleMoves):
            # Possible Moves:
            x_train.append(combined_input)
            y_train.append(np.array(item["PastGameAttention"]))"""
    # Convert lists to numpy arrays
    x_train = np.array(x_train)  # Shape: (num_samples, 7, 3, 3, 3, 3)
    y_train = np.array(y_train)  # Shape: (num_samples, 3, 3, 3, 3)

    return x_train, y_train

def Compile_Data_main(args, Game_MoveMemory=3, RotateGames=True):
    print(f"args type: {type(args)}")
    print(f"args type: {args.i}")
    input_path = args.i
    data = read_csv(input_path)

    UTTT_UTIL = UTTT()
    ProcessedData = []
    for row in data:
        for instance in Process_UTTT_Game(row, Game_MoveMemory):
            ProcessedData.append(instance)

        if RotateGames:
            R90 = UTTT_UTIL.Rotate_GameHistory(row)
            R180 = UTTT_UTIL.Rotate_GameHistory(R90)
            R270 = UTTT_UTIL.Rotate_GameHistory(R180)

            for instance in Process_UTTT_Game(R90, Game_MoveMemory):
                ProcessedData.append(instance)
            for instance in Process_UTTT_Game(R180, Game_MoveMemory):
                ProcessedData.append(instance)
            for instance in Process_UTTT_Game(R270, Game_MoveMemory):
                ProcessedData.append(instance)

    return np.array(ProcessedData)


import numpy as np
import multiprocessing as mp
from functools import partial

def process_data_chunk(data_chunk, Game_MoveMemory, RotateGames):
    """
    Processes a chunk of data, including rotations, and returns processed instances.

    Args:
        data_chunk (list): Subset of input data rows.
        Game_MoveMemory (int): Number of past moves to remember.
        RotateGames (bool): Whether to include rotations of the game history.

    Returns:
        list: Processed game data.
    """
    UTTT_UTIL = UTTT()
    processed_instances = []

    for row in data_chunk:
        for instance in Process_UTTT_Game(row, Game_MoveMemory):
            processed_instances.append(instance)

        if RotateGames:
            # Generate rotated versions of the game
            R90 = UTTT_UTIL.Rotate_GameHistory(row)
            R180 = UTTT_UTIL.Rotate_GameHistory(R90)
            R270 = UTTT_UTIL.Rotate_GameHistory(R180)

            for instance in Process_UTTT_Game(R90, Game_MoveMemory):
                processed_instances.append(instance)
            for instance in Process_UTTT_Game(R180, Game_MoveMemory):
                processed_instances.append(instance)
            for instance in Process_UTTT_Game(R270, Game_MoveMemory):
                processed_instances.append(instance)

    return processed_instances


def Compile_Data_parallel(args, Game_MoveMemory=3, RotateGames=True, num_workers=22):
    """
    Processes the input CSV data in parallel and generates the final training set.

    Args:
        args (Namespace): Command-line arguments with input file path.
        Game_MoveMemory (int): Number of past moves to remember.
        RotateGames (bool): Whether to include rotations of the game history.
        num_workers (int): Number of parallel workers (processes).

    Returns:
        np.ndarray: Combined processed data.
    """
    print(f"args type: {type(args)}")
    print(f"args: {args.i}")
    input_path = args.i
    data = read_csv(input_path)  # Read input data from CSV

    # Split data into chunks for parallel processing
    chunk_size = len(data) // num_workers
    data_chunks = [data[i:i + chunk_size] for i in range(0, len(data), chunk_size)]

    # Create a pool of workers and process each chunk in parallel
    with mp.Pool(num_workers) as pool:
        process_func = partial(process_data_chunk, Game_MoveMemory=Game_MoveMemory, RotateGames=RotateGames)
        results = pool.map(process_func, data_chunks)

    # Flatten the list of results and combine them
    processed_data = [item for sublist in results for item in sublist]

    print(f"Total processed instances: {len(processed_data)}")

    return np.array(processed_data)



import os
import numpy as np

def save_processed_data(data, file_path):
    """
    Saves the processed data to a .npy file.

    Args:
        data (np.ndarray): Processed data to save.
        file_path (str): File path to save the data.
    """
    np.save(file_path, data)
    print(f"Data saved to {file_path}")

def read_processed_data(file_path):
    """
    Reads the processed data from a .npy file.

    Args:
        file_path (str): File path to load the data from.

    Returns:
        np.ndarray: Loaded processed data.
    """
    data = np.load(file_path, allow_pickle=True)
    print(f"Data loaded from {file_path}")
    return data

def setget_TrainingData(args, Game_MoveMemory=3, RotateGames=True, num_workers=22):
    """
    Checks for saved training data, loads it if available, or processes and saves it.

    Args:
        args (Namespace): Command-line arguments with input and output file paths.
        Game_MoveMemory (int): Number of past moves to remember.
        RotateGames (bool): Whether to include rotations of the game history.
        num_workers (int): Number of parallel workers for processing.

    Returns:
        np.ndarray: Processed training data.
    """
    if hasattr(args, 'td') and args.td:  # 'td' represents training data file path
        if os.path.exists(args.td):
            print("Found existing training data. Loading...")
            return read_processed_data(args.td)

    print("No existing training data found. Generating new training data...")
    # Generate training data
    training_data = Compile_Data_parallel(args, Game_MoveMemory=Game_MoveMemory, RotateGames=RotateGames, num_workers=num_workers)

    # Save the training data
    if hasattr(args, 'td') and args.td:
        print("Saving Training Data.")
        save_processed_data(training_data, args.td)
    else:
        print("Warning: No file path specified to save training data.")

    return training_data


import hashlib
import copy
import numpy as np
import hashlib

def hash_matrix(matrix):
    """
    Generates a hash for a 4D matrix using SHA256.

    Args:
        matrix (list): A 4D nested list.

    Returns:
        str: The hash value of the matrix.
    """
    # Convert the nested list into a NumPy array
    matrix_array = np.array(matrix, dtype=np.int8)

    # Serialize the NumPy array into bytes
    matrix_bytes = matrix_array.tobytes()

    # Compute the SHA256 hash of the serialized bytes
    hash_value = hashlib.sha256(matrix_bytes).hexdigest()

    return hash_value

def hash_game_states(XGameStates, OGameStates, MoveMade):
    """
    Generates a hash key for the provided game states and move matrix.

    Args:
        XGameStates: Game states for player X.
        OGameStates: Game states for player O.
        MoveMade: Move matrix.

    Returns:
        str: A hash key representing the unique combination of inputs.
    """
    combined = hash_matrix(MoveMade)
    for X in range(3):
        combined += hash_matrix(XGameStates[X].Boards) + hash_matrix(OGameStates[X].Boards)
    return hashlib.md5(combined.encode()).hexdigest()

def hashmap_to_list(game_state_map):
    """
    Converts a hashmap of game states back into a list of game data dictionaries.

    Args:
        game_state_map (dict): Hashmap containing the unique game data.

    Returns:
        list: List of game data dictionaries.
    """
    return list(game_state_map.values())


def filter_and_insert_data(data_list):
    """
    Filters out items where "XGameStates", "OGameStates", and "MoveMade" are unique
    and inserts the remaining items into a hashmap.

    Args:
        data_list (list): List of dictionaries containing the specified game data.

    Returns:
        dict: A hashmap containing the filtered game data.
    """
    game_state_map = {}  # Hashmap to store filtered data
    removed_count = 0

    for item in data_list:
        # Generate a hash key for the current data instance
        hash_key = hash_game_states(item["XGameStates"], item["OGameStates"], item["MoveMade"])

        # If the hash key is already in the hashmap, skip the duplicate
        if hash_key in game_state_map:
            removed_count += 1
        else:
            # Insert the instance into the hashmap
            game_state_map[hash_key] = copy.deepcopy(item)

    print(f"Total Instances Processed: {len(data_list)}")
    print(f"Total Instances Removed: {removed_count}")
    print(f"Total Unique Instances: {len(game_state_map)}")

    return hashmap_to_list(game_state_map)

