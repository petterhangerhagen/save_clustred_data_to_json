"""
Script Title: save_clustred_data_to_json.py
Author: Petter Hangerhagen
Email: petthang@stud.ntnu.no
Date: June 4th, 2024
Description: This script is used to read the rosbag files and save the data to json files.
"""
import json
import rosbag
import os
import glob

# Define a custom JSON encoder to handle ROS messages
class ROSMsgEncoder(json.JSONEncoder):
    def default(self, obj):
        if hasattr(obj, '__slots__'):
            return {slot: getattr(obj, slot) for slot in obj.__slots__}
        return json.JSONEncoder.default(self, obj)

# Path to the rosbag files
root = ""
# Path to save the json files
json_root = ""

# Topic to be read
topic = "/radar/detector/scans"
# Important to know the structure of the data to get this to work
# It should work if the shell script "read_out_radar_detector_scan_from_raw_data_to_new_rosbag.sh" is used
for file in glob.glob(os.path.join(root,'**' ,'*.bag')):
        bag = rosbag.Bag(file)
        data_list = []
        for topic, msg, t in bag.read_messages(topics=[topic]):
            data_list.append(msg)
        bag.close()
        bag_name = os.path.basename(file)
        json_file_name = bag_name.split(".")[0] + ".json"
        json_path = os.path.join(json_root, json_file_name)
        json_data = json.dumps(data_list, cls=ROSMsgEncoder, indent=1)
        with open(json_path, "w") as save_file:
            save_file.write(json_data)
        print(f"Successfully saved {bag_name} to json")
