# encoding: utf8
# 去除测试文件中的原有空格

from pathlib import Path
import re

def main():
    file_path: str = input("请输入文件路径：")
    path = Path(file_path)
    with Path(file_path).open('r', encoding='gbk') as f:
        lines = f.readlines()

    lines = [re.sub(r';.*', '', i) for i in lines] # 去除文件中的注释
    lines = ["".join(i.split()) for i in lines if len(i.split()) > 0]
    lines = [i + '\n' for i in lines]

    with path.with_name(path.stem + '_new' + path.suffix).open('w', encoding='utf8') as f:
        f.writelines(lines)

if __name__ == '__main__':
    main()