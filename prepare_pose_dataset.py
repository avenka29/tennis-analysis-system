from ultralytics import YOLO
import os

# Configuration
RAW_DIR = "Punches"         # input
# MODEL_PATH = "yolo11n-pose.pt" 
PROJECT = "Annotated"          # Output 
NAME = "LABELS"


os.makedirs(os.path.join(PROJECT, NAME, "labels"), exist_ok=True)


model = YOLO("yolo11n-pose.pt")


model.predict(
    source=RAW_DIR,
    conf=0.25,
    save=True,      # don’t save images with overlays
    save_txt=True,   # auto-generate YOLOv8-format .txt files
    project=PROJECT,
    name=NAME
)

print("Annotations saved to folder -- ", os.path.join(PROJECT, NAME, "labels"))