/*
 *  cl_chess_utils.h
 *  CLChessUtils
 *  Created by Ettore Pasquini on 4/15/10.
 *  Created by Ettore Pasquini on 9/2/09.
 *  Copyright 2010 Cubelogic. All rights reserved.
 *  Copyright 2010 Ettore Pasquini. All rights reserved.

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

#ifndef cl_chess_utils_h_
#define cl_chess_utils_h_

#include "cl_chess_defs.h"

/*!
 @abstract
 Populate board matrix with position from FEN string.

 @discussion
 This function populates a pre-allocated array with pieces from a FEN
 string. The output array describes a 8x8 board from bottom left to top right.

 For more info about Forsyth–Edwards Notation (FEN) see
 https://en.wikipedia.org/wiki/FEN

 @param fen     The input board position
 @param board   The output board. Memory should be allocated by client.
 */
void cl_fen2board(const char *fen, CHESSVIEW_PIECES board[64]);

/*!
 * Generates move in Smith format.<br>
 * <br>
 * @param smith Return string. Assume length of 8 characters as in char s[8]
 * @param from  Monotone tag (0-63) representing a square
 * @param to    Monotone tag (0-63) representing a square
 * @param promote  'Q','R','B','N'
 * @param board Current board. Not to be confused with struct Board in board.h
 */
void cl_gen_smith(char *smith, int from, int to,
                  char promote, CHESSVIEW_PIECES board[64]);

#endif
