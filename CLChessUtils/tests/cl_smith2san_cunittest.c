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

#include "cl_smith2san_cunittest.h"
#include "cl_smith2san.h"

// for examples: http://en.wikipedia.org/wiki/Chess_notation

////////////////////////////////////////////////////////////////////////////////
// Test strings
////////////////////////////////////////////////////////////////////////////////

#define PAWNS_LEN 3
static char *PAWNS_SMITH[] =
{"e2e4", "e7e5", "a7a6"};
static char *PAWNS_SAN[] =
{"e4", "e5", "a6"};

#define KNIGHTS_LEN 2
static char *KNIGHTS_SMITH[] =
{"g1f3", "b8c6"};
static char *KNIGHTS_SAN[] =
{"Nf3", "Nc6"};

#define CASTLING_LEN 2
static char *CASTLING_SMITH[] =
{"e1g1c", "e1c1C"};
static char *CASTLING_SAN[] =
{"O-O", "O-O-O"};

#define ALL_LEN 3 //length of the LEN array
static int LEN[ALL_LEN] = {PAWNS_LEN, KNIGHTS_LEN, CASTLING_LEN};
static char **ALL_SMITH[] = {PAWNS_SMITH, KNIGHTS_SMITH, CASTLING_SMITH};
static char **ALL_SAN[] = {PAWNS_SAN, KNIGHTS_SAN, CASTLING_SAN};

////////////////////////////////////////////////////////////////////////////////
// Tests
////////////////////////////////////////////////////////////////////////////////

static void test_strings_runner()
{
    int i, j;
    for (i = 0; i < ALL_LEN; i++)
    {
        char **smith_arr = ALL_SMITH[i];
        char **san_arr = ALL_SAN[i];
        for (j = 0; j < LEN[i]; j++)
        {
            char *smith_val = smith_arr[j];
            char *expected = san_arr[j];
            char san_calc[8];
            smith2san(smith_val, san_calc);
            printf("\nSmith: %s  SAN Expected: %s  Calculated: %s ", 
                   smith_val, expected, san_calc);
            
            // tmp disabled until we implement it
            //CU_ASSERT(memcmp(expected, san_calc, strlen(expected)) == 0);
            if (CU_get_number_of_failures() > 0)
                return; // exit immediately so we know which one failed
        }
    }
}

static void test_castling()
{
    char san[8];

    const char *smith1 = "e1g1c";//coord are for the king's movement
    const char *san_correct1 = "O-O";
    smith2san(smith1, san);
    CU_ASSERT(strncmp(san_correct1, san, strlen(san_correct1)) == 0);

    const char *smith2 = "e1c1C";//coord are for the king's movement
    const char *san_correct2 = "O-O-O";
    smith2san(smith2, san);
    CU_ASSERT(strncmp(san_correct2, san, strlen(san_correct2)) == 0);
    
    const char *smith3 = "e8g8c";//coord are for the king's movement
    const char *san_correct3 = "O-O";
    smith2san(smith3, san);
    CU_ASSERT(strncmp(san_correct3, san, strlen(san_correct3)) == 0);
    
    const char *smith4 = "e8c8C";//coord are for the king's movement
    const char *san_correct4 = "O-O-O";
    smith2san(smith4, san);
    CU_ASSERT(strncmp(san_correct4, san, strlen(san_correct4)) == 0);
}

////////////////////////////////////////////////////////////////////////////////
// tests collector function
////////////////////////////////////////////////////////////////////////////////

// add individual smith2san tests here
int addSmith2SanTests()
{
    // create suite and add it to registry
    CU_pSuite s1 = CU_add_suite("smith2san", NULL, NULL);
    if (NULL == s1) {
        CU_cleanup_registry();
        return CU_get_error();
    }
    
    // add tests to suite
    if ((NULL == CU_add_test(s1, "castling", test_castling))
        || (NULL == CU_add_test(s1, "string runner", test_strings_runner))
        )
    {
        CU_cleanup_registry();
        return CU_get_error();
    }
    
    return 0;
}
