#!/bin/bash


# 训练前的环境初始化
echo "token is ${MODELSCOPE_OAUTH2_TOKEN}"

MY_TOKEN=$MODELSCOPE_OAUTH2_TOKEN
base_dir="/mnt/workspace"

# 下载 Bert-VITS2 项目
projectName="Bert-VITS2"
projectName_message="project_message: ${projectName}不存在,下载${projectName} 项目 \n"
projectName_message_exits="project_message: ${projectName} project exits \n"

project_dir=${base_dir}"/Bert-VITS2"
if [ ! -d ${project_dir} ];then
    echo -e $projectName_message
    cd $base_dir \
    && git clone https://gitee.com/langlele/Bert-VITS2.git 
else
    echo -e $projectName_message_exits
fi



# 安装 git-lfs
# /mnt/workspace/Bert-VITS2/git-lfs
lfs_name="git-lfs"
lfs_exits_dir="${base_dir}/${lfs_name}"
lfs_dir="${project_dir}/${lfs_name}"
if [ ! -d ${lfs_exits_dir} ];then
    echo "未安装过-git-lfs ${lfs_exits_dir} \n"
    cd $base_dir \
    && mkdir $lfs_name
    # 判断安装目录是否存在
    if [ ! -d ${lfs_dir} ];then
        echo "安装文件 请自己重新下载，并将 [git-lfs,install.sh]文件放到目录${lfs_dir} \n"
    else
        echo "安装git-lfs \n"
        cd $lfs_dir \
        && sudo ./install.sh
    fi
else
    echo -e "已安装 git-lfs ${lfs_exits_dir} \n"
fi


# 进入项目安装  Bert-VITS2 执行 pip install -r  requirements.txt
pip_message="pip 未安装 requirements.txt 包 \n"
pip_message_exits="pip 已安装 requirements.txt \n"
# 只是用于判断是否重复安装
pip_exits_name="pip-exits-dir"
pip_exits_dir="${base_dir}/${pip_exits_name}"
echo $pip_exits_dir
if [ ! -d ${pip_exits_dir} ];then
    echo $pip_message
    cd $base_dir \
    && mkdir $pip_exits_name

    cd $project_dir \
    && pip install -r  requirements.txt \
    && pip install git+https://gitee.com/langlele/whisper.git
else
    echo $pip_message_exits
fi


# 下载nkl 并安装
nkl_name="nltk_data-gh-pages"
nkl_dir_name="nkl"
nkl_dir="${base_dir}/${nkl_dir_name}"
if [ ! -d ${nkl_dir} ];then
    echo "nkl 不存在，下载nkl"
    mkdir /root/nltk_data
    cd $base_dir \
    && mkdir $nkl_dir_name

    cd $nkl_dir \
    && git clone https://oauth2:${MY_TOKEN}@www.modelscope.cn/langll1990/nltk_data-gh-pages.git \
    && cd $nkl_name \
    && unzip nltk_data-gh-pages.zip \
    && mv nltk_data-gh-pages/packages/* /root/nltk_data
else
    echo "nkl 已安装"
fi


# 下载 base 模型 并放到 指定文件夹 /mnt/workspace/Bert-VITS2/bert/chinese-roberta-wwm-ext-large
base_module_dir="${project_dir}/bert"
base_module_name="chinese-roberta-wwm-ext-large"
base_module_big_file="${base_module_dir}/${base_module_name}/tf_model.h5"
if [ ! -f ${base_module_big_file} ];then
    echo "不存在-模型文件${base_module_big_file} \n"
    cd $base_module_dir \
    && rm -rf $base_module_name 

    cd $base_module_dir \
    && git lfs install \
    && git clone https://oauth2:${MY_TOKEN}@www.modelscope.cn/langll1990/chinese-roberta-wwm-ext-large.git
else
    echo "存在-模型文件${base_module_big_file} \n"
fi

# 安装ffmpeg
if type ffmpeg >/dev/null 2>&1; then 
  echo 'exists ffmpeg' 
else 
  echo 'no exists git' 
  sudo apt update \
  && sudo apt install ffmpeg
fi

# 下载 wavlm-base-plus-sv git clone https://www.modelscope.cn/langll1990/wavlm-base-plus-sv.git

wavlm_base_plus_dir="${project_dir}/slm"
wavlm_base_plus_file="${wavlm_base_plus_dir}/wavlm-base-plus/pytorch_model.bin"

if [ ! -f ${wavlm_base_plus_file} ];then
    echo "不存在-模型文件${wavlm_base_plus_file} \n"
    cd $wavlm_base_plus_dir \
    && rm -rf wavlm-base-plus

    cd $wavlm_base_plus_dir \
    && git lfs install \
    && git clone https://oauth2:${MY_TOKEN}@www.modelscope.cn/langll1990/wavlm-base-plus-sv.git \
    && mv wavlm-base-plus-sv wavlm-base-plus
else
    echo "存在-模型文件${base_module_big_file} \n"
fi



# 下载 用于训练的 基础模型 git clone https://oauth2:${MY_TOKEN}@www.modelscope.cn/langll1990/Bert-VITS2-zh.git
base_module_dir="${project_dir}/genshin_mix"
base_module_file="${base_module_dir}/models/G_0.pth"
if [ ! -f ${base_module_file} ];then
    echo "不存在-基础模型文件${base_module_file} \n"
    cd $project_dir \
    && mkdir genshin_mix

    cd $base_module_dir \
    && git lfs install \
    && git clone https://oauth2:${MY_TOKEN}@www.modelscope.cn/langll1990/Bert-VITS2-zh.git \
    && mv Bert-VITS2-zh models
else
    echo "存在-模型文件${base_module_big_file} \n"
fi

