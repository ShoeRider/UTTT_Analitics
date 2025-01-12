//
// Created by pc on 1/4/25.
//
#include <boost/python.hpp>
#include <string>
#include <vector>
#include <iostream>

namespace py = boost::python;

std::vector<int> Inference_UTTT_Model(const std::string& Path,const std::string& GameHistory) {
    std::vector<int> result;

    py::object sys = py::import("sys");
    py::object path = sys.attr("path");
    path.attr("append")(Path);
    std::cout << "Python sys.path: " << py::extract<std::string>(py::str(path))() << std::endl;


    try {
        // Acquire the GIL
        PyGILState_STATE gstate = PyGILState_Ensure();

        // Import the Python module and call the function
        py::object module = py::import("InferenceModel");
        py::object process_string = module.attr("Inference_UTTT_Model");
        py::object py_result = process_string(GameHistory);

        // Extract Python list to C++ vector
        if (PyList_Check(py_result.ptr())) {
            for (int i = 0; i < py::len(py_result); ++i) {
                result.push_back(py::extract<int>(py_result[i]));
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


