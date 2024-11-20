# encoding: utf8
# date: 2024-11-20
# 从.y文件中提取规则

import re

def extract_rules_from_l_file(l_file_path):
    with open(l_file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Regular expression to match rules in .l file,
    rule_pattern = re.compile(r'(?<=\n)[a-zA-Z_][a-zA-Z0-9_]*\s.*')

    rules = rule_pattern.findall(content)
    readable_rules = []
    for rule in rules:
        left, rights = rule.split(' ', 1)
        right_list = rights.split('|')
        right_list = [right.strip() for right in right_list]
        for right in right_list:
            readable_rules.append(left + ' -> ' + right + ";")

    return readable_rules

def extract_rules_from_y_file(y_file_path):
    with open(y_file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Regular expression to match rules in .y file, ignoring lines starting with 'todo:'
    rule_pattern = re.compile(r'(?<=\n)(?!todo:)[a-zA-Z_][a-zA-Z0-9_]*\s*:\s*[^;]+;')

    rules = rule_pattern.findall(content)
    # 去除注释
    rules = [re.sub(r'//.*', '', rule) for rule in rules]
    # 去除空格
    rules = [re.sub(r'\s+', ' ', rule) for rule in rules]
    # 将规则转换为用->表示的形式
    readable_rules = []
    for rule in rules:
        rule = rule.replace(';', '') # 去除结尾的分号
        left, rights = rule.split(':') # 分割左右部分
        right_list = rights.split('|') # 分割右部的多个可能
        right_list = [right.strip() for right in right_list] # 去除空格
        for right in right_list: # 生成可读的规则
            readable_rules.append(left + ' -> ' + right + ";")

    return readable_rules

# Example usage
y_file_path = 'digit.y'
l_file_path = 'digit.l'
output_file_path = 'num_rule.txt'
rule1 = extract_rules_from_y_file(y_file_path)
rule2 = extract_rules_from_l_file(l_file_path)
rules = rule1 + rule2
with open(output_file_path, 'w', encoding='utf-8') as file:
    for rule in rules:
        file.write(rule + '\n')