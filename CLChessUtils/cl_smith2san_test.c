/*
 *  cl_smith2san_test.c
 *  CLChessUtils
 *  Created by Ettore Pasquini on 9/2/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#include <string.h>
#include <assert.h>
#include <cl_debug.h>
#include <CUnit/CUnit.h>

#include "cl_smith2san_test.h"
#include "cl_smith2san.h"

////////////////////////////////////////////////////////////////////////////////
// for examples: http://en.wikipedia.org/wiki/Chess_notation
////////////////////////////////////////////////////////////////////////////////

// CUNIT: http://w3.scs.ryerson.ca/~schi/cps707/

static void test_short_castling()
{
    const char *smith = "e1g1c";//coord are for the king's movement
    const char *san_correct = "O-O";
    
    char san1[8];
    
    
    smith2san(smith, san1);
    //assert(strncmp(san_correct, san1, strlen(san1)) == 0);
    CU_ASSERT(strncmp(san_correct, san1, strlen(san1)) == 0);
}

static void test_long_castling()
{
    CU_ASSERT(1);
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
    if ((NULL == CU_add_test(s1, "test short castling", test_short_castling)) ||
        (NULL == CU_add_test(s1, "test long  castling", test_long_castling)))
    {
        CU_cleanup_registry();
        return CU_get_error();
    }
    
    return 0;
}
