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

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "cl_debug.h"
#include "cl_genutils.h"

/* -------------------------------------------------------------------------- */
double min(double x, double y)
{
  return (x < y) ? x : y;
}

/* -------------------------------------------------------------------------- */
void *xmalloc(size_t size)
{
  register void *value = (void *)malloc (size);
  if (value == 0) {
    printf("cl_genutils: virtual memory exhausted\n");
    exit(-1);
  }
  return value;
}

/* -------------------------------------------------------------------------- */
void strarrcpy(char *dst[], const char *src[], int src_len)
{
  int i;
  size_t len;

  if (src == NULL) {
    return;
  }

  for (i=0; i < src_len; i++) {
    len = strlen(src[i]);
    dst[i] = (char *)malloc(sizeof(char) * (len + 1));
    strncpy(dst[i], src[i], len);
    *(dst[i] + len) = '\0';
  }
}

/* -------------------------------------------------------------------------- */
void strarrfree(char *arr[], int arr_len)
{
  int i;
  if (arr)
  {
    for (i=0; i<arr_len; i++) {
      free(arr[i]);
    }
    free(arr);
  }
}

/* -------------------------------------------------------------------------- */
char *strarrcat(char *dst, const char *strarr[], int arrlen)
{
  int i;
  size_t len = 0;

  if (dst == NULL) {
    return NULL;
  }

  if (strarr && (arrlen > 0)) {
    len = strlen(strarr[0]);
    if (len > 0) {
      // we suppose the caller has malloced dst to at least 1 byte
      dst = realloc(dst, len * sizeof(char));
      strncpy(dst, strarr[0], len);
    }
    dst[len] = '\0';

    for (i=1; i<arrlen; i++) {
      len = strlen(strarr[i]);
      if (len > 0) {
        // we realloc to just len (and not len+1) cos we don't wanna
        // copy the '\0' of every string
        dst = realloc(dst, len * sizeof(char));

        // the new string IS NOT longer than available space so no check
        //if (len > sizeof(dst) - strlen(dst) - 1)
        // recall: strncat appends a final '\0'
        //strncat(dst, strarr[i], sizeof(dst) - strlen(dst) - 1);
        strncat(dst, strarr[i], len);
      }
    }
  }
  else *dst = '\0';

  return dst;
}

/* -------------------------------------------------------------------------- */
void cl_init_random(void)
{
  char state[8] = {1, 231, 19, 107, 245, 219, 86, 70};
  initstate(129534, state, 8);
}

