import joblib
import numpy as np
from ultralytics import YOLO

def main():

    model = joblib.load("ufc_model.pkl")

    yolo_model = YOLO("yolo11n-pose.pt")

    filePath = input("Enter file path: ")
    result = yolo_model.predict(filePath, save=False, conf=0.9)

    # Predict for person with largest confidence store
    boxTensor = result[0].boxes.data
    # max_confidence_idx = np.argmax(boxTensor[:, 4])
    
    output = []

    for data in result[0].keypoints.data:
        output.append(model.predict([data.cpu().numpy().flatten()]))
    
    if len(output) == 0:
        print("The image you provided was invalid try another one")
        
    else:
        for i in output:
            if i == 0:
                print("Punch")
            elif i == 1:
                print("Kick")
            else:
                print("Something weird " + str(i))

main()