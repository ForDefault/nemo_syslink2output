#!/bin/bash
# Create directories if they don't exist
mkdir -p /home/$USER/.local/share/nemo/actions/
mkdir -p /home/$USER/tmp/output2syslink_sources/

# Create the nemo action file for setting the source
echo '[Nemo Action]
Name=3.Source to output FROM
Comment=Set this as the source for Output2Syslink
Exec=/home/$USER/.local/share/nemo/actions/set_output2syslink_source.sh %F
Icon-Name=folder
Selection=Any
Extensions=any;
' > /home/$USER/.local/share/nemo/actions/set_output2syslink_source.nemo_action

# Create the nemo action file for outputting to the destination
echo '[Nemo Action]
Name=Output2Syslink here
Comment=Output the source to this location
Exec=/home/$USER/.local/share/nemo/actions/output2syslink_here.sh %U
Icon-Name=folder
Selection=Any
Extensions=dir;
' > /home/$USER/.local/share/nemo/actions/output2syslink_here.nemo_action

# Create the script for setting the source
echo '#!/bin/bash
# Script to set the source for Output2Syslink

# Directory to store source paths and context index
temp_dir="/home/$USER/tmp/output2syslink_sources"
context_file="$temp_dir/next_context"

# Ensure the directory exists
mkdir -p "$temp_dir"

# Determine the next available index for the source file
next_index=$(ls "$temp_dir" | grep -oP "output2syslink_source_\K\d+" | sort -n | tail -1)
if [ -z "$next_index" ]; then
    next_index=0
fi
next_index=$((next_index + 1))

# Store each selected path in a new temp file
for selected in "$@"; do
    while [ -f "$temp_dir/output2syslink_source_$next_index" ]; do
        next_index=$((next_index + 1))
    done
    echo -n "$selected" > "$temp_dir/output2syslink_source_$next_index"
    next_index=$((next_index + 1))  # Increment next_index for the next iteration
done

# Determine the next context value
next_context=$((next_index + 1))

# Update the next_context in the context file
echo -n "$next_context" > "$context_file"

# Update the Nemo action file with the new counter value
echo "[Nemo Action]
Name=$next_context.Source to output FROM
Comment=Set this as the source for Output2Syslink
Exec=/home/$USER/.local/share/nemo/actions/set_output2syslink_source.sh %F
Icon-Name=folder
Selection=Any
Extensions=any;
" > /home/$USER/.local/share/nemo/actions/set_output2syslink_source.nemo_action

echo "[Nemo Action]
Name=Output2Syslink here
Comment=Output here from source
Exec=/home/$USER/.local/share/nemo/actions/output2syslink_here.sh %U
Icon-Name=folder
Selection=Any
Extensions=dir;
" > /home/$USER/.local/share/nemo/actions/output2syslink_here.nemo_action
' > /home/$USER/.local/share/nemo/actions/set_output2syslink_source.sh

# Create the script for outputting to the destination
echo '#!/bin/bash
# Script to output the sources to the specified destination

# Directory to store source paths and destination path
temp_dir="/home/$USER/tmp/output2syslink_sources"
destination_file="$temp_dir/destination_path"
log_file="/home/$USER/tmp/output2syslink_log.txt"

# Clear the log file
> "$log_file"

# Ensure the directories exist
mkdir -p "$temp_dir"

# Extract and convert the URI to local path
uri="$1"
destination_path=$(echo "$uri" | sed "s|file://||" | sed "s|%20| |g")

# Store the destination path in a temp file without trailing newline
echo -n "$destination_path" > "$destination_file"
echo "Destination path stored in $destination_file: $(cat "$destination_file")" >> "$log_file"

# Read the destination path
destination_path=$(cat "$destination_file")
echo "Using destination path: $destination_path" >> "$log_file"

# Check if the temp_dir directory exists and contains source files (excluding destination_path)
if [ -d "$temp_dir" ] && [ "$(ls -A "$temp_dir" | grep -v "destination_path")" ]; then
    echo "Found source files in $temp_dir" >> "$log_file"
    for source_file in "$temp_dir"/output2syslink_source_*; do
        source_path=$(cat "$source_file")
        echo "Processing source path: $source_path" >> "$log_file"
        
        # Check if the source file/folder exists
        if [ -e "$source_path" ]; then
            # Create symbolic link for each item inside the source directory
            ln -s "${source_path}"/* "${destination_path}/"
            if [ $? -eq 0 ]; then
                echo "Successfully linked ${source_path}/* to ${destination_path}/" >> "$log_file"
            else
                echo "Failed to link $source_path" >> "$log_file"
            fi
        else
            notify-send "Output2Syslink" "Source file/folder does not exist: $source_path"
            echo "Source file/folder does not exist: $source_path" >> "$log_file"
        fi
    done
    
    # Clear the temporary files after processing
    rm -f "$temp_dir"/output2syslink_source_*
    rm -f "$destination_file"
    rm -f "/home/$USER/.local/share/nemo/actions/output2syslink_here.nemo_action"
else
    notify-send "Output2Syslink" "No sources set for output!"
    echo "No sources set for output!" >> "$log_file"
fi
echo "[Nemo Action]
Name=1.Source to output FROM
Comment=Set this as the source for Output2Syslink
Exec=/home/$USER/.local/share/nemo/actions/set_output2syslink_source.sh %F
Icon-Name=folder
Selection=Any
Extensions=any;
" > /home/$USER/.local/share/nemo/actions/set_output2syslink_source.nemo_action
' > /home/$USER/.local/share/nemo/actions/output2syslink_here.sh

# Make the scripts executable
chmod +x /home/$USER/.local/share/nemo/actions/set_output2syslink_source.sh
chmod +x /home/$USER/.local/share/nemo/actions/output2syslink_here.sh

