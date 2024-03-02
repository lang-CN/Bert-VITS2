# 训练bert-vits

## python 版本
```
Python 3.11.5
```
## 执行 env 脚本
```
#设置 token 下载 modelscope 中自己的模型
export MODELSCOPE_OAUTH2_TOKEN="*********"
# 授权
chmod 777 /mnt/workspace/env.sh

#执行
/mnt/workspace/env.sh

```

## 数据准备 zb_data_train.sh 脚本

```
# 授权
chmod 777 /mnt/workspace/Bert-VITS2/zb_data_train.sh

#执行
/mnt/workspace/Bert-VITS2/zb_data_train.sh
```

## 说明

去掉了 其他语言，只训练了 中文
后续在添加其他