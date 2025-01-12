//
// Created by pc on 1/7/25.
//


#include <iostream>
#include <cpr/cpr.h>
#include <nlohmann/json.hpp> // For JSON handling

int main() {
    // Define the server URL
    const std::string server_url = "http://127.0.0.1:8000/process";

    // Create a JSON object for the request payload
    nlohmann::json payload = {
        {"name", "Anthony"},
        {"delay", 3}
    };

    try {
        // Send a POST request with JSON payload
        cpr::Response response = cpr::Post(
            cpr::Url{server_url},
            cpr::Header{{"Content-Type", "application/json"}},
            cpr::Body{payload.dump()}
        );

        // Check for successful response
        if (response.status_code == 200) {
            // Parse the JSON response
            nlohmann::json json_response = nlohmann::json::parse(response.text);
            std::cout << "Server Response:" << std::endl;
            std::cout << "Message: " << json_response["message"] << std::endl;
            std::cout << "Processed in: " << json_response["processed_in"] << " seconds" << std::endl;
        } else {
            std::cerr << "Error: Received status code " << response.status_code << std::endl;
            std::cerr << "Response body: " << response.text << std::endl;
        }
    } catch (const std::exception& e) {
        std::cerr << "Exception occurred: " << e.what() << std::endl;
    }

    return 0;
}
