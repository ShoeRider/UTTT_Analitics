import tensorflow as tf
import numpy as np
from tensorflow.keras.layers import Input, Reshape, Dense, Flatten, Add
from tensorflow.keras.regularizers import l2
from tensorflow.keras.optimizers import Adam
from tensorflow.keras import backend as K

from sklearn.model_selection import train_test_split
import Prep_UTTT
import General
def build_model(Game_MoveMemory=3, L2Reg=0.01):
    Adjusted_Input_By_GameMemory = (Game_MoveMemory * 2 + 1)
    input_shape = (Adjusted_Input_By_GameMemory, 3, 3, 3, 3)
    output_shape = (3, 3, 3, 3)

    reshaped_input_shape = (3, 3, 3, Adjusted_Input_By_GameMemory * 3)
    output_units = int(np.prod(output_shape))

    inputs = Input(shape=input_shape)
    x = Reshape(reshaped_input_shape)(inputs)



    #x = dense_block(x, 336, l2(L2Reg), activation='sigmoid')
    #x = dense_block(x, 672, l2(L2Reg), activation='sigmoid')

    x = Flatten()(x)
    x = Dense(512, activation='relu', kernel_regularizer=l2(L2Reg))(x)
    outputs = Dense(output_units, activation='softmax', kernel_regularizer=l2(L2Reg))(x)
    outputs = Reshape(output_shape)(outputs)

    model = tf.keras.Model(inputs=inputs, outputs=outputs)
    model.compile(optimizer=Adam(learning_rate=0.001), loss='categorical_crossentropy', metrics=['accuracy'])
    return model

def train_model(game_data, model, epochs=5, batch_size=256):
    x_train, y_train = game_data["x"], game_data["y"]
    print(f"x_train shape: {x_train.shape}")
    print(f"y_train shape: {y_train.shape}")

    model.summary()
    model.fit(x=x_train, y=y_train, epochs=epochs, batch_size=batch_size, verbose=2)
    return model

def split_data(x, y, test_size=0.2, random_state=42):
    test_size=0.2
    random_state=42
    # Split into training and testing sets
    x_train, x_test, y_train, y_test = train_test_split(
        x, y, test_size=test_size, random_state=random_state
    )

    return {
        "train": {"x": x_train, "y": y_train},
        "test": {"x": x_test, "y": y_test},
    }

def Test_Train(args,model,Totaldataset,RotateGames=False, epochs=5, batch_size=10):
    print(f"args type: {type(args)}")
    print(f"The 'im' parameter was provided with value: ",args.im)
    Game_MoveMemory = 3
    Continue = True
    Itteration = 0

    #
    x, y = Prep_UTTT.prepare_training_data(Totaldataset)
    Split_game_data = split_data(x, y, test_size=0.2, random_state=42)
    dataset = Split_game_data["train"]


    while (Continue):
        try:
            # Set steps_per_epoch in model.fit
            model = train_model(dataset, model, epochs=epochs, batch_size=batch_size)
            model.save(args.om)
        except Exception as e:
            print(f"An error occurred: {e}")
            batchsize = 1
            model = tf.keras.models.load_model(args.im)
        print("Clearing memory.")
        K.clear_session()
        tf.compat.v1.reset_default_graph()

        #print("Evaluate against testing:")

        #model.evaluate(Split_game_data["test"]["x"], Split_game_data["test"]["y"], verbose=2)
        #print(Split_game_data["test"]["x"][5])
        try:
            index = 5
            processedGame = Split_game_data["test"]["x"][index]
            print("Itteration: ",Itteration)
            print(*np.array(processedGame[0]).flatten('C'), sep=" ")
            print(*np.array(processedGame[1]).flatten('C'), sep=" ")
            print(*np.array(processedGame[2]).flatten('C'), sep=" ")
            print(*np.array(processedGame[3]).flatten('C'), sep=" ")
            print(*np.array(processedGame[4]).flatten('C'), sep=" ")
            print(*np.array(processedGame[5]).flatten('C'), sep=" ")
            print(*np.array(processedGame[6]).flatten('C'), sep=" ")

            print(processedGame[0])
            print("MoveMade:")
            print(*np.array(Split_game_data["test"]["y"][index]).flatten('C'), sep=" ")
            print(*np.array(Prep_UTTT.get_output_matrix(model, processedGame)).flatten('C'), sep="`n\n")
            print(np.round(Prep_UTTT.get_output_matrix(model, processedGame), 3), sep=" ")

        except Exception as e:
            print(f"An error occurred: {e}")
        timeout_seconds = 5
        prompt = General.input_with_timeout("Continue(Y/Yes): ", timeout_seconds)
        if prompt is None:
            print("Input timed out or invalid response. Continuing without action.")
        elif (prompt.lower() != 'y' and prompt.lower() != 'yes'):
            Continue = False
        else:
            print("Input received, continuing...")
        #epochs+=1
        Itteration+=1
        model.save(args.om)
