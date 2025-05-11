import numpy as np
import joblib





def main():
    model = joblib.load("ufc_model.pkl")

    
def extract_keypoints(self, image):
        result = model.predict(image, save=False)

        # Predict for person with largest confidence store
        boxTensor = result[0].boxes.data
        max_confidence_idx = np.argmax(boxTensor[:, 4])

        # if result and len(result[0].keypoints[max_confidence_idx]) == 17:
        s = keypoints.append( result[0].keypoints.data[max_confidence_idx].cpu().numpy().flatten())
        
        return s