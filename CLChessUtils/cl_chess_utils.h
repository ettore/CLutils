/*
 *  cl_chess_utils.h
 *  CLChessUtils
 *  Created by Ettore Pasquini on 4/15/10.
 *  Copyright 2010 Cubelogic. All rights reserved.
 */

#ifndef cl_chess_utils_h_
#define cl_chess_utils_h_

#include "cl_chess_defs.h"

void fen2board(CHESSVIEW_PIECES board[64], const char *fen);

#endif
