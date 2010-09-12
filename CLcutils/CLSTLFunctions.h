/*
 *  $Id$
 *  Additional functions for STL
 *  Created by ep on 24/1/05.

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

#ifndef CL_STL_FUNCTIONS_H_
#define CL_STL_FUNCTIONS_H_
#include <iostream>
#include <fstream>
#include <vector>
#include <iterator>
#include <ios>

extern const char *ALL_DELIMITERS;

//
// ## declarations ##
//

template <typename elemtype>
void display(const std::vector<elemtype> &v, 
             std::ostream &os = std::cout,
             const std::string &sep = std::string(", "));

//
// ## template definitions ##
// We usually put the entire template declaration and definition in the 
// header file because the compiler won't allocate storage for anything
// preceded by template<...>: it will instead wait until it's told to 
// (by a template instantiation)
//

template <typename elemtype>
void display(const std::vector<elemtype> &v, 
             std::ostream &os, 
             const std::string &sep)
{
    // the compiler doesn't know if std::vector<elemtype>::const_iterator is a
    // name of a type or not. If it is, fine, but if it's not we will have an
    // error. Therefore we declare it is a type adding the typename keyward.
    typename std::vector<elemtype>::const_iterator iter = v.begin();
    typename std::vector<elemtype>::const_iterator last = v.end();
    // if vector is empy, iter == last, so the for-loop never executes
    for (; iter < last; iter++)
    {
        os << *iter << sep;
    }
    os << endl;
}

/* p is a pointer to a just opened file. This function 
   returns a negative number if an error exist with the file. 
   If an error is found then p is 0 and a message is printed on stderr. */
int checkOpenedIfstream(std::ifstream *p);

/* Only works with strings that contain only one word.  */
std::string word_trim(const std::string&, const char* delim = ALL_DELIMITERS);
std::string word_trim_cs(char* cs, const char* delimtrs = ALL_DELIMITERS);


#endif
