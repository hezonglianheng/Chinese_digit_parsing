# include <iostream>
# include <fstream>
# include <string>
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
    while (std::getline(file, line)) {
        std::cout << "Now Parsing: " << ++line_number << std::endl;

        std::ofstream tmp(tmp_file);
        tmp << line;
        tmp.close();

        yyin = fopen(tmp_file.c_str(), "r");
        yyparse();
        fclose(yyin);
    }

    remove(tmp_file.c_str());
    file.close();
    return 0;
}