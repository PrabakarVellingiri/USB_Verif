*STEP 1 RUN THE SINGLE TESTCASE

 

                .|csh [run_test_tvs.csh] -t [** test_case_name] -tool [questa |cadence ] -mode [*cmdp | guip] | -func_cov 

                example: ./run_test_tvs.csh -t tvs_ahb_single_test -cadence -cmdp


 

*STEP 2 RUN THE SINGLE TESTCASE WITH DUMP OPTION

 

                .|csh [run_test_tvs.csh] -t [** test_case_name] -tool [questa |cadence ] -mode [*cmdp | guip] | -func_cov | -dump_cadence

                example: ./run_test_tvs.csh -t tvs_ahb_single_test -cadence -cmdp -dump_cadence


*STEP 3 CLEANUP_DATABASE:
                  .|csh [run_test_tvs.csh|run_test_reg_tvs.csh] -cl|-clean

 


*STEP 4 RUN_TEST_TVS_HELP:
                  .|csh [run_test_tvs.csh|run_test_reg_tvs.csh] -h| -help


