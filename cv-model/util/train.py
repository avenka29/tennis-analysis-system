from yolo_inference import Data_Extractor
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
import joblib

#Folder 1 for training
punch_folder = 'input/punch/'
#folder 2 for training
kick_folder = 'input/kick/'

def train():
    extractor = Data_Extractor(punch_folder, kick_folder)
    extractor.process_folder(punch_folder, 0)
    extractor.process_folder(kick_folder, 1)

    # for item in extractor.label:
    #     print(item)

    # for item in extractor.keypoints:
    #     print(item)
    
    X = extractor.keypoints;
    y = extractor.label;

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = LogisticRegression(max_iter=1000)
    model.fit(X_train, y_train)

    # 3. Predict
    y_pred = model.predict(X_test)

    # 4. Evaluate
    print("Accuracy:", accuracy_score(y_test, y_pred))
    print("Classification Report:\n", classification_report(y_test, y_pred))
    joblib.dump(model, "ufc_model.pkl")


train()
