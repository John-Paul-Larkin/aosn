
# Define variables for log file, backup directory, and current date/time
log_file="./backup.log"
backup_dir=$(date +"%Y%m%d")
date_time=$(date +"%Y-%m-%d %T")

# Function to log messages with date and time to the log file
function log_message() {
    echo "$date_time $1" >> "$log_file"
}

# Log the start of the script and the working directory
log_message "script started"
log_message "working dir $(pwd)"

# Check if the backup directory already exists
if [ -d "$backup_dir" ]; then
    log_message "using previously created folder $backup_dir"
else 
    # if it doesn't exist, create the backup directory 
    mkdir "$backup_dir"
    log_message "created folder $backup_dir"
fi

# Iterate through the files in the input directory
for file_path in ./input/*; do   
   filename=$(basename "$file_path")

    # Check if the file already exists in the backup directory
    if [ -f ./$backup_dir/$filename ]; then
        # Check if the files are identical(-s only return exit status ) 
        if cmp -s "./input/$filename" "./$backup_dir/$filename"; then
            log_message "$filename ignored already in $backup_dir"
        else 
            # If not identical, copy the file(-f to force override)
            cp -f "./input/$filename" "./$backup_dir/$filename"
            log_message "$filename changed… overwritten in $backup_dir"
        fi
    else 
        # if file doesnt exist copy it over
        cp "./input/$filename" "./$backup_dir/$filename"
        log_message "Added file $filename to folder $backup_dir" 
    fi
done

log_message "End of job"

# README
#
# To run this script, cd into the directory containing the backup.sh file
# run "chmod +x ./backup.sh" to add executable permission
# run "clear && ./backup.sh && cat backup.log" 
# To start a fresh log file run "rm -r ./202* && rm ./backup.log"
#
############################################################# 
#
# AUTOMATE ON STARTUP
# run "crontab -e" to open users cron tab
# add the line "@reboot absolute/path/to/script/backup.sh"
#
############################################################# 
#
# Alternatively, on distributions with systemd  
# Create the following file with .service extension
# in the "/etc/systemd/system" directory
# and enable the service "sudo systemctl enable backup.service"
#
# [Unit]
# Description=Backup Script
# After=network.target 
# 
# [Service]
# Type=simple
# ExecStart=absolute/path/to/script/backup.sh
# 
# [Install]
# WantedBy=multi-user.target
