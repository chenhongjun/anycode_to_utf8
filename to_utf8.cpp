#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <unistd.h>
#include <string>
#include <iostream>
using namespace std;
bool get_old_code(const string& file_name, string& old_code)
{
        FILE* fp = NULL;
        char cmd[1024] = {'\0'};
        sprintf(cmd, "file -i %s", file_name.c_str());
        if ((fp = popen(cmd, "r")) != NULL) {
            fgets(cmd, sizeof(cmd), fp);
            pclose(fp);
        }
    char source[128] = {'\0'};
    for (char* p = cmd; *p != '\0' && *p != '\n'; ++p) {
        if (*p == '=') {
            ++p;
            for (char* q = source; *p != '\n' && *p != '\0';) {
                *q++ = *p++;
            }
        }
    }
    for (char* p = source; *p != '\0' && *p != '\n'; ++p) {
        *p = toupper(*p);
    }
    old_code.assign(source);
    return true;
}

bool to_utf8(const string& file_name) {
    string old_code;
    string new_file_name = file_name+".tmp";
    FILE* fp = NULL;
    if (get_old_code(file_name, old_code)) {
        if (old_code == string("BINARY"))
            return false;
        char cmd[1024] = {'\0'};
        sprintf(cmd, "iconv -f %s -t UTF-8 -o %s %s", old_code.c_str(), new_file_name.c_str(), file_name.c_str());
        if ((fp = popen(cmd, "r")) != NULL) {
            fgets(cmd, sizeof(cmd), fp);
            pclose(fp);
            sprintf(cmd,"mv -f %s %s", new_file_name.c_str(), file_name.c_str());
            if ((fp = popen(cmd, "r")) != NULL) {
                fgets(cmd, sizeof(cmd), fp);
                cout << file_name << " : " << old_code << endl;
                return true;
            }
        }
    }
    return false;
}

int main(int argc, char* argv[]) {
    to_utf8(argv[1]);
    return 0;
}
