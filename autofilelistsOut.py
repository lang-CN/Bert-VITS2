import os
import argparse

def process(out_file, ch_name):
    with open(out_file,'w' , encoding="Utf-8") as wf:
        ch_language = 'ZH'
        path = f"./raw/{ch_name}"
        files = os.listdir(path)
        for f in files:
            if f.endswith(".lab"):
                with open(os.path.join(path,f),'r', encoding="utf-8") as perFile:
                    line = perFile.readline() 
                    result = f"./raw/{ch_name}/{f.split('.')[0]}.wav|{ch_name}|{ch_language}|{line}"
                    wf.write(f"{result}\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-f",
        "--file",
        type=str,
        help="标注汇总文件",
        default="filelists/genshin_out.txt",
    )
    parser.add_argument(
        "-mjc",
        "--modlejc",
        type=str,
        help="模型简称",
        default="cxj",
    )
    args = parser.parse_args()
    print(f"标注汇总文件 {args.file}, 模型简称{args.modlejc}")
    process(args.file, args.modlejc)
