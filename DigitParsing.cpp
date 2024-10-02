# include <iostream>
# include <fstream>
# include <string>
# include <vector>
# include "digit.tab.h"

extern int yyparse();
extern FILE *yyin;
extern int yylex();

extern "C" int yywrap() {
    return 1;
}

int main() {
    std::string file_path;
    std::cout << "Enter the file path: ";
    std::getline(std::cin, file_path);

    std::ifstream file(file_path);
    if (!file.is_open()) {
        std::cerr << "Error: Unable to open file" << file_path << std::endl;
        return 1;
    }

    std::string line;
    std::string tmp_file = "tmp.txt"; // 存储每行的内容的临时文件
    int line_number = 0;
    std::vector<int> success_lines;
    std::vector<int> failed_lines;
    while (std::getline(file, line)) {
        std::cout << "Now Parsing: " << ++line_number << std::endl;

        std::ofstream tmp(tmp_file);
        tmp << line;
        tmp.close();

        yyin = fopen(tmp_file.c_str(), "r");
        int parse_res = yyparse(); // 调用yyparse()函数进行解析, 返回值为0表示解析成功
        if (parse_res == 0) {
            // std::cout << "Parse Success" << std::endl;
            success_lines.push_back(line_number);
        } 
        else {
            // std::cout << "Parse Fail" << std::endl;
            failed_lines.push_back(line_number);
        }
        fclose(yyin);
    }

    remove(tmp_file.c_str());
    file.close();
    std::cout << "Parse Result: " << std::endl;
    std::cout << "Success: " << success_lines.size() << std::endl;
    std::cout << "Fail: " << failed_lines.size() << std::endl;
    std::cout << "Success Lines: ";
    for (int i = 0; i < success_lines.size(); i++) {
        std::cout << success_lines[i] << " ";
    }
    std::cout << std::endl;
    std::cout << "Failed Lines: ";
    for (int i = 0; i < failed_lines.size(); i++) {
        std::cout << failed_lines[i] << " ";
    }
    std::cout << std::endl;
    return 0;
}