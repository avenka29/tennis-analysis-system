from yolo_inference import Data_Extractor
#Folder 1 for training
punch_folder = 'input/punch/'
#folder 2 for training
kick_folder = 'input/kick/'

def main():
    extractor = Data_Extractor(punch_folder, kick_folder)
    extractor.process_folder(punch_folder, 0)
    extractor.process_folder(kick_folder, 1)

    for item in extractor.label:
        print(item)

    for item in extractor.keypoints:
        print(item)

main()
