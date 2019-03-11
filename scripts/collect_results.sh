#!/bin/sh

FILES=./*
RESULT_FOLDER="results"
FINAL_RESULT_NAME="final.out"
SORTED_RESULT_NAME="sorted_result.out"
for file in $FILES
do
    # if folder is old_results
    if [[ "$file" == "./old_results" ]]; then
        continue
    fi

    if [ -d ${file} ]; then
        cd $file/$RESULT_FOLDER
        rm $FINAL_RESULT_NAME &>/dev/null
        cat epoch* >> $FINAL_RESULT_NAME
        cat $FINAL_RESULT_NAME | grep BLEU | grep -n '^' | sed 's/\(.*\):.*BLEU-4\ -\ \(.*\)/\1: BLEU-4 - \2/g' | sort -n -t ':' -k2r > $SORTED_RESULT_NAME 
        echo -e "\n *************** \n"
        echo -e " Experiment: $file\n"
        EPOCH=$( cat "$SORTED_RESULT_NAME" | head -n 1 | sed 's/\(.*\):.*/\1/g' )
        BLEU=$( cat "$SORTED_RESULT_NAME" | head -n 1 | sed 's/.*-\ \(.*\)/\1/g' )

        let BESTEPOCH=$EPOCH-1
        echo " Best BLEU-4:"
        echo " Epoch: $BESTEPOCH, BLEU-4: $BLEU"  
        echo -e "\n *************** \n"
        cd ../..
    fi
done

        

        
        

