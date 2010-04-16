/*
 *  cl_chess_utils.c
 *  CLChessUtils
 *  Created by Ettore Pasquini on 4/15/10.
 *  Copyright 2010 Cubelogic. All rights reserved.
 */

#include "cl_chess_utils.h"

void fen2board(CHESSVIEW_PIECES board[64], const char *fen)
{
    int i;
	int fi = 0;
	int row = 7;
	int col = 0;
	int index;

    for (i = 0; i < 64; ++i)
        board[i] = CV_EMPTY;
	
    // scan input fen up to the first ' ' that is only the first field of the 
    // full FEN string, i.e. the one containing the static board pos info. 
    // Eg: rnbqkbnr/pppppppp/8/8/5P2/8/PPPPP1PP/RNBQKBNR b KQkq f3 0 1
    //             up to here, not including the 'b' ----^
    // after all that's all we need to just display the board position.
	while ( fen[fi] != ' ' ) 
    {
		index = 8*row + col;
		switch (fen[fi]) {
			case 'R': board[index] = CV_WROOK; break;
			case 'N': board[index] = CV_WKNIGHT; break;
			case 'B': board[index] = CV_WBISHOP; break;
			case 'Q': board[index] = CV_WQUEEN; break;
			case 'K': board[index] = CV_WKING; break;
			case 'P': board[index] = CV_WPAWN; break;
    		case 'r': board[index] = CV_BROOK; break;
			case 'n': board[index] = CV_BKNIGHT; break;
			case 'b': board[index] = CV_BBISHOP; break;
			case 'q': board[index] = CV_BQUEEN; break;
			case 'k': board[index] = CV_BKING; break;
			case 'p': board[index] = CV_BPAWN; break;
			case '-': break;
			case '/': --row; col = -1; break;
			default:
				col += fen[fi] - '1';
		}
		++col;
		++fi;
	}
}
