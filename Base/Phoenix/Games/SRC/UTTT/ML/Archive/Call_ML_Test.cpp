#include <boost/python.hpp>
#include <string>
#include <vector>
#include <iostream>

namespace py = boost::python;

std::vector<std::vector<double>> callPythonScript(const std::string& Path, const std::string& input) {
    std::vector<std::vector<double>> result;

    py::object sys = py::import("sys");
    py::object path = sys.attr("path");
    path.attr("append")(Path);

    std::cout << "Python sys.path: " << py::extract<std::string>(py::str(path))() << std::endl;

    try {
        // Acquire the GIL
        PyGILState_STATE gstate = PyGILState_Ensure();

        // Import the Python module and call the function
        py::object module = py::import("InferenceModel");
        py::object process_string = module.attr("InferenceUTTTModel");
        py::object py_result = process_string(input);

        // Check if the result is a list
        if (PyList_Check(py_result.ptr())) {
            // Iterate through the outer Python list
            for (int i = 0; i < py::len(py_result); ++i) {
                py::object py_inner_list = py_result[i];
                std::vector<double> inner_vector;

                // Check if the inner element is a list
                if (PyList_Check(py_inner_list.ptr())) {
                    for (int j = 0; j < py::len(py_inner_list); ++j) {
                        inner_vector.push_back(py::extract<double>(py_inner_list[j]));
                    }
                } else {
                    throw std::runtime_error("Expected a nested list structure");
                }

                result.push_back(inner_vector);
            }
        } else {
            throw std::runtime_error("Python function did not return a list");
        }

        // Release the GIL
        PyGILState_Release(gstate);

    } catch (py::error_already_set&) {
        PyErr_Print();
        throw std::runtime_error("Python error occurred");
    }

    return result;
}

int main() {
    try {
        // Initialize Python interpreter
        Py_Initialize();

        {
            // Scoped Python-related operations

            std::string input = "1002,0202,0221,2100,0022,2220,2020,2012,1222,2202,0220";
            std::vector<std::vector<double>> result = callPythonScript(
                "/media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/UTTT/UTTT_Project/UTTT_Analitics/Base/Phoenix/MachineLearning/UTTT/src",
                input);

            std::cout << "Result:" << std::endl;

            // Get dimensions of the list
            size_t num_rows = result.size();
            size_t num_cols = num_rows > 0 ? result[0].size() : 0;

            std::cout << "Dimensions: " << num_rows << " x " << num_cols << std::endl;

            for (const auto& row : result) {
                for (double num : row) {
                    std::cout << num << " ";
                }
                std::cout << std::endl;
            }

        }

        // Finalize Python interpreter after Python objects are destroyed
        Py_Finalize();

    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << std::endl;
        return 1;
    }

    return 0;
}
