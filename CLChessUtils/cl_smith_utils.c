/*
 *  cl_smith_utils.c
 *  CLChessUtils
 *  Created by Ettore Pasquini on 9/2/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#include <stdio.h>
#include <string.h>
#include "cl_smith_utils.h"
#include "cl_chess_defs.h"

/**
 This format is defined as follows:
 
 <from square><to square>[<capture indicator>][<promoted to>]
 2 chars     2 chars       0 or 1 char       0 or 1 char
 
 The capture indicator is one of pnbrqkEcC.
 'pnbrqk' indicates the type of piece captured.  
 'E' indicates an en-passant capture
 'c' indicates a short castling move (coordinates are for the king's movements)
 'C' indicates a long castling move
 If it's not a capture, or castling move, the field is empty.
 
 The promotion information is one of "NBRQ", indicating the promoted piece.
 Example:  
    e4g5p   is a N move from e4 to g5 capturing a pawn.
    f7f8Q   is a queening move
    f7g8nQ  is a pawn move capturing a knight and queening.
 
 One advantage of this system that it's easy to parse, and it's reversible--you 
 can walk forward and backward through the move list only knowing the current 
 position at a given time.
 The notation is a "improvement" of a notation suggested by Warren Smith.
 
 Note: bughouse plunks are the same in all move formats, e.g. "Q@f7+"
 Mystery kriegspiel moves are either "?" or of the form "?xb1". 
 */
void gen_smith(char *smith, int from, int to, 
               char promote, CHESSVIEW_PIECES board[64])
{
    int bi = 0;
    
    CHESSVIEW_PIECES frompiece = board[from];
    CHESSVIEW_PIECES topiece = board[to];
    
    memset(smith, 0, 8);
    smith[bi++] = (from % 8) + 'a';
    smith[bi++] = (from / 8) + '1';
    smith[bi++] = (to % 8) + 'a';
    smith[bi++] = (to / 8) + '1';
    
    // capture indicator
    switch (topiece)
    {
        case CV_WPAWN:
        case CV_BPAWN:
            smith[bi++] = 'p';
            break;
        case CV_WKNIGHT:
        case CV_BKNIGHT:
            smith[bi++] = 'n';
            break;
        case CV_WBISHOP:
        case CV_BBISHOP:
            smith[bi++] = 'b';
            break;
        case CV_WROOK:
        case CV_BROOK:
            smith[bi++] = 'r';
            break;
        case CV_WQUEEN:
        case CV_BQUEEN:
            smith[bi++] = 'q';
            break;
        case CV_WKING:
        case CV_BKING:
            smith[bi++] = 'k';
            break;
        case CV_EMPTY:
            // en passant
            if (frompiece == CV_WPAWN && from >= 32 && from <= 39)//wpawn on row 5
            {
                if ((to == from + 7 && board[to-8] == CV_BPAWN)
                    || (to == from + 9 && board[to-8] == CV_BPAWN))
                {
                    smith[bi++] = 'E';
                }
            }
            else if (frompiece == CV_BPAWN && from >= 24 && from <= 31)//bpawn on row 4
            {
                if ((to == from - 7 && board[to+8] == CV_WPAWN)
                    || (to == from - 9 && board[to+8] == CV_WPAWN))
                {
                    smith[bi++] = 'E';
                }
            }
            else if ((from == 4 && to == 6 && frompiece == CV_WKING)
                     || (from == 60 && to == 62 && frompiece == CV_BKING))
            {
                smith[bi++] = 'c';
            }
            else if ((from == 4 && to == 2 && frompiece == CV_WKING)
                     || (from == 60 && to == 58 && frompiece == CV_BKING))
            {
                smith[bi++] = 'C';
            }
            break;
    }
    
    // promotion spot
    if (promote != ' ')
        smith[bi++] = promote;
    
    smith[bi] = 0;
}


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
