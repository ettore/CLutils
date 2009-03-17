#include "cl_debug.h"
#include "tests_cutils_carbon.h"
#include "tests_cutils_bsd.h"

const char *kOurProductName = "cutils_tests";

// -----------------------------------------------------------------------------
int main(int argc, const char * argv[])
{
#pragma unused(argc, argv)

    cutils_carbon_run_all_tests();
    cutils_bsd_run_all_tests();
    
    LOG("==== %s completed ALL tests successfully. ====", kOurProductName);
}
