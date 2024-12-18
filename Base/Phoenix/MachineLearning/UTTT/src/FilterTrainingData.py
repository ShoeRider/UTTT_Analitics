import argparse
import Prep_UTTT

import os

def main():

    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Train UTTT Model")
    parser.add_argument("-itd", required=True, help=".")
    parser.add_argument("-otd", required=True, help=".")
    args = parser.parse_args()
    Game_MoveMemory = 3
    RotateGames     = True
    args.td = args.itd
    print(f"Reading non-Filtered Training Data.{args.td}")
    game_data = Prep_UTTT.setget_TrainingData(args, RotateGames=RotateGames, Game_MoveMemory = Game_MoveMemory)
    print(f"Filtering Data..")
    filtered_data = Prep_UTTT.filter_and_insert_data(game_data)
    print(f"Saving Filtered Training Data.{args.otd}")
    Prep_UTTT.save_processed_data(filtered_data, args.otd)

if __name__ == "__main__":
    main()
