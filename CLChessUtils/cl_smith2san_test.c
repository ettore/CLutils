/*
 *  cl_smith2san_test.c
 *  CLChessUtils
 *  Created by Ettore Pasquini on 9/2/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#include <string.h>
#include <assert.h>
#include <cl_debug.h>
#include <CUnit/CUnit.h> // CUNIT: http://w3.scs.ryerson.ca/~schi/cps707/

#include "cl_smith2san_test.h"
#include "cl_smith2san.h"

// for examples: http://en.wikipedia.org/wiki/Chess_notation

////////////////////////////////////////////////////////////////////////////////
// Tests
////////////////////////////////////////////////////////////////////////////////

static void test_normalpawn1()
{
    char san[8];
    // white pawn advancing
    const char *smith1 = "e2e4";
    const char *san_correct1 = "e4";
    smith2san(smith1, san);
    CU_ASSERT(strncmp(san_correct1, san, strlen(san)) == 0);

    // black pawn advancing
    const char *smith2 = "e7e5";
    const char *san_correct2 = "e5";
    smith2san(smith2, san);
    CU_ASSERT(strncmp(san_correct2, san, strlen(san)) == 0);
    
}


static void test_castling()
{
    char san[8];

    const char *smith1 = "e1g1c";//coord are for the king's movement
    const char *san_correct1 = "O-O";
    smith2san(smith1, san);
    CU_ASSERT(strncmp(san_correct1, san, strlen(san)) == 0);

    const char *smith2 = "e1c1C";//coord are for the king's movement
    const char *san_correct2 = "O-O-O";
    smith2san(smith2, san);
    CU_ASSERT(strncmp(san_correct2, san, strlen(san)) == 0);
    
    const char *smith3 = "e8g8c";//coord are for the king's movement
    const char *san_correct3 = "O-O";
    smith2san(smith3, san);
    CU_ASSERT(strncmp(san_correct3, san, strlen(san)) == 0);
    
    const char *smith4 = "e8c8C";//coord are for the king's movement
    const char *san_correct4 = "O-O-O";
    smith2san(smith4, san);
    CU_ASSERT(strncmp(san_correct4, san, strlen(san)) == 0);
}

////////////////////////////////////////////////////////////////////////////////
// tests collector function
////////////////////////////////////////////////////////////////////////////////

// add individual smith2san tests here
int addSmith2SanTests()
{
    // create suite and add it to registry
    CU_pSuite s1 = CU_add_suite("Suite smith2san", NULL, NULL);
    if (NULL == s1) {
        CU_cleanup_registry();
        return CU_get_error();
    }
    
    // add tests to suite
    // NOTE - ORDER IS IMPORTANT - MUST TEST fread() AFTER fprintf()
    if ((NULL == CU_add_test(s1, "test normal pawn move", test_normalpawn1)) ||
        (NULL == CU_add_test(s1, "test castling", test_castling)))
    {
        CU_cleanup_registry();
        return CU_get_error();
    }
    
    return 0;
}
