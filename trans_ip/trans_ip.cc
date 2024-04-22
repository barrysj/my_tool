#include <stdio.h>
#include <iostream>
#include <limits.h>
#include <stdint.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <sstream>

using namespace std;

int main()
{
    stringstream ss;
    while(1) {
        string ip_str;
        uint32_t ip_int = 0;
        cout << ">>>";
        getline(cin, ip_str);
        if (ip_str.find('.') == string::npos) {
            ss << ip_str;
            ss >> ip_int;
            // 将整形ip转换为点分十进制ip字符串。同时输出网络和主机序的ip字符串
            cout << "ip(str): " << inet_ntoa(*(struct in_addr *)&ip_int);
        }else {
            // 将点分十进制ip字符串转换为整形ip。同时输出网络的ip字符串和主机序的ip字符串
            ss << inet_addr(ip_str.c_str());
            ss >> ip_int;
            cout << "ip(int): " << ip_int;
        }
        cout << endl;
        ss.clear();
        ss.str("");
    }
    return 0;
}
