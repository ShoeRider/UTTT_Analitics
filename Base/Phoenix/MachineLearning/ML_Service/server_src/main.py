from fastapi import FastAPI, HTTPException
from contextlib import asynccontextmanager
from pydantic import BaseModel
import asyncio
import random

import tensorflow as tf
import argparse
import sys
from pathlib import Path

# Add the directory containing the scripts to the sys.path
scripts_dir = Path(__file__).parent / "../../UTTT/src"
print(scripts_dir)
sys.path.append(str(scripts_dir))

import Prep_UTTT
import Train_Model
import Run_Train
import Build_Model
import InferenceModel
import csv

import tensorflow as tf
from tensorflow.keras import backend as K

# Define the FastAPI app
app = FastAPI()

# Define a data model for the request and response
class RequestModel(BaseModel):
    model: str
    game_state: str

class ResponseModel(BaseModel):
    data: list

# Worker-local data
worker_local_data = {}

@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    This function initializes data specific to each worker during the app's lifespan.
    """

    CudaGPU = "1"
    InferenceModel.set_visible_gpus(CudaGPU)
    # Initialize worker-local variables
    global worker_local_data
    worker_local_data["worker_id"] = id(worker_local_data)
    worker_local_data["CudaGPU"] = CudaGPU
    print(f"Worker {worker_local_data['worker_id']} initialized with CUDA GPU {worker_local_data['CudaGPU']}")

    # Enter the lifespan context
    yield

    # Cleanup (if necessary) when the app shuts down
    print(f"Worker {worker_local_data['worker_id']} shutting down.")

# Define the FastAPI app and attach the lifespan event
app = FastAPI(lifespan=lifespan)

# Asynchronous route
@app.post("/process", response_model=ResponseModel)
async def process_request(data: RequestModel):

    """
    Generate a list of random integers (length: 81) and embed model and game_state strings
    """
    #print(data.model)
    #print(data.game_state)

    if not data.model:
        raise HTTPException(status_code=400, detail="Model and GameState must be non-empty strings")
    # Generate a list of random integers (length: 81)

    Model = InferenceModel.Get_Model_Path("/media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/UTTT/UTTT_Project/UTTT_Analitics/Base/Phoenix/MachineLearning/UTTT/data/"+data.model)
    #Model.summary()
    #InferenceModel.InferenceUTTTModel(data.game_state)

    # Embed the model and game_state strings at the end of the list
    response_list = InferenceModel.InferenceUTTTModel(Model,data.game_state) #+ [data.model, data.game_state]
    #print("Clearing memory.")
    K.clear_session()
    tf.compat.v1.reset_default_graph()
    return ResponseModel(data=response_list)

# Root endpoint for testing
@app.get("/")
async def root():
    return {"message": "Welcome to the asynchronous API server!"}

# Run the server using uvicorn
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)