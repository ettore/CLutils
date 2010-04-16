/*
 *  cl_smith_utils.h
 *  CLChessUtils
 *
 *  Created by Ettore Pasquini on 9/2/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 *
 */

#ifndef cl_smith_utils_h_
#define cl_smith_utils_h_

#include "cl_chess_defs.h"

extern int smith2san(const char *smith, char *san);

/**
 * @param smith Return string. Assume length of 8 characters as in char s[8]
 */
void gen_smith(char *smith, int from, int to, 
               char promote, CHESSVIEW_PIECES board[64]);

#endif
