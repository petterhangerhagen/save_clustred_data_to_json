#!/bin/bash

## Author: Petter Hangerhagen ##
## Date: 17.11.2023 ##

# NOTE: Before running this it is important to launch the following:
# roslaunch ros_af_program_start start_program.launch 
# The root directory and the output directory must be changed to the desired location

# Define the root directory where your data is located
root_directory="/media/aflaptop/T7/raw_data"

# Define the base output directory
output_base_directory="/media/aflaptop/T7/processed_data_with_radar_detector_scans"

# Use the find command to locate all .bag files in subdirectories
rosbag_files=$(find "$root_directory" -type f -name "*.bag")

# Process each rosbag file
for file in $rosbag_files; do
    # Get the relative path of the file from the root directory
    relative_path="${file#$root_directory/}"
    
    # Get the directory path without the file name
    directory_path=$(dirname "$relative_path")
    
    # Get the file name without the extension
    filename_without_extension=$(basename -- "$file" .bag)
    
    # Construct the output directory path
    output_directory="$output_base_directory/$directory_path"
    
    # Create the output directory if it does not exist
    mkdir -p "$output_directory"
    
    # Construct the output file path
    output_file="$output_directory/rosbag_data_$filename_without_extension.bag"

    # Play the rosbag
    rosbag play -r 5 "$file" & 
    play_pid=$!

    # Record the desired topic with the dynamically generated output file name
    rosbag record /radar/detector/scans -O "$output_file" &
    record_pid=$!

    # Wait for the play process to finish
    wait $play_pid

    # Terminate the record process
    kill $record_pid
done
