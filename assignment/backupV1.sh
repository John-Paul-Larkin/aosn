
date_time=$(date +"%Y-%m-%d %T")

echo "$date_time script started" >> ./backup.log 
echo "$date_time working dir "$(pwd) >> ./backup.log

backup_dir=$(date +"%Y%m%d")

if [ ! -d "$backup_dir" ]; then
    mkdir $backup_dir
    echo "$date_time created folder $backup_dir" >> ./backup.log
else 
    echo "$date_time using previously created folder $backup_dir" >> ./backup.log
fi

for file_path in ./input/*; do   
   filename=$(basename "$file_path")

    if [ -f ./$backup_dir/$filename ]; then
        if cmp -s "./input/$filename" "./$backup_dir/$filename"; then
            echo "$date_time $filename ignored already in $backup_dir" >> ./backup.log
        else 
            cp -f "./input/$filename" "./$backup_dir/$filename"
            echo "$date_time $filename changed… overwritten in $backup_dir" >> ./backup.log
        fi
    else 
        cp "./input/$filename" "./$backup_dir/$filename"
        echo "$date_time Added file $filename to folder $backup_dir" >> ./backup.log
    fi
done

echo "$date_time End of job" >> ./backup.log

