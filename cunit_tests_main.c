/*  cunit_tests_main.c
 *  CLUtils
 *  Created by Ettore Pasquini on 12/20/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#include <stdio.h>
#include <cl_debug.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "cl_smith2san_cunittest.h"
#include "cl_changeq_cunittest.h"

int main(int argc, const char * argv[]) 
{
    int err = 0;
    cl_debug_init("CLChessUtilsTests", "" /*"./CLChessUtils.log"*/);
    
    // init CUnit's registry
    if (CUE_SUCCESS != CU_initialize_registry())
        return CU_get_error();
    
    // add suites and tests to the global registry
    err = addSmith2SanTests();
    if (err)
        return err;
    err = cl_changeq_addtests();
    if (err)
        return err;
    
    // Run all tests using the CUnit Basic interface
    CU_basic_set_mode(CU_BRM_VERBOSE);
    err = CU_basic_run_tests();
    
    CU_cleanup_registry();
    return CU_get_error();
}
