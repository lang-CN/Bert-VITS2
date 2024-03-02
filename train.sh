#!/bin/bash

# 执行训练脚本

base_dir="/mnt/workspace"
project_dir=${base_dir}"/Bert-VITS2"

cd $project_dir \
&& python train_ms.py -m genshin_mix -c configs/config.json