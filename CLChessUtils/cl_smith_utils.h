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

// currently unfinished
int smith2san(const char *smith, char *san);

/**
 * Generates move in Smith format.<br>
 * <br>
 * @param smith Return string. Assume length of 8 characters as in char s[8]
 * @param from  Monotone tag (0-63) representing a square
 * @param to    Monotone tag (0-63) representing a square
 * @param promote  'Q','R','B','N'
 * @param board Current board. Not to be confused with struct Board in board.h
 */
void gen_smith(char *smith, int from, int to, 
               char promote, CHESSVIEW_PIECES board[64]);

#endif
