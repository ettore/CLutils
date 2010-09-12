/*  $Id$
 *  CLUtils
 *  Created by ep on 22/1/05.

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

#ifndef CL_GENUTILS_H_
#define CL_GENUTILS_H_

#ifdef __cplusplus
extern "C" {
#endif
    
#include <sys/types.h>

double min(double x, double y);
    
/* 
 * If no more space is available, malloc returns a null pointer. One should 
 * check the value of every call to malloc. This subroutine calls malloc and 
 * reports an error if the value is a null pointer, returning only if the value
 * is nonzero. This function is conventionally called xmalloc. */
void *xmalloc (size_t size);

/* 
 * Copies the array of strings `src' into `dst'. `dst' points to a region
 * (allocated by the caller) capable of containing `src_len' pointers to char.
 * The space required to copy the individual strings referenced by `src' is 
 * malloced by this function. One should NOT call this function 2 consecutive
 * times over the same `dst' array without calling strarrfree() before the 
 * 2nd invocation. */
void strarrcpy(char *dst[], const char *src[], int src_len);

/*
 * Frees the memory allocated by the array of strings `arr'. */
void strarrfree(char *arr[], int arr_len);
    
/*
 * Concatenates the `strarr' array of `arrlen' strings into `dst'.
 * This function executes multiple reallocs on `dst' to contain all the 
 * strings of the input array, so `dst' must be malloced by the caller (to
 * at least 1 byte in order to include the ending '\0'). Returns `dst'. 
 * If arrlen is <= 0 or if strarr is null, a '\0' is written on dst[0]. */
char *strarrcat(char *dst, const char *strarr[], int arrlen);

/* 
 * Initializes the random generator with 8 bytes. (See "man random".) */
void cl_init_random(void);

#ifdef __cplusplus
}
#endif

#endif
