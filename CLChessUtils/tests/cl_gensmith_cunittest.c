/*
 *  cl_gensmith_cunittest.c
 *  CLChessUtils
 *  Created by Ettore Pasquini on 4/14/10.
 *  Copyright 2010 Cubelogic. All rights reserved.
 */

#include <string.h>
#include <assert.h>
#include <cl_debug.h>
#include <CUnit/CUnit.h> // CUNIT: http://w3.scs.ryerson.ca/~schi/cps707/

#include "cl_gensmith_cunittest.h"
#include "cl_chess_utils.h"
#include "cl_smith_utils.h"

static void test_move_no_capt()
{
    char smith[8];
    CHESSVIEW_PIECES board[64];
    char *fen = "rnbqkbnr/ppppppp1/8/7p/6P1/8/PPPPPP1P/RNBQKBNR w KQkq h6 0 1";
    
    // white to move
    fen2board(board, fen);
    gen_smith(smith, 30, 38, ' ', board);
    CU_ASSERT(strncmp(smith, "g4g5", 8) == 0);
    
    gen_smith(smith, 30, 39, ' ', board);
    CU_ASSERT(strncmp(smith, "g4h5p", 8) == 0);
    
    // black to move
    fen = "r3k2r/p1pn1pp1/bp5n/1N1qp1Pp/1bPp2Q1/BP2P2B/P2PNP1P/R3K2R b KQkq c3 0 1";
    fen2board(board, fen);
    
    gen_smith(smith, 53, 37, ' ', board);
    CU_ASSERT(strncmp(smith, "f7f5", 8) == 0);
}

static void test_captures()
{
    char smith[8];
    CHESSVIEW_PIECES board[64];
    char *fen;

    // white to move
    fen = "r3k2r/p1pn2p1/bp5n/1N1qppPp/1bPp2Q1/BP2P2B/P2PNP1P/R3K2R w KQkq f6 0 1";
    fen2board(board, fen);
    gen_smith(smith, 38, 47, ' ', board);//pawn captures knight
    CU_ASSERT(strncmp(smith, "g5h6n", 8) == 0);

    gen_smith(smith, 16, 25, ' ', board);//bishop capt bishop
    CU_ASSERT(strncmp(smith, "a3b4b", 8) == 0);

    gen_smith(smith, 33, 50, ' ', board);//knight capt pawn
    CU_ASSERT(strncmp(smith, "b5c7p", 8) == 0);
    
    gen_smith(smith, 38, 45, ' ', board); // en passant capture
    CU_ASSERT(strncmp(smith, "g5f6E", 8) == 0);

    // black to move
    fen = "r3k2r/p1pn1pp1/bp5n/1N1qp1Pp/1bPp2Q1/BP2P2B/P2PNP1P/R3K2R b KQkq c3 0 1";
    fen2board(board, fen);

    gen_smith(smith, 40, 33, ' ', board);//black bishop capt knight
    CU_ASSERT(strncmp(smith, "a6b5n", 8) == 0);

    gen_smith(smith, 25, 16, ' ', board);//black bishop capt bishop
    CU_ASSERT(strncmp(smith, "b4a3b", 8) == 0);

    gen_smith(smith, 35, 7, ' ', board);//black queen capt rook
    CU_ASSERT(strncmp(smith, "d5h1r", 8) == 0);
    
    gen_smith(smith, 39, 30, ' ', board); // black pawn capt queen
    CU_ASSERT(strncmp(smith, "h5g4q", 8) == 0);
    
    gen_smith(smith, 27, 18, ' ', board); // en passant capture
    CU_ASSERT(strncmp(smith, "d4c3E", 8) == 0);
}

static void test_castling()
{
    char smith[8];
    CHESSVIEW_PIECES board[64];
    char *fen;
    
    // white to move
    fen = "r3k2r/p1pn2p1/bp5n/1N1qppPp/1bPp2Q1/BP2P2B/P2PNP1P/R3K2R w KQkq f6 0 1";
    fen2board(board, fen);
    
    gen_smith(smith, 4, 6, ' ', board);//white short castling
    CU_ASSERT(strncmp(smith, "e1g1c", 8) == 0);

    gen_smith(smith, 4, 2, ' ', board);//white long castling
    CU_ASSERT(strncmp(smith, "e1c1C", 8) == 0);

    // black to move
    fen = "r3k2r/p1pn1pp1/bp5n/1N1qp1Pp/1bPp2Q1/BP2P2B/P2PNP1P/R3K2R b KQkq c3 0 1";
    fen2board(board, fen);

    gen_smith(smith, 60, 62, ' ', board);//black short castling
    CU_ASSERT(strncmp(smith, "e8g8c", 8) == 0);
    
    gen_smith(smith, 60, 58, ' ', board);//black long castling
    CU_ASSERT(strncmp(smith, "e8c8C", 8) == 0);
    
}

// add individual smith2san tests here
int addGensmithTests()
{
    // create suite and add it to registry
    CU_pSuite s1 = CU_add_suite("gensmith", NULL, NULL);
    if (NULL == s1) {
        CU_cleanup_registry();
        return CU_get_error();
    }
    
    // add tests to suite
    if ((NULL == CU_add_test(s1, "simple moves no capt", test_move_no_capt))
        || (NULL == CU_add_test(s1, "captures", test_captures))
        || (NULL == CU_add_test(s1, "castling", test_castling))
        )
    {
        CU_cleanup_registry();
        return CU_get_error();
    }
    
    return 0;
}
