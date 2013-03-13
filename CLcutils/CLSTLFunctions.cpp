/*
 *  $Id$

 Copyright (c) 2010, Cubelogic. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, 
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 * Neither the name of Cubelogic nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.
 */

#include <cstring>
#include <cstdlib>
using namespace std;
#include "CLSTLFunctions.h"

const char *ALL_DELIMITERS = " \"\\|!/()=?^'{[]}+*¬∞¬‚#¬.-;:_<>¶¢ ¬∑`¬´¬•~√∑¬¥`†ƒ±¬ª∞∫¬ø¬±‚û¬®¬¨#¬∂¶¢¬Ø¬∏° ¬∑\t\n";

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

