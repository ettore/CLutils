/*
 *  cl_smith2san.c
 *  CLChessUtils
 *  Created by Ettore Pasquini on 9/2/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#include <stdio.h>
#include <string.h>

/**
 * NB: We need to pass in some kind of data structure with the current board 
 * status. 
 */
int smith2san(const char *smith, char *san)
{
    if (strlen(smith) > 4 && smith[4] == 'c')
        strncpy(san, "O-O", 4);
    else if (strlen(smith) > 4 && smith[4] == 'C')
        strncpy(san, "O-O-O", 6);
    else
        strncpy(san, smith+2, 8);
    
    return 0;
}


//    if (strncmp(smith, "e1g1c", 5) == 0)
//        strncpy(san, "O-O", 4);
//    else if (strncmp(smith, "e8g8c", 5) == 0)
//        strncpy(san, "O-O", 4);
//    else if (strncmp(smith, "e1c1C", 5) == 0)
//        strncpy(san, "O-O-O", 6);
//    else if (strncmp(smith, "e8c8C", 5) == 0)
//        strncpy(san, "O-O-O", 6);
