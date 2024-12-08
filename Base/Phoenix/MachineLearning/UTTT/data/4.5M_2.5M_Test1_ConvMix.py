def build_model(Game_MoveMemory =3,L2Reg=0.01):
    Adjusted_Input_By_GameMemory =(Game_MoveMemory*2+1)
    input_shape=(Adjusted_Input_By_GameMemory, 3, 3, 3, 3)
    output_shape=(3, 3, 3, 3)
    """
    Builds a neural network model for training on the given input and output shapes.

    Args:
        input_shape (tuple): Shape of the input tensor (default: (7, 3, 3, 3, 3)).
        output_shape (tuple): Shape of the output tensor (default: (3, 3, 3, 3)).

    Returns:
        tf.keras.Model: Compiled model.
    """
    reshaped_input_shape = (3, 3, 3, Adjusted_Input_By_GameMemory*3)  # Combine 7 channels into the last axis
    output_units = int(tf.reduce_prod(output_shape))  # Ensure output units is an integer

    model = tf.keras.Sequential([
        # Input layer
        tf.keras.layers.InputLayer(input_shape=input_shape),

        # Reshape input to combine 7 channels
        tf.keras.layers.Reshape(reshaped_input_shape),

        # 3D Convolutional layers
        tf.keras.layers.Conv3D(32, kernel_size=3, activation='relu', padding='same', kernel_regularizer=l2(L2Reg)),
        tf.keras.layers.Conv3D(64, kernel_size=3, activation='relu', padding='same', kernel_regularizer=l2(L2Reg)),
        tf.keras.layers.Conv3D(128, kernel_size=3, activation='relu', padding='same', kernel_regularizer=l2(L2Reg)),



        tf.keras.layers.Dense(256, activation='relu', kernel_regularizer=l2(L2Reg)),
        tf.keras.layers.Dense(256, activation='relu', kernel_regularizer=l2(L2Reg)),
        tf.keras.layers.Dense(256, activation='relu', kernel_regularizer=l2(L2Reg)),
        tf.keras.layers.Dense(256, activation='relu', kernel_regularizer=l2(L2Reg)),
        tf.keras.layers.Dense(256, activation='relu', kernel_regularizer=l2(L2Reg)),

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