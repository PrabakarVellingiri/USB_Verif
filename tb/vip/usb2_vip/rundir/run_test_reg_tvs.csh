#! /bin/csh -f
#============================================================================
#  CONFIDENTIAL and Copyright (C) 2015 Test and Verification Solutions Ltd
#============================================================================
#  Contents:
#  tvs_run_reg_script.csh 
#
#  Brief description:
#  This is the tvs_run_reg_script.csh script, which is used to run test case 
#  in the Aldec riviera sim. For further details run,
#  ./tvs_run_reg_script.csh -help
#
#  Known exceptions to rules:
#    
#============================================================================
#  Author        : [TVS]
#  Created on    : 
#  File Id       : $Id: run_test_reg_tvs.csh
#============================================================================

set tcl_opt = ""
set func_cover = 0
set dump_option = ""
set cmd_opt = ""
set verbosity = "UVM_MEDIUM"
set cmdp_opt = ""
set gui_opt = ""
set cvg_option = " -cvgperinstance"
set ET = "Error_Test.inf"
set PT = "Pass_Test.inf"
set pass_count = 0
set fail_count = 0
set testcase_count = 0
set compile=0
set func_opt = ""
set top_module_name = "tvs_axi_tb_top"
set tool = "-questa" 
set extdef = "" 
set testcase_name =""

while ($#argv )
  if( "$1" == "-t") then
    shift
   set testcase_name = "$1"
  else if( "$1" == "-cadence") then
    set tool = "$1"
  else if( "$1" == "-vcs") then
    set tool = "$1"
  else if( "$1" == "-questa") then
    set tool = "$1"
  else if( "$1" == "-dump_questa") then
    set dump_option = "$1"
  else if( "$1" == "-guip") then
    set cmd_opt = "$1"
  else if( "$1" == "-func_cov") then
    set func_cover = 1
  else if( "$1" == "-cmdp") then
    set cmd_opt = "$1"
  else if("$1" == "-h" || "$1" == "-help") then
    goto SHOW_OPTIONS
  else if( "$1" == "-clean" || "$1" == "-cl") then
   goto CLEANUP_DATABASE
  else if( "$1" == "-extdef") then
    shift
    set extdef = "$extdef +define+$1"
  endif
  shift
end 
setenv UVM_HOME ../bin/uvm-1.1b/src
if ($?UVM_HOME == 0) then
echo "#####################################################"
echo  Exiting Simulation
echo  UVM_HOME Not Set
echo  Please set the UVM_HOME to your uvm src directory
echo "#####################################################"
endif

if("$tool" == "-cadence") then
  if !(-e ./coverage/reports) then
    mkdir -p ./coverage/reports
  endif
endif
if("$tool" == "-questa") then
  if("$cmd_opt" == "-cmdp") then
    set cmdp_opt = "-c"
    set tcl_opt = "do coverage.do;run -all;"
  endif

  if ("$dump_option" == "-dump_questa") then
    set dump_option="log -r *"
  endif

  if("$cmd_opt" == "-gui") then
    set tcl_opt = "do ./wave.do"
  endif

  if("$func_cover" == 1) then
    if !(-e ./coverage/testcase_ucdb/reports) then
      mkdir -p ./coverage/testcase_ucdb/reports
      mkdir -p ./coverage/testcase_ucdb/report_html
    endif
    
    if ! (-e ./coverage/merged_ucdb/reports) then
      mkdir -p ./coverage/merged_ucdb/reports
      mkdir -p ./coverage/merged_ucdb/report_html
    endif

    if("$cmd_opt" == "-cmdp") then
      set func_opt = "-c"
    else if("$cmd_opt" == "-gui") then
      set func_opt = ""
    endif
    set cmdp_opt = "$func_opt -coverage -voptargs="+cover=bcfst" -cvg63"
    set tcl_opt = "coverage save -codeAll -cvg -onexit $testcase_name.ucdb; run -all; exit;"
  endif

endif

set FILENAME = test_list

if(-f $ET ) then
 rm -rf $ET 
endif

if ! (-e ./logs) then
   mkdir ./logs
endif 

if(-f $PT ) then
 rm -rf $PT 
endif
if("$tool" == "-questa") then
  vlib work
  vlog -sv -permissive -novopt +define+QUESTA_SIM +define+UVM_NO_DPI +define+QUESTA +incdir+$UVM_HOME \
                   $UVM_HOME/uvm_pkg.sv \
                   -f ../compile/tb_comp_list.fl | tee -a ./logs/$testcase_name.log
endif
if("$tool" == "-vcs") then
   echo "VCS option compile"
   vcs -sverilog -ntb_opts uvm -debug_pp -debug_access -timescale=1ns/1ps +incdir+$UVM_HOME/etc/uvm-1.1 \
   -y $UVM_HOME/packages/sva +libext+.v +define+VCS \
   +incdir+$UVM_HOME/packages/sva \
   -f ../compile/tb_comp_list.fl | tee -a ./logs/$testcase_name.log 
endif
foreach testcase_name ( `cat $FILENAME` )
  
  echo " "
  echo "###################################### "
  echo "TESTCASE:  $testcase_name.sv " 
  echo "###################################### "
  set testcase_count = `expr $testcase_count + 1`

  echo $tcl_opt
  echo $cmdp_opt
  if("$func_cover" == 1 && "$tool" == "-questa") then
    set cmdp_opt = -c
    set tcl_opt = "do coverage.do;coverage save -codeAll -cvg -onexit $testcase_name.ucdb; run -all; exit;"
  endif
  
  if("$tool" == "-vcs") then
     echo "VCS option simulation"
     #vcs -sverilog -ntb_opts uvm -debug_pp -debug_access -timescale=1ns/1ps +incdir+$VCS_HOME/etc/uvm-1.1 \
     #-y $VCS_HOME/packages/sva +libext+.v +define+VCS \
     #+incdir+$VCS_HOME/packages/sva \
     #-f ../compile/tb_comp_list.fl | tee -a ./logs/$testcase_name.log 
     ./simv +UVM_VERBOSITY=$verbosity  \
     +UVM_TESTNAME=$testcase_name | tee -a ./logs/$testcase_name.log
  endif
  
  if("$tool" == "-cadence") then
    irun -uvm -profile -disable_sem2009 -TIMESCALE 1ns/1ps -v93 -messages -linedebug -licqueue \
    -f ../compile/tb_comp_list.fl \
    +UVM_TESTNAME=$testcase_name \
    +UVM_VERBOSITY=$verbosity  \
    +define+CADENCE \
    +nccoverage+u \
    $extdef \
    -svseed random \
    | tee -a ./logs/$testcase_name.log

#    irun -TIMESCALE 1ps/1ps -v93 -messages -linedebug -licqueue +define+CADENCE -svseed random\
#      -f ../compile/tb_comp_list.fl \
#      +UVM_TESTNAME=$testcase_name \
#      +UVM_VERBOSITY=$verbosity  \
#      +nccoverage+u \
#      +tcl+run.tcl \
#      | tee -a ./logs/$testcase_name.log
  endif
  if("$tool" == "-questa") then
    vsim -c -permissive $top_module_name \
      +UVM_TESTNAME=$testcase_name \
      +UVM_VERBOSITY=$verbosity  \
      -novopt -coverage \
      -voptargs="+cover=bcfst" -cvg63 \
      -do "coverage save -codeAll -cvg -onexit $testcase_name.ucdb; run -all; exit" \
      | tee -a ./logs/$testcase_name.log

    mv $testcase_name.ucdb ./coverage/testcase_ucdb
 endif
 if ("$tool" == "-questa" ) then
   if("$func_cover" == 1) then
     vcover merge ./coverage/merged_ucdb/merged_ucdb.ucdb  ./coverage/testcase_ucdb/*.ucdb
     vcover report -details ./coverage/merged_ucdb/merged_ucdb.ucdb > ./coverage/merged_ucdb/reports/merged_ucdb.rpt
     vcover report -html -htmldir ./coverage/merged_ucdb/report_html -verbose -threshL 50 -threshH 90 ./coverage/merged_ucdb/merged_ucdb.ucdb
   endif
 endif
   if ! ( -e ./logs/$testcase_name ) then
     mkdir -p ./logs/$testcase_name
   endif
   mv ./logs/$testcase_name.log ./logs/$testcase_name/$testcase_name.log
   cp -rf simv.vdb ./logs/$testcase_name/$testcase_name.vdb
  if (`grep -c "\<Fatal\>" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "Fatal:TEST FAILED DURING COMPILATION/SIMULATION"
    set result = "TEST_FAILED"
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif
  else if (`grep -c "\<FATAL\>" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "FATAL:TEST FAILED DURING COMPILATION/SIMULATION"
    set result = "TEST_FAILED"
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif
  else if (`grep -c "UVM_FATAL \@" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "UVM_FATAL:TEST FAILED DURING COMPILATION/SIMULATION"
    set result = "TEST_FAILED"
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif
  else if (`grep -c "\<ERROR\>" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "ERROR:TEST FAILED DURING COMPILATION/SIMULATION"
    set result = "TEST_FAILED"
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif
  else if (`grep -c "UVM_ERROR \@" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "UVM_ERROR:TEST FAILED DURING COMPILATION/SIMULATION"
    set result = "TEST_FAILED"
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif
  else if (`grep -c "\<Error\>" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "Error:TEST FAILED DURING COMPILATION/SIMULATION"
    set result = "TEST_FAILED"
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif
  else if (`grep -c "\<WARNING\>" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "TEST FAILED DUE TO WARNING"
    set result = "TEST_FAILED"
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif
  else if (`grep -c "\<warning\>" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "TEST FAILED DUE TO WARNING"
    set result = "TEST_FAILED"
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif
  else if (`grep -c "\<MISMATCH\>" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "TEST FOUND WITH MISMATCH"
    set result = "TEST_FAILED"
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif
  else if (`grep -c "ncvlog: \*E" ./logs/$testcase_name/$testcase_name.log`) then
    set result_status  = "TEST FAILED DUE TO COMPILATION ERRORS"
    set result = "TEST_FAILED" 
    if(-f $ET ) then
      echo $testcase_name >>$ET
    else
      echo $testcase_name >$ET
    endif 
    else if (`grep -c "ncsim: \*E" ./logs/$testcase_name/$testcase_name.log`) then
      set result_status  = "TEST FAILED DUE TO ERRORS"
      set result = "TEST_FAILED" 
      if(-f $ET ) then
        echo $testcase_name >>$ET
      else
        echo $testcase_name >$ET
      endif 

    else if (`grep -c "ncelab: \*E" ./logs/$testcase_name/$testcase_name.log`) then
      set result_status  = "TEST FAILED DUE TO ELABORATION ERRORS"
      set result = "TEST_FAILED"
      if(-f $ET ) then
        echo $testcase_name >>$ET
      else
        echo $testcase_name >$ET
      endif 

  else
    set result_status  = " "
    set result = "TEST_PASSED"
    if(-f $PT ) then
      echo $testcase_name >>$PT
    else
      echo $testcase_name >$PT
    endif
  endif    
 
    echo " " | tee -a ./logs/$testcase_name.log 
    echo " =============================================== " | tee -a ./logs/$testcase_name.log 
    echo " ----------------- TEST_RESULT------------------ " | tee -a ./logs/$testcase_name.log 
    echo " =============================================== " | tee -a ./logs/$testcase_name.log 
    echo " TEST-NAME: $testcase_name " | tee -a ./logs/$testcase_name.log
    if ($result == "TEST_FAILED") then
      echo " RESULT_STATUS: $result_status " | tee -a ./logs/$testcase_name.log
      echo " RESULT: $result " | tee -a ./logs/$testcase_name.log
    else
      echo " RESULT: $result " | tee -a ./logs/$testcase_name.log
    endif
    echo " ############################################### " | tee -a ./logs/$testcase_name.log
    
    
    if ($result == "TEST_PASSED") then
    	set pass_count = `expr $pass_count + 1`
    else if ($result == "TEST_FAILED") then
    	set fail_count = `expr $fail_count + 1`
    endif
 
    echo " "
    echo "###################################### "
    echo "TESTCASE ENDS: $testcase_name.sv  " 
    echo "###################################### "
      
end ## foreach end

 if("$tool" == "-cadence")  then
   if("$func_cover" == 1) then
     iccr iccr_regression_cov.cmd
   endif
 endif
  if( "$tool" == "-vcs" ) then
    if( "$func_cover" == 1 ) then
      urg -dir logs/*_test/*.vdb
    endif
  endif
  echo " " | tee -a ./regression_statistics.info
  echo " =============================================== " | tee -a ./regression_statistics.info
  echo " 	      REGRESSION STATISTICS  		 " | tee -a ./regression_statistics.info
  echo " =============================================== " | tee -a ./regression_statistics.info
  echo " TESTCASES RUN    :" $testcase_count | tee -a ./regression_statistics.info
  echo " TESTCASES PASSED :" $pass_count | tee -a ./regression_statistics.info
  echo " TESTCASES FAILED :" $fail_count | tee -a ./regression_statistics.info
  echo " =============================================== " | tee -a ./regression_statistics.info
  
  echo " =============================================== " | tee -a ./regression_statistics.info
  echo " 		    PASS TEST 			 " | tee -a ./regression_statistics.info
  echo " =============================================== " | tee -a ./regression_statistics.info
  if (-f $PT) then
  cat $PT 	     | tee -a ./regression_statistics.info	
  else 
  echo " No Test Passed in Regression" | tee -a ./regression_statistics.info
  endif
  echo " =============================================== " | tee -a ./regression_statistics.info

  echo " =============================================== " | tee -a ./regression_statistics.info
  echo " 		    FAIL TEST 			 " | tee -a ./regression_statistics.info
  echo " =============================================== " | tee -a ./regression_statistics.info
  if (-f $ET) then
  cat $ET 	     | tee -a ./regression_statistics.info	
  else
  echo " No Test Failed in Regression" | tee -a ./regression_statistics.info
  endif
  echo " =============================================== " | tee -a ./regression_statistics.info


exit(0)

SHOW_OPTIONS:

echo ""
  echo "Usage: tvs_run_script.csh [-t <testcase>         : User has to specify the respective test case ]"
  echo "                          [-cadence              : Enables Running in Cadence Simulator  ]"
  echo "                          [-questa               : Enables Running in Questa  Simulator  ]"
  echo "                          [-dump_questa          : Enables Dumping for waveform viewing in Questa  Simulator  ]"
  echo "                          [-func_cov             : Enable  Simulation in command Mode Prompt with Functional Coverage ]"
  echo "                          [-cmdp                 : Enable  Simulation in Command Mode Prompt ]"
  echo "                          [-guip                 : Enable  Simulation in GUI Mode Prompt ]"
  echo ""
  echo "        run_test.csh -h[elp]"
  echo ""

exit(0)

CLEANUP_DATABASE:

echo ""
echo "Cleaning up the Database.......";
rm -rf  ./work ./transcript ./cov_work ./coverage ./simvision ./INCA_libs ncsim.err
rm -rf  ./logs 
find . -name "*.log"  -exec rm -rf {} \; 
find . -name "*.html"  -exec rm -rf {} \;
find . -name "*.cfg"  -exec rm -rf {} \; 
find . -name "*.so"   -exec rm -rf {} \; 
find . -name "*.awc"  -exec rm -rf {} \; 
find . -name "*.asdb" -exec rm -rf {} \; 
find . -name "*.inf" -exec rm -rf {} \; 
find . -name "*.prof" -exec rm -rf {} \; 
find . -name "*.history" -exec rm -rf {} \; 
find . -name "*.sim*" -exec rm -rf {} \; 
find . -name "*.sw*" -exec rm -rf {} \; 

exit(0)
#============================================================================
