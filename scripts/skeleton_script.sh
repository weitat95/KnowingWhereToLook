#!/bin/sh
#SBATCH -N 1      # nodes requested
#SBATCH -n 1      # tasks requested
#SBATCH --partition=Standard
#SBATCH --gres=gpu:2
#SBATCH --mem=12000  # memory in Mb
#SBATCH --time=0-08:00:00

attentionDim=49
decoderDim=512
dropout=0.5
useGlove="True"
datasetFolder="caption_data_64"

# DONT CHANGE THIS

#checkpointname="./checkpoint_${datasetFolder}_att_${attentionDim}_dec_${decoderdim}_drop_${dropout}.pth.tar"
checkpointname="${datasetFolder}_att_${attentionDim}_dec_${decoderDim}_drop_${dropout}"
# DONT CHANGE THIS

# CHANGE THIS INSTEAD ****************

usecheckpoint="False"
#usecheckpoint="True"

# ************************************

cpfile="./../../checkpoint_${checkpointname}.pth.tar"

if [[ "$usecheckpoint" != "False" ]];
then
    
    if [ ! -f "$cpfile" ];
    then
        echo "$cpfile : not found! Start from None?"
        exit 1
    else
        echo "Continue from checkpoint"
    fi

else
    if [ -f "$cpfile" ];
    then
        echo "$cpfile : already exist! Continue from checkpoint?"
        exit 1
    else
        echo "Starting from scratch"
    fi
fi

echo "Running Experiments for"
echo "attentionDim = $attentionDim"
echo "decoderDim = $decoderDim"
echo "dropout = $dropout"
echo "UsingGlove = $useGlove"
echo "Starting from Checkpoint = $usecheckpoint"
echo "$checkpointname"



export CUDA_HOME=/opt/cuda-9.0.176.1/

export CUDNN_HOME=/opt/cuDNN-7.0/

export STUDENT_ID=$(whoami)

export LD_LIBRARY_PATH=${CUDNN_HOME}/lib64:${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

export LIBRARY_PATH=${CUDNN_HOME}/lib64:$LIBRARY_PATH

export CPATH=${CUDNN_HOME}/include:$CPATH

export PATH=${CUDA_HOME}/bin:${PATH}

export PYTHON_PATH=$PATH

mkdir -p /disk/scratch/${STUDENT_ID}


export TMPDIR=/disk/scratch/${STUDENT_ID}/
export TMP=/disk/scratch/${STUDENT_ID}/

mkdir -p ${TMP}/datasets/
# Activate the relevant virtual environment:


# Activate the relevant virtual environment:
rm -r /disk/scratch/data_rich_asians
mkdir -p /disk/scratch/dra/"$datasetFolder"/
chmod 0777 /disk/scratch
chmod 0777 /disk/scratch/dra
chmod 0777 /disk/scratch/dra/"$datasetFolder"
ls -la /disk/scratch
ls -la /disk/scratch/dra
ls -la /disk/scratch/dra/"$datasetFolder"
rsync -ua --progress /home/${STUDENT_ID}/"$datasetFolder"/ /disk/scratch/dra/"$datasetFolder"/
chmod -R 0777 /disk/scratch/dra/"$datasetFolder"
export DATASET_DIR=/disk/scratch/dra/"$datasetFolder"/

source /home/${STUDENT_ID}/miniconda3/bin/activate mlp
cd ..
cd ..

python train_eval.py --attentionDim=$attentionDim --decoderDim=$decoderDim --dropout=$dropout --dataset=$datasetFolder --useGlove=$useGlove --checkpointName="$checkpointname" --useCheckpoint="$usecheckpoint"

