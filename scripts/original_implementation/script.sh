#!/bin/sh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --gres=gpu:2
#SBATCH --mem=12000
#SBATCH --time=0-08:00:00

export CUDA_HOME=/opt/cuda-9.0.176.1/

export CUDNN_HOME=/opt/cuDNN-7.0/

export STUDENT_ID=$(whoami)

export LD_LIBRARY_PATH=${CUDNN_HOME}/lib64:${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

export LIBRARY_PATH=${CUDNN_HOME}/lib64:$LIBRARY_PATH

export CPATH=${CUDNN_HOME}/include:$CPATH

export PATH=${CUDA_HOME}/bin:${PATH}

export PYTHON_PATH=$PATH

export TMPDIR=/disk/scratch/${STUDENT_ID}/

export TMP=/disk/scratch/${STUDENT_ID}/

mkdir -p /disk/scratch/dra/caption_data/
chmod 0777 /disk/scratch
chmod 0777 /disk/scratch/dra
chmod 0777 /disk/scratch/dra/caption_data
rsync -ua --progress /home/${STUDENT_ID}/caption_data/ /disk/scratch/dra/caption_data/
chmod -R 0777 /disk/scratch/dra/caption_data
export DATASET_DIR=/disk/scratch/dra/caption_data

source /home/${STUDENT_ID}/miniconda3/bin/activate mlp

cd ..
cd ..
python train_eval.py
