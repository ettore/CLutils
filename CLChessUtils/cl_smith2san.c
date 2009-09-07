/*
 *  cl_smith2san.c
 *  CLChessUtils
 *  Created by Ettore Pasquini on 9/2/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#include <stdio.h>
#include <string.h>

int smith2san(const char *smith, char *san)
{
    strncpy(san, smith, strlen(smith));
    return 0;
}
