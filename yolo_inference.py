from ultralytics import YOLO
import os
import numpy as np

punch_folder = 'input/punch/'
kick_folder = 'input/kick/'
    

model = YOLO('yolo11n-pose.pt')
# result = model.predict("input/punch.jpeg", save=True)
# class_id = int(result[0].boxes.data[2][5].item())  # [x1, y1, x2, y2, conf, class_id]
# class_id = int(result[0].boxes.data[0][5])



## Class to extract keypoint data from images in folders
class Data_Extractor:
    
    def __init__(self, punch_folder, kick_folder):
        self.keypoints = []
        self.label = []
        self.Folder_P = punch_folder
        self.Folder_K = kick_folder


    def process_folder(self, folder_name, label):
        for image_name in os.listdir(folder_name):
            filePath = folder_name + image_name
            self.extract_keypoints(filePath, label)
    
    # PUNCH = 0
    # KICK = 1
    # @param image = filePath of image
    # @param label = numerical label for punch or kick
    def extract_keypoints(self, image, number):
        result = model.predict(image, save=True)

        # Predict for person with largest confidence store
        boxTensor = result[0].boxes.data
        max_confidence_idx = np.argmax(boxTensor[:, 4])

        # if result and len(result[0].keypoints[max_confidence_idx]) == 17:
        self.keypoints.append( result[0].keypoints.data[max_confidence_idx].cpu().numpy().flatten())
        self.label.append(number)
    

    




