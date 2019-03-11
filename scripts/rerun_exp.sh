#!/bin/sh
FILES=./*
RESULT_FOLDER="results"
SCRIPTNAME="run.sh"
OUTPUT_NAME="slurm"

for file in $FILES
do
    # if folder is old_results, skip
    if [[ "$file" == "./old_results" ]]; then
        continue
    fi

    if [ -d ${file} ]; then
        cd $file
        mkdir $RESULT_FOLDER &> /dev/null
        echo -e "\nIn Folder: $file" 
        FILE_NAME=""
        for sfile in ./*
        do
            if [[ "$sfile" == "./$OUTPUT_NAME"* ]]; then
                echo "Parsing : $sfile !"

                STARTEPOCH=$(grep -w Epoch $sfile | head -n 1 | grep -o "\[[0-9]\{1,2\}\]" | sed 's/.*\[\([^]]*\)\].*/\1/g')

                ENDEPOCH=$(grep -w Epoch $sfile | tail -n 1 | grep -o "\[[0-9]\{1,2\}\]" | sed 's/.*\[\([^]]*\)\].*/\1/g')
                
                echo "Start Epoch: ""$STARTEPOCH"
                echo "End Epoch: ""$ENDEPOCH"
                FILE_NAME="epoch_""$STARTEPOCH""_""$ENDEPOCH"".out"

                mv $sfile ./$RESULT_FOLDER/$FILE_NAME
        
            fi
        done
        if cat ./$RESULT_FOLDER/$FILE_NAME | tail -n 1 | grep -q "DUE TO TIME LIMIT"; then
            echo "Job stop due to time limit"

            sed -i 's/.*\(usecheckpoint=\"False\"\)/#\1/g' $SCRIPTNAME
            sed -i 's/.*\(usecheckpoint=\"True\"\)/\1/g' $SCRIPTNAME
            
            echo "Resubmitting Job!"

            sbatch $SCRIPTNAME
        else
            echo "No Jobs Submitted"
        fi
        cd ..
    fi
done






