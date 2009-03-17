/*
 *  CLSTLFunctions.cpp
 *  Created by ep on 24/1/05.
 *  Copyright 2005 Cubelogic. All rights reserved.
 */

#include <cstring>
#include <cstdlib>
using namespace std;
#include "CLSTLFunctions.h"

const char *ALL_DELIMITERS = " \"\\|!/()=?^'{[]}+*Â°Ââ#Â.-;:_<>¦¢ Â·`Â«Â¥~Ã·Â´` Ä±Â»°ºÂ¿Â±âžÂ¨Â¬#Â¶¦¢Â¯Â¸¡ Â·\t\n";

int checkOpenedIfstream(ifstream *myfile)
{
    int ret = 0;
    if (!(*myfile))
    {
        cerr << "checkOpenedStream(): error while opening file" << endl;
        ret =  -1;
    }
    return ret;
}

/* 
The simplest implementation of word_trim() would be:
    return strtok(cs, delim);
where cs is a C string.
*/
string word_trim(const string& cpps, const char* delim)
{
    const char *constcs = cpps.c_str();
    char *cs = (char *)malloc(strlen(constcs));
    strcpy(cs, constcs);
    char *tok = strtok(cs, delim);
    string rets("");
    if (tok != 0)
        rets = tok; // makes a copy f tok
    free(cs);
    return rets; // by value
}

/* tr */
string word_trim_cs(char* cs, const char* delim)
{
    char *tok = strtok(cs, delim);
    string rets("");
    if (tok != 0)
        rets = tok; // makes a copy of tok
    return rets; // return by value
}

