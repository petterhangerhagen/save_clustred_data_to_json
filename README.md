# Save clustered data to json

This repository contains a shell script and a Python script that reads out the clustered data from the rosbags and save it to json files.

## Shell Script

The shell script in this repository, `read_out_radar_detector_scan_from_raw_data_to_new_rosbag.sh`, need to be execute simultaneous with running ROS and this node: `ros_af_program_start start_program.launch`. This will the cluster the raw radar data and only save the clustered data in a rosbag. 

## Python Script

The Python script in this repository, `save_clustred_data_to_json.py`, reads out the clustered data from the rosbag and save it to a json file
