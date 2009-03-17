/*  cl_genutils.c
 *  CubelogicCommon
 *  Created by ep on 22/1/05.
 *  Copyright 2005 Cubelogic. All rights reserved.
 */

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "cl_debug.h"
#include "cl_genutils.h"

/* -------------------------------------------------------------------------- */
void *xmalloc(size_t size)
{
    register void *value = (void *)malloc (size);
    if (value == 0)
    {
        //fatal ("cl_genutils: virtual memory exhausted");
        printf("cl_genutils: virtual memory exhausted\n");
        exit(-1);
    }
    return value;
}

/* -------------------------------------------------------------------------- */
void strarrcpy(char *dst[], const char *src[], int src_len)
{
    int i, len;
    
    if (src == NULL)
        return;
    
    for (i=0; i < src_len; i++)
    {
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
        for (i=0; i<arr_len; i++)
            free(arr[i]);
        free(arr);
    }
}

/* -------------------------------------------------------------------------- */
char *strarrcat(char *dst, const char *strarr[], int arrlen)
{
    int i, len = 0;
    
    if (dst == NULL)
        return NULL;
    
    if (strarr && (arrlen > 0))
    {
        len = strlen(strarr[0]);
        debug0msg("strarrcat(): strlen(strarr[0]) = %d", len);
        if (len > 0)
        {
            // we suppose the caller has malloced dst to at least 1 byte
            realloc(dst, len * sizeof(char));
            strncpy(dst, strarr[0], len);
        }
        dst[len] = '\0';
        debug0msg("strarrcat(): 1st string is done, dst= %s", dst);
        
        for (i=1; i<arrlen; i++)
        {
            len = strlen(strarr[i]);
            if (len > 0)
            {
                // we realloc to just len (and not len+1) cos we don't wanna 
                // copy the '\0' of every string
                realloc(dst, len * sizeof(char));

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
void cl_init_random()
{
    char state[8] = {1, 231, 19, 107, 245, 219, 86, 70};
    initstate(129534, state, 8);
}

