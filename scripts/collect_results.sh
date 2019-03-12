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
        
        if [[ "$EPOCH" == "" ]]; then
            echo "No Results.."
        else
            let BESTEPOCH=$EPOCH-1
            ATTENDIM=$( cat $FINAL_RESULT_NAME | grep AttentionDim | head -n 1 )
            DECDIM=$( cat $FINAL_RESULT_NAME | grep DecoderDim | head -n 1 )
            DROPOUT=$( cat $FINAL_RESULT_NAME | grep Dropout | head -n 1 )

            echo " Best BLEU-4:"
            echo " $ATTENDIM, $DECDIM, $DROPOUT, BLEU-4: $BLEU, Epoch: $BESTEPOCH"  
            if cat ./$FINAL_RESULT_NAME | tail -n 1 | grep -q "DUE TO TIME LIMIT";then
                echo " RESULTS NOT FINAL ! "
            fi

            echo -e "\n *************** \n"
        fi
        cd ../..
    fi
done

        

        
        

