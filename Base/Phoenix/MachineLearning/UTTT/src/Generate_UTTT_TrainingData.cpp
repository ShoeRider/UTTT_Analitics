//
// Created by pc on 11/24/24.
//

#include <cstring>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

// Function to read CSV file and return a vector of vectors of strings
std::vector<std::vector<std::string>> readCSV(const std::string& filePath) {
    std::vector<std::vector<std::string>> result;
    std::ifstream file(filePath);

    if (!file.is_open()) {
        throw std::runtime_error("Could not open file: " + filePath);
    }

    std::string line;
    while (std::getline(file, line)) {
        std::vector<std::string> row;
        std::stringstream ss(line);
        std::string cell;

        // Parse each cell in the line
        while (std::getline(ss, cell, ',')) {
            row.push_back(cell); // No conversion, store as string
        }

        // Add the row to the result
        if (!row.empty()) {
            result.push_back(row);
        }
    }

    file.close();
    return result;
}





/**
  @brief Main function parameter options

  This program accepts command-line arguments to configure its behavior. The following options can be passed to the program:

Required:
 - **-i**: Input CSV file.
    - Usage: `-i <input CSV file.>`
    - Example: `./UTTT_GenerateRandomGames -i ./data/Source1.csv`

- **-o**:Input CSV file.
    - Usage: `-o <input file.>`
    - Example: `./UTTT_GenerateRandomGames -o ./data/Results.csv`

**/
// Example usage
int main(int argc, char *argv[]) {
    std::string InputPath = "X_RandomSearchResults.csv";
    std::string ResultPath = "X_RandomSearchResults.csv";
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i],"-i")==0) {
            InputPath = argv[i+1];
            i++;
        }
        else if (strcmp(argv[i],"-o")==0) {
            ResultPath = argv[i+1];  // Convert the argument to a float
            i++;  // Skip the next argument since it's the value for -sd
        }
    }

    printf("InputPath: %s",InputPath.c_str());
    printf("ResultPath: %s",ResultPath.c_str());

    std::vector<std::vector<std::string>> data = readCSV(InputPath);
    /*
    * for (const auto& row : data) {
        for (const auto& num : row) {
            std::cout << num << " ";
        }
        std::cout << "\n";
    }
     */

    // Iterate through each row, and create Example Game Data:
    for (const auto& row : data) {
        std::cout << "\n";
        for (const auto& num : row) {
            std::cout << num << " ";
        }
        std::cout << "\n";
    }

    return 0;
}