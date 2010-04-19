/*
 *  cl_chess_defs.h
 *  CLChessUtils
 *
 
 Copyright (c) 2004 Richard D. Bischoff 
 Copyright (c) 2010 Ettore Pasquini (mofifications)
 
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

#ifndef cl_chess_defs_h_
#define cl_chess_defs_h_

#pragma mark -
#pragma mark Defs

typedef struct {
	int row;
	int col;
} Coord;

#define NEW_GAME_FEN @"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
#define SAMPLE_GAME_FEN @"rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2"

#define SETCOORD(foo, x, y) { foo.row = x; foo.col = y; }
#define CLEARCOORD(foo) { foo.row = -1; foo.col = -1; }
#define COORDSEQUAL(foo, bar) ( foo.row == bar.row && foo.col == bar.col )
typedef enum  {
	CV_WPAWN = 0,
	CV_WKNIGHT,
	CV_WBISHOP,
	CV_WROOK,
	CV_WQUEEN,
	CV_WKING,
	CV_BPAWN,
	CV_BKNIGHT,
	CV_BBISHOP,
	CV_BROOK,
	CV_BQUEEN,
	CV_BKING,
	CV_EMPTY
} CHESSVIEW_PIECES;

typedef enum {
	CV_NO,
	CV_YES,
    CV_CHANGE
} CHESSVIEW_RESULT;

typedef enum { 
	GAME_NONE,
	GAME_NEW,
	GAME_INACTIVE,
	GAME_USERWHITE,
	GAME_USERBLACK,
	GAME_USEREXAMINE,   //ep currently not implemented
	GAME_USEROBSERVING  //ep currently not implemented
} GAME_STATUS;

typedef enum {
	MOVESPECIAL_NORMAL,
	
	MOVESPECIAL_WHITE_CASTLEKINGSIDE,
	MOVESPECIAL_WHITE_CASTLEQUEENSIDE,
	MOVESPECIAL_WHITE_ENPASSANT,
	MOVESPECIAL_WHITE_PROMOTEQUEEN,
	MOVESPECIAL_WHITE_PROMOTEROOK,
	MOVESPECIAL_WHITE_PROMOTEBISHOP,
	MOVESPECIAL_WHITE_PROMOTEKNIGHT,
    
	MOVESPECIAL_BLACK_CASTLEKINGSIDE,
	MOVESPECIAL_BLACK_CASTLEQUEENSIDE,
	MOVESPECIAL_BLACK_ENPASSANT,
	MOVESPECIAL_BLACK_PROMOTEQUEEN,
	MOVESPECIAL_BLACK_PROMOTEROOK,
	MOVESPECIAL_BLACK_PROMOTEBISHOP,
	MOVESPECIAL_BLACK_PROMOTEKNIGHT
} MOVESPECIAL;

// tags are a monotone enumeration (0..63) of the squares from white's 
// perspective. Basically suppose to have white at bottom and start counting 
// from bottom left to right and up.
#define H1Tag 7
#define G1Tag 6
#define F1Tag 5
#define D1Tag 3
#define C1Tag 2
#define A1Tag 0
#define H8Tag 63
#define G8Tag 62
#define F8Tag 61
#define D8Tag 59
#define C8Tag 58
#define A8Tag 56
#define H7Tag 55
#define H5Tag 47
#define A4Tag 32
#define A2Tag 8

extern int WOB_whiteIndices[32];
extern int WOT_whiteIndices[32];
extern int WOB_blackIndices[32];
extern int WOT_blackIndices[32];
extern int WOT_rects[64];
extern int WOB_rects[64];

#pragma mark -
#pragma mark Utils

char CVPieceToChar(CHESSVIEW_PIECES p);
CHESSVIEW_PIECES charToChessPiece(char x);
double min(double x, double y);
// signed char means boolean here
signed char isPieceWhite(CHESSVIEW_PIECES p);
signed char isPieceBlack(CHESSVIEW_PIECES p);
int cellDistance(int sourceR, int sourceC, int targetR, int targetC);

#endif

