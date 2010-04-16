/*
 *  cl_chess_defs.c
 *  CLChessUtils
 
 Copyright (c) 2004 Richard D. Bischoff 
 Copyright (c) 2010 Ettore Pasquini (modifications)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 associated documentation files (the "Software"), to deal in the Software without restriction, including 
 without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
 copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to 
 the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
 FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#include <assert.h>
#include "cl_chess_defs.h"
#include "cl_debug.h"

/* We don't do any error checking- if you break it, your fault :-) */
char CVPieceToChar(CHESSVIEW_PIECES p) {
	char array[] = "PNBRQKpnbrqk-?";
	
	assert(array[CV_WPAWN] == 'P');
	assert(array[CV_WKNIGHT] == 'N');
	assert(array[CV_WBISHOP] == 'B');
	assert(array[CV_WROOK] == 'R');
	assert(array[CV_WQUEEN] == 'Q');
	assert(array[CV_WKING] == 'K');
	assert(array[CV_BPAWN] == 'p');
	assert(array[CV_BKNIGHT] == 'n');
	assert(array[CV_BBISHOP] == 'b');
	assert(array[CV_BROOK] == 'r');
	assert(array[CV_BQUEEN] == 'q');
	assert(array[CV_BKING] == 'k');
	assert(array[CV_EMPTY] == '-');
	
	int k = (int)p;
	if (k > CV_EMPTY) k = CV_EMPTY+1;
	return array[k];
}

CHESSVIEW_PIECES charToChessPiece(char x) {
	switch (x) { 
		case 'R': return CV_WROOK;
		case 'N': return CV_WKNIGHT;
		case 'B': return CV_WBISHOP;
		case 'Q': return CV_WQUEEN;
		case 'K': return CV_WKING;
		case 'P': return CV_WPAWN;
		case 'r': return CV_BROOK;
		case 'n': return CV_BKNIGHT;
		case 'b': return CV_BBISHOP;
		case 'q': return CV_BQUEEN;
		case 'k': return CV_BKING;
		case 'p': return CV_BPAWN;
		case '-': return CV_EMPTY;
		default : 
			LOG("error in charToChessPiece: unknown char (%c)", x);
			return -999;
	}
}

signed char isPieceWhite(CHESSVIEW_PIECES p) {
	signed char array[] = 
    {
        1, 1, 1, 1, 1, 1,
        0, 0, 0, 0, 0, 0,
        0
    };
	return array[p];
}

signed char isPieceBlack(CHESSVIEW_PIECES p) {
	signed char array[] =
    {
        0, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 1,
        0
    };
    return array[p];
}

int cellDistance(int sourceR, int sourceC, int targetR, int targetC) {
	int result = 0;
	
	while ( ! ((sourceR == targetR) && (sourceC == targetC)) ) {
		++result;
		
		if ( targetR > sourceR ) ++sourceR;
		else if ( targetR < sourceR ) --sourceR;
		
		if ( targetC > sourceC) ++sourceC;
		else if ( targetC < sourceC ) --sourceC;
	}
	return result;
}   

int WOB_whiteIndices[32] = {
    1,    3,    5,    7,
	8,   10,   12,   14,
    17,   19,   21,   23,
	24,  26,   28,   30,
    33,   35,   37,   39,
	40,  42,   44,   46, 
    49,   51,   53,   55,
	56,  58,   60,   62
};

int WOT_whiteIndices[32] = {
	62, 60, 58, 56,
	55, 53, 51, 49,
	46, 44, 42, 40,
	39, 37, 35, 33,
	30, 28, 26, 24,
	23, 21, 19, 17, 
	14, 12, 10,  8,
    7,  5,  3,  1 };

int WOB_blackIndices[32] = {
	0, 2, 4, 6, 
	9, 11, 13, 15, 
	16, 18, 20, 22,
	25, 27, 29, 31,
	32, 34, 36, 38,
	41, 43, 45, 47,
	48, 50, 52, 54,
	57, 59, 61, 63 };

int WOT_blackIndices[32] = {
	63, 61, 59, 57,
	54, 52, 50, 48,
	47, 45, 43, 41,
	38, 36, 34, 32,
	31, 29, 27, 25,
	22, 20, 18, 16,
	15, 13, 11, 9,
	6, 4, 2, 0 };


int WOT_rects[64] = {
	63, 31, 62, 30, 61, 29, 60, 28,
	27, 59, 26, 58, 25, 57, 24, 56,
	55, 23, 54, 22, 53, 21, 52, 20,
	19, 51, 18, 50, 17, 49, 16, 48,
	47, 15, 46, 14, 45, 13, 44, 12,
	11, 43, 10, 42,  9, 41,  8, 40,	
	39, 7, 38, 6, 37, 5, 36, 4,
	3, 35, 2, 34, 1, 33, 0, 32 };

int WOB_rects[64] = {
	32, 0, 33, 1, 34, 2, 35, 3,
	4, 36, 5, 37, 6, 38, 7, 39,
 	40, 8, 41, 9, 42, 10, 43, 11,
	12, 44, 13, 45, 14, 46, 15, 47,
	48, 16, 49, 17, 50, 18, 51, 19,
	20, 52, 21, 53, 22, 54, 23, 55,
	56, 24, 57, 25, 58, 26, 59, 27,
	28, 60, 29, 61, 30, 62, 31, 63
};
