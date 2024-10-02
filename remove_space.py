# encoding: utf8
# 去除测试文件中的原有空格

from pathlib import Path

def main():
    file_path: str = input("请输入文件路径：")
    with Path(file_path).open('r', encoding='utf8') as f:
        lines = f.readlines()

    lines = ["".join(i.split()) for i in lines if len(i.split()) > 0]
    lines = [i + '\n' for i in lines]

    with Path(file_path).open('w', encoding='utf8') as f:
        f.writelines(lines)

if __name__ == '__main__':
    main()