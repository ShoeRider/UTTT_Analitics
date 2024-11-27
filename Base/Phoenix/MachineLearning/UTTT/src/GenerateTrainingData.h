//
// Created by pc on 11/24/24.
//

#ifndef GENERATETRAININGDATA_H
#define GENERATETRAININGDATA_H


// Function to read CSV file and return a vector of vectors of integers
std::vector<std::vector<int>> readCSV(const std::string& filePath) {
    std::vector<std::vector<int>> result;
    std::ifstream file(filePath);

    if (!file.is_open()) {
        throw std::runtime_error("Could not open file: " + filePath);
    }

    std::string line;
    while (std::getline(file, line)) {
        std::vector<int> row;
        std::stringstream ss(line);
        std::string cell;

        // Parse each cell in the line
        while (std::getline(ss, cell, ',')) {
            if (!cell.empty()) {
                row.push_back(std::stoi(cell));
            }
        }

        // Add the row to the result
        if (!row.empty()) {
            result.push_back(row);
        }
    }

    file.close();
    return result;
}

class GenerateTrainingData {

};


// Example usage
int main() {
    try {
        std::string filePath = "example.csv";
        std::vector<std::vector<int>> data = readCSV(filePath);

        // Print the data
        for (const auto& row : data) {
            for (const auto& num : row) {
                std::cout << num << " ";
            }
            std::cout << "\n";
        }
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }

    return 0;
}

#endif //GENERATETRAININGDATA_H
