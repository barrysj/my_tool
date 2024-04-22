#include <stdio.h>
#include <iostream>
#include <limits.h>
#include <stdint.h>
#include <stdlib.h>

using namespace std;

char* GetTimeFormatMS(const struct timeval &stTimeval, char* szDateTime)
{
    time_t l_time = (time_t)stTimeval.tv_sec;
    struct tm stTm ;
    localtime_r(&l_time, &stTm);
    
    sprintf(szDateTime, "%04d-%02d-%02d %02d:%02d:%02d.%03ld",
        stTm.tm_year+1900, stTm.tm_mon+1, stTm.tm_mday,
        stTm.tm_hour, stTm.tm_min, stTm.tm_sec, stTimeval.tv_usec/1000);
    
    return szDateTime;
}
int main()
{
    uint64_t nowMs = 0;
    cout << "give me timestamp in ms ..." << endl;
    while(1) {
        cout << ">>>";
        cin >> nowMs;
        uint64_t secPart = nowMs / 1000, msPart = nowMs % 1000;
        struct timeval tv;
        tv.tv_sec = secPart;
        tv.tv_usec = msPart * 1000;

        char timeStr[50] = {0};
        cout << GetTimeFormatMS(tv, timeStr) << endl;
    }
    return 0;
}
