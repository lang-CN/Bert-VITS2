#!/bin/bash

# 训练前的数据处理

####################################
# 下面是 训练数据集替换 和执行步骤

# 下载数据模型 git clone https://oauth2:${MY_TOKEN}@www.modelscope.cn/datasets/langll1990/caoxj_speech.git
# /mnt/workspace/Bert-VITS2/data/cxj
base_dir="/mnt/workspace"
project_dir=${base_dir}"/Bert-VITS2"

train_modle_dir="${project_dir}/data"
train_modle_name="cxj" # 这里需要更换训练的模型检测
train_clone_git_modle_name="caoxj_speech" # git 下载的模型名称 用于 mv
train_modle_name_dir="${train_modle_dir}/${train_modle_name}"
if [ ! -d ${train_modle_name_dir} ];then
    echo "训练模型的数据集 ${train_modle_name_dir} \n"
    cd $project_dir \
    && mkdir data 
    cd $train_modle_dir \
    && git clone https://oauth2:${MY_TOKEN}@www.modelscope.cn/datasets/langll1990/${train_clone_git_modle_name}.git \
    && mv $train_clone_git_modle_name $train_modle_name \
    && cd $train_modle_name \
    && find . -type f ! -name "*.wav" -delete \
    && rm -rf .git
else
    echo "存在-训练模型的数据集${train_modle_name_dir} \n"
fi

# 执行步骤1: 切分数据集，并标记数据， 
base_dir="/mnt/workspace"
project_dir=${base_dir}"/Bert-VITS2"
train_modle_name="cxj" # 这里需要更换训练的模型检测
project_raw_dir="${project_dir}/raw"
project_raw_name_dir="${project_raw_dir}/${train_modle_name}"
# 在 项目目录下执行 autolab.py
if [ ! -d ${project_raw_name_dir} ];then
    echo "未标记-训练数据集 ${project_raw_name_dir} \n"
    cd $project_dir \
    && python autolab.py -d $train_modle_name
else
    echo "已标记-训练数据集${project_raw_name_dir} \n"
fi

# 执行步骤2：汇总记录 标记好的数据
filelists_file="filelists/genshin_out.txt"
if [ ! -f "${project_dir}/${filelists_file}" ];then
    echo "不存在-汇总标记数据文件 ${project_dir}/${filelists_file} \n"
    cd $project_dir \
    && python autofilelistsOut.py -f $filelists_file -mjc $train_modle_name
else
    echo "已存在-汇总标记数据文件 ${project_dir}/${filelists_file} \n"
fi

# 执行步骤3：重新采集样本
resample_out="data/audios/wavs"
if [ ! -d "${project_dir}/${resample_out}" ];then
    echo "未进行重新采样 ${resample_out} \n"
    cd $project_dir \
    && python resample.py --in_dir $project_raw_dir --out_dir $resample_out
else
    echo "已进行重新采样 ${resample_out} \n"
fi


# 执行步骤5：preprocess_text.py 分割训练集和验证数据集
genshin_out_file="${project_dir}/data/filelists/genshin_out.txt"
if [ ! -f "${genshin_out_file}" ];then
    echo "不存在 genshin_out ${genshin_out_file} 移动配置文件到 data中\n"
    cd $project_dir \
    && cd data \
    && mkdir filelists 
    cd $project_dir \
    && cp filelists/genshin_out.txt $genshin_out_file 
else
    echo "存在 genshin_out ${genshin_out_file} 移动配置文件到 data中 \n"
fi

train_out_file="${project_dir}/data/filelists/train.list"
if [ ! -f "${train_out_file}" ];then
    echo "不存在 train_out_file ${train_out_file} \n"
    cd $project_dir \
    && python preprocess_text.py
else
    echo "存在 train_out_file ${train_out_file} \n"
fi

# 执行步骤5： 生成pt文件

data_config="${project_dir}/data/config.json"
if [ ! -f "${data_config}" ];then
    echo "不存在 配置文件 ${data_config} 移动配置文件到 data中\n"
    cd $project_dir \
    && cp configs/config.json $data_config 
else
    echo "存在 配置文件 ${data_config} 移动配置文件到 data中 \n"
fi

# train_modle_name="cxj"
# find . -type f  -name "*.bert.pt" -delete 删除重新生成 测试
bert_pt_file="${project_dir}/raw/${train_modle_name}/${train_modle_name}_0.bert.pt"
if [ ! -f "${bert_pt_file}" ];then
    echo "不存在 bert_pt_file ${bert_pt_file} \n"
    cd $project_dir \
    && python bert_gen.py
else
    echo "存在 bert_pt_file ${bert_pt_file} \n"
fi