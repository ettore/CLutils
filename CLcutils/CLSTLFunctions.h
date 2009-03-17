/*
 *  CLSTLFunctions.h
 *  Additional functions for STL
 *  Created by ep on 24/1/05.
 *  Copyright 2005 Cubelogic. All rights reserved.
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
