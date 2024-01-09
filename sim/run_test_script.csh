#! /bin/csh -f 
#============================================================================
#  CONFIDENTIAL and Copyright (C) 2015 Test and Verification Solutions Ltd
#============================================================================
#  Contents:
#  run_test.csh 
#
#  Brief description:
#  This is the run_test.csh script, which is used to run a single test case 
#  either in the cadence or questa sim. For further details run,
#  ./run_test.csh -help
#
#  Known exceptions to rules:
#    
#============================================================================
#  Author        : 
#  Created on    : 
#  File Id       : $Id: run_test_tvs.csh
#============================================================================


setenv UVM_HOME /tools/questa10_6c/questasim/verilog_src/questa_uvm_pkg-1.2/src
setenv PROJECT_ROOT /Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif


set func_cov = 0
set tool = "-questa"
set dump_option = "-dump_questa"
set verbosity = "UVM_LOW"
set slave_mode = "dummy"
set cmd_option = "-cmdp"
set dump_cadence = ""
set dump_questa = ""
set user_seed = "random"
set top_module_name = "top"
set extdef = ""
set multims = 0
set tcl_opt = ""
set vcs_seed = 0

# =============================================================================
# Get args
# =============================================================================
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
  else if( "$1" == "-cmdp") then
    set cmd_option = "$1"
  else if( "$1" == "-seed") then
    shift 
    set vcs_seed = 1
    set user_seed = "$1"
  else if( "$1" == "-guip") then
    set cmd_option = "$1"
  else if( "$1" == "-func_cov") then
    set cmd_option = "$1"
    set func_cov   = 1
  else if( "$1" == "-dump_cadence") then
    set dump_option = "$1"
  else if( "$1" == "-dump_questa") then
    set dump_option = "$1"
  else if( "$1" == "-multims") then
    set multims = "$1"
  else if( "$1" == "-v") then
    shift
    set verbosity = "$1"
  else if( "$1" == "-d") then
    shift
    set slave_mode = "$1"
  else if( "$1" == "-h" || "$ uvm_componrnt parent = null1" == "-help") then
    goto SHOW_OPTIONS
  else if( "$1" == "-clean" || "$1" == "-cl") then
    goto CLEANUP_DATABASE
  else if( "$1" == "-extdef") then
    shift
    set extdef = "$extdef +define+$1"
  endif
  shift
end

#setenv UVM_HOME ../bin/uvm-1.1b/src
if ($?UVM_HOME == 0) then
echo "#####################################################"
echo  Exiting Simulation
echo  UVM_HOME Not Set
echo  Please set the UVM_HOME to your uvm src directory
echo "#####################################################"
endif


# =============================================================================
# Execute
# =============================================================================

if ("$tool" == "-cadence" ) then
  if ( -e ./INCA_libs) then
    rm -r ./INCA_libs
  endif
  if ("$dump_option" == "-dump_cadence") then
    set dump_cadence="+define+CADENCE_DUMP +access+rw"
  endif
  if ($func_cov == 1) then
    if !(-e ./coverage/reports) then
      mkdir -p ./coverage/reports
    endif
  endif
  if ! (-e ./logs) then
    mkdir ./logs
  endif 
endif

if("$tool" == "-questa" ) then
  if( -e ./work) then
    rm -rf ./work
  endif
  if("$dump_option" == "-dump_questa") then
    set dump_questa="add wave -r /*;"
    set tcl_opt="+define+QUESTA_DUMP"
  endif
  if($func_cov == 1) then
    if !(-e ./coverage/testcase_ucdb/reports) then
      mkdir -p ./coverage/testcase_ucdb/reports
      mkdir -p ./coverage/testcase_ucdb/report_html
    endif
    if ! (-e ./coverage/merged_ucdb/reports) then
      mkdir -p ./coverage/merged_ucdb/reports
      mkdir -p ./coverage/merged_ucdb/report_html
    endif
  endif

  endif
  if ! (-e ./logs) then
    mkdir ./logs
  endif
endif

set TOOL=`echo "$tool" | tr '[a-z]' '[A-Z]'`
echo "*********************************************************************************************"  
if ( "$cmd_option" == "-cmdp" ) then
  echo "******************   USER SELECTED $TOOL TOOL WITH COMMAND LINE MODE   ******************"  
else if ( "$cmd_option" == "-guip") then
  echo "******************   USER SELECTED $TOOL TOOL WITH INTERACTIVE MODE  *******************"  
else if ( "$cmd_option" == "-func_cov") then
  echo "******************   USER SELECTED TOOL IS $TOOL WITH FUNCTIONAL COVERAGE  ****************"  
endif
echo "*********************************************************************************************"  

echo "////////////////////////////////////////////////////" | tee -a $testcase_name.log
echo "//  (C) Test and Verification Solutions Ltd 2015  //" | tee -a $testcase_name.log
echo "////////////////////////////////////////////////////" | tee -a $testcase_name.log
echo " "
echo "###################################### " | tee -a $testcase_name.log 
echo "TESTCASE:" $testcase_name                | tee -a $testcase_name.log
echo "###################################### " | tee -a $testcase_name.log

if ("$tool" == "-cadence" ) then
  if("$cmd_option" == "-func_cov") then
    if("$multims" == "-multims") then
      irun -uvm -disable_sem2009 -TIMESCALE 1ns/1ps -v93 -messages -linedebug \
        -f comp_list.fl\
         +UVM_TESTNAME=$testcase_name \
        +UVM_VERBOSITY=$verbosity  \
        +define+CADENCE \
        $extdef \   
        -svseed $user_seed \
        +nccoverage+u  \
        +tcl+run.tcl \
        $dump_cadence | tee -a $testcase_name.log  
      iccr  iccr_single_test_cov.cmd

   else 
     irun -uvm -disable_sem2009 -TIMESCALE 1ns/1ps -v93 -messages -linedebug \
       -f comp_list.fl \
       +UVM_TESTNAME=$testcase_name \
       +UVM_VERBOSITY=$verbosity  \
       +define+CADENCE \
       $extdef \   
       -svseed $user_seed \
       +nccoverage+u  \
       +tcl+run.tcl \
       $dump_cadence | tee -a $testcase_name.log  
     iccr  iccr_single_test_cov.cmd

   endif

         
  else if("$cmd_option" == "-guip") then
    if("$multims" == "-multims") then

      irun -uvm -disable_sem2009 -TIMESCALE 1ns/1ps -v93 -messages -linedebug \
        -f comp_list.fl \
        +UVM_TESTNAME=$testcase_name \
        +UVM_VERBOSITY=$verbosity  \
        +define+CADENCE \
        $extdef \
        -svseed $user_seed \
        -gui -l $testcase_name.log
    else 
      irun -uvm -disable_sem2009 -TIMESCALE 1ns/1ps -v93 -messages -linedebug \
        -f comp_list.fl \
        +UVM_TESTNAME=$testcase_name \
        +UVM_VERBOSITY=$verbosity  \
        +define+CADENCE \
        $extdef \
        -svseed $user_seed \
        -gui -l $testcase_name.log
   endif

  else if("$cmd_option" == "-cmdp") then
    if("$multims" == "-multims") then
      irun -uvm -disable_sem2009 -TIMESCALE 1ns/1ps -v93 -messages -linedebug \
        -f comp_list.fl \
        +UVM_TESTNAME=$testcase_name \
        +UVM_VERBOSITY=$verbosity  \
        +define+CADENCE \
        $extdef \
        -svseed $user_seed \
        $dump_cadence | tee -a $testcase_name.log 
    else 
      irun -uvm -disable_sem2009 -timescale 1ns/1ps -v93 -messages -linedebug \
        -f comp_list.fl \
        +UVM_TESTNAME=$testcase_name \
        +UVM_VERBOSITY=$verbosity  \
        +define+CADENCE \
        $extdef \
        -svseed $user_seed \
        $dump_cadence | tee -a $testcase_name.log
    endif 
  else
    if("$multims" == "-multims") then
      irun -uvm -disable_sem2009 -TIMESCALE 1ns/1ps -v93 -messages -linedebug \
        -f comp_list.fl \
        +UVM_TESTNAME=$testcase_name \
        +UVM_VERBOSITY=$verbosity  \
        -svseed $user_seed \
        +define+CADENCE \ 
        $extdef \
        $dump_cadence | tee -a $testcase_name.log 
    else
      irun -uvm -disable_sem2009 -TIMESCALE 1ns/1ps -v93 -messages -linedebug \
        -f comp_list.fl \
        +UVM_TESTNAME=$testcase_name \
        +UVM_VERBOSITY=$verbosity  \
        -svseed $user_seed \
        +define+CADENCE \ 
        $extdef \
        $dump_cadence | tee -a $testcase_name.log
    endif 
  endif
endif # if ("$tool" == "-cadence" ) 
  if( "$tool" == "-vcs" ) then
    echo "vcs option" 
    vcs -sverilog  -ntb_opts uvm -debug_pp -debug_access -timescale=1ns/1ps +incdir+$UVM_HOME/etc/uvm-1.1 \
    -y $UVM_HOME/packages/sva +libext+.v +define+VCS \
    +incdir+$UVM_HOME/packages/sva \
    -f ../compile/comp_list.fl | tee -a $testcase_name.log
     if ( $vcs_seed == 1 ) then
       echo "********************************************" | tee -a $testcase_name.log 
       echo "************* USER SEED IS  $user_seed **************" | tee -a $testcase_name.log 
       echo "********************************************" | tee -a $testcase_name.log 
      ./simv +ntb_solver_debug=trace +ntb_solver_debug_filter=17 +ntb_random_seed=$user_seed +UVM_VERBOSITY=$verbosity  \
      +UVM_TESTNAME=$testcase_name | tee -a $testcase_name.log
     else
       echo "********************************************" | tee -a $testcase_name.log 
       echo "******* RANDOM SEED ************************" | tee -a $testcase_name.log 
       echo "********************************************" | tee -a $testcase_name.log 
       ./simv +ntb_solver_debug=trace +ntb_solver_debug_filter=17  +ntb_random_seed_automatic +UVM_VERBOSITY=$verbosity  \
        +UVM_TESTNAME=$testcase_name | tee -a $testcase_name.log
     endif
  endif
if ("$tool" == "-questa" ) then
  if("$cmd_option" == "-func_cov") then
     if("$multims" == "-multims") then
      vlib work
      vlog -sv -permissiive -novopt +define+QUESTA_SIM +define+UVM_NO_DPI +define+QUESTA \
        +incdir+$UVM_HOME/ $UVM_HOME/questa_uvm_pkg.sv $extdef \
          -f comp_list.fl | tee -a $testcase_name.log 
      vsim -c  -permissiive $top_module_name \
        +UVM_TESTNAME=$testcase_name \
        +UVM_VERBOSITY=$verbosity  \
	$tcl_opt \
        -novopt -coverage \
        -voptargs="+cover=bcfst" -cvg63 \
        -do "$dump_questa; coverage save -codeAll -cvg -onexit $testcase_name.ucdb; run -all; exit" \
          -sv_seed $user_seed \
        | tee -a $testcase_name.log 
      
      ##if ( -d ./coverage/testcase_ucdb/$testcase_name.ucdb ) then
      ##  rm -rf ./coverage/testcase_ucdb/$testcase_name.ucdb
      ##endif
      mv $testcase_name.ucdb ./coverage/testcase_ucdb
      vcover report -details ./coverage/testcase_ucdb/$testcase_name.ucdb > ./coverage/testcase_ucdb/reports/$testcase_name.rpt_det
      vcover report -cvg -details ./coverage/testcase_ucdb/$testcase_name.ucdb > ./coverage/testcase_ucdb/reports/$testcase_name.fun_det
      vcover report -html -htmldir ./coverage/testcase_ucdb/report_html ./coverage/testcase_ucdb/$testcase_name.ucdb
    else
      vlib work
      vlog -sv -permissive -novopt +define+QUESTA_SIM +define+UVM_NO_DPI +define+QUESTA \
        +incdir+$UVM_HOME $UVM_HOME/questa_uvm_pkg.sv $UVM_HOME/dpi/uvm_dpi.cc $extdef \
          -f comp_list.fl | tee -a $testcase_name.log 
      vsim -c -permissive $top_module_name \
        +UVM_TESTNAME=$testcase_name \
        +UVM_VERBOSITY=$verbosity  \
	$tcl_opt \
        -novopt -coverage \
        -voptargs="+cover=bcfst" -cvg63 \
        -do "$dump_questa; coverage save -codeAll -cvg -onexit $testcase_name.ucdb; run -all; exit" \
          -sv_seed $user_seed \
        | tee -a $testcase_name.log 
      
      ##if ( -d ./coverage/testcase_ucdb/$testcase_name.ucdb ) then
      ##  rm -rf ./coverage/testcase_ucdb/$testcase_name.ucdb
      ##endif
      mv $testcase_name.ucdb ./coverage/testcase_ucdb
      vcover report -details ./coverage/testcase_ucdb/$testcase_name.ucdb > ./coverage/testcase_ucdb/reports/$testcase_name.rpt_det
      vcover report -cvg -details ./coverage/testcase_ucdb/$testcase_name.ucdb > ./coverage/testcase_ucdb/reports/$testcase_name.fun_det
      vcover report -html -htmldir ./coverage/testcase_ucdb/report_html ./coverage/testcase_ucdb/$testcase_name.ucdb
    endif
  else if("$cmd_option" == "-guip") then
     if("$multims" == "-multims") then
       vlib work
       vlog -sv -permissive -novopt \
       +define+UVM_NO_DPI +define+QUESTA +incdir+$UVM_HOME $UVM_HOME/questa_uvm_pkg.sv $UVM_HOME/dpi/uvm_dpi.cc $extdef \
           -f comp_list.fl | tee $testcase_name.log
       vsim -novopt -gui $top_module_name \
           +UVM_TESTNAME=$testcase_name \
           +UVM_VERBOSITY=$verbosity  \
	   $tcl_opt \
           -do "add wave -r/*;log -r *;" \
           -sv_seed $user_seed \
 	    -l $testcase_name.log  
     else
       vlib work
       vlog -sv -permissive -novopt \
       +define+UVM_NO_DPI +define+QUESTA +incdir+$UVM_HOME $UVM_HOME/questa_uvm_pkg.sv $UVM_HOME/dpi/uvm_dpi.cc $extdef \
           -f comp_list.fl | tee $testcase_name.log
       vsim -novopt -gui $top_module_name \
           +UVM_TESTNAME=$testcase_name \
           +UVM_VERBOSITY=$verbosity  \
	   $tcl_opt \
           -do "add wave -r/*;log -r *;" \
           -sv_seed $user_seed \
 	    -l $testcase_name.log     
     endif   
  else if("$cmd_option" == "-cmdp") then
    if("$multims" == "-multims") then
   
      vlib work
      vlog -sv -permissive -novopt +define+UVM_NO_DPI +define+QUESTA +incdir+$UVM_HOME $UVM_HOME/questa_uvm_pkg.sv $UVM_HOME/dpi/uvm_dpi.cc $extdef \
          -f comp_list.fl | tee $testcase_name.log
      vsim -novopt -c -permissive  $top_module_name \
          +UVM_TESTNAME=$testcase_name \
          +UVM_VERBOSITY=$verbosity  \
	   $tcl_opt \
          -do "$dump_questa; run -a; quit -f" -sv_seed $user_seed | tee -a $testcase_name.log 
     else
      vlib work
     vlog -sv -permissive -novopt +define+UVM_NO_DPI +define+QUESTA +incdir+$UVM_HOME $UVM_HOME/questa_uvm_pkg.sv  $extdef \
          -f comp_list.fl | tee $testcase_name.log
      vsim -novopt -c -permissive  $top_module_name \
          +UVM_TESTNAME=$testcase_name \
          +UVM_VERBOSITY=$verbosity  \
	   $tcl_opt \
          -do "$dump_questa; run -a; quit -f" -sv_seed $user_seed | tee -a $testcase_name.log 

     endif 
  else
    if("$multims" == "-multims") then
      vlib work
      vlog -sv -permissive -novopt +define+QUESTA +define+QUESTA_SIM \
          -f comp_list.fl $extdef  | tee $testcase_name.log 
      vsim -novopt -debugDB -c -permissive $top_module_name \
          +UVM_TESTNAME=$testcase_name \
          +UVM_VERBOSITY=$verbosity  \
	   $tcl_opt \
          -sv_seed $user_seed \
	  -do "$dump_questa; run -a; quit -f" | tee -a $testcase_name.log
     else
        vlib work
      vlog -sv -permissive -novopt +define+QUESTA +define+QUESTA_SIM \
          -f comp_list.fl $extdef  | tee $testcase_name.log 
      vsim -novopt -c -permissive $top_module_name \
          +UVM_TESTNAME=$testcase_name \
          +UVM_VERBOSITY=$verbosity  \
	   $tcl_opt \
          -sv_seed $user_seed \
          -do "$dump_questa; run -a; quit -f" | tee -a $testcase_name.log

     endif
  endif 
endif # if ("$tool" == "-questa" )

if ! (-e ./logs/$testcase_name) then
  mkdir ./logs/$testcase_name
endif

  
  if ("$tool" == "-cadence" ) then
   if ("$cmd_option" == "-func_cov" | "$cmd_option" == "-cmdp") then
    if  (-d ./logs/$testcase_name/$testcase_name.trn) then
     rm -rf ./logs/$testcase_name/$testcase_name.trn
    endif

    if  (-d ./logs/$testcase_name/$testcase_name.dsn) then
     rm -rf ./logs/$testcase_name/$testcase_name.dsn
    endif 
   endif 
  endif 


  if ("$tool" == "-questa" ) then
   if ("$cmd_option" == "-func_cov" | "$cmd_option" == "-cmdp") then
    if  (-d ./logs/$testcase_name/$testcase_name.wlf) then
      rm -rf ./logs/$testcase_name/$testcase_name.wlf
    endif
   endif 
  endif

  cp $testcase_name.log ./run.log
  mv $testcase_name.log ./logs/$testcase_name/$testcase_name.log

  if ("$dump_option" == "-dump_cadence") then
   if ("$cmd_option" == "-func_cov" | "$cmd_option" == "-cmdp") then
    cp tvs_axi_dump.trn  ./logs/$testcase_name/$testcase_name.trn
    cp tvs_axi_dump.dsn  ./logs/$testcase_name/$testcase_name.dsn
   endif
  endif

  if ("$dump_option" == "-dump_questa") then
   if ("$cmd_option" == "-func_cov" | "$cmd_option" == "-cmdp") then
    cp *.wlf   ./logs/$testcase_name/$testcase_name.wlf
   endif
  endif

  if (`grep -c "\<Fatal\>" ./logs/$testcase_name/$testcase_name.log`) then
  set result_status  = "TEST FAILED DURING FATAL ERROR"
  set result = "TEST_FAILED"

  else if (`grep -c "\<Error\>" ./logs/$testcase_name/$testcase_name.log`) then
  set result_status  = "TEST FAILED DURING COMPILATION/SIMULATION"
  set result = "TEST_FAILED"

 # else if ( (`grep -c "irun: \*W" ./logs/$testcase_name/$testcase_name.log`) && (`grep -c "ncsim: \*E" ./logs/$testcase_name/$testcase_name.log`))then
 #   set result_status  = "TEST FAILED DUE TO ERROR && WARNNING"
 #   set result = "TEST_FAILED"
  else if (`grep -c "ncvlog: \*E" ./logs/$testcase_name/$testcase_name.log`) then
  set result_status  = "TEST FAILED DUE TO COMPILATION ERRORS"
  set result = "TEST_FAILED" 

 # else if (`grep -c "irun: \*W" ./logs/$testcase_name/$testcase_name.log`) then
 # set result_status  = "TEST FAILED DUE TO WARRNING"
 # set result = "TEST_FAILED"

  else if (`grep -c "ncsim: \*E" ./logs/$testcase_name/$testcase_name.log`) then
  set result_status  = "TEST FAILED DUE TO ERRORS"
  set result = "TEST_FAILED" 

  else if (`grep -c "ncelab: \*E" ./logs/$testcase_name/$testcase_name.log`) then
  set result_status  = "TEST FAILED DUE TO ELABORATION ERRORS"
  set result = "TEST_FAILED"

  else if (`grep -c "UVM_FATAL \@" ./logs/$testcase_name/$testcase_name.log`) then
  set result_status  = "TEST FAILED DUE TO UVM_FATAL"
  set result  = "TEST_FAILED"

  else if (`grep -c "UVM_ERROR \@" ./logs/$testcase_name/$testcase_name.log`) then
  set result_status  = "TEST FAILED DUE TO UVM_ERROR"
  set result = "TEST_FAILED"

  else if (`grep -c "UVM_WARNING \@" ./logs/$testcase_name/$testcase_name.log`) then
  set result_status  = "TEST FAILED DUE TO UVM_WARNING"
  set result = "TEST_FAILED"

  else
  set result_status  = " "
  set result = "TEST_PASSED"
  endif    


 echo " " | tee -a ./logs/$testcase_name/$testcase_name.log 
 echo " ################# TEST_RESULT ################# " | tee -a ./logs/$testcase_name/$testcase_name.log
 echo " TEST-NAME: $testcase_name " | tee -a ./logs/$testcase_name/$testcase_name.log

 if ($result == "TEST_FAILED") then
   echo " RESULT_STATUS: $result_status " | tee -a ./logs/$testcase_name/$testcase_name.log
   echo " RESULT: $result " | tee -a ./logs/$testcase_name/$testcase_name.log
 else
   echo " RESULT: $result " | tee -a ./logs/$testcase_name/$testcase_name.log
 endif
 echo " ############################################### " | tee -a ./logs/$testcase_name/$testcase_name.log


 exit(0)

 SHOW_OPTIONS:
 
 echo ""
     echo "Usage: run_test.csh [-t <testcase>  : User has to specify the respective test case ]"
     echo "                    [-cadence       : Enables Running in Cadence Simulator  ]"
     echo "                    [-questa        : Enables Running in Questa  Simulator  ]"
     echo "                    [-dump_cadence  : Enables Dumping for waveform viewing in Cadence Simulator  ]"
     echo "                    [-dump_questa   : Enables Dumping for waveform viewing in Questa  Simulator  ]"
     echo "                    [-func_cov      : Enable  Simulation in command Mode Prompt with Functional Coverage ]"
     echo "                    [-cmdp          : Enable  Simulation in Command Mode Prompt ]"
     echo "                    [-guip          : Enable  Simulation in GUI Mode Prompt ]"
     echo "                    [-v <verbosity> : Enables the Reporting Mechanism ]"
     echo "                         | UVM_NONE : Prints only the UVM_WARNING Informations - For Error Checking"
     echo "                         | UVM_LOW  : Prints only the UVM_WARNING and UVM_INFO Informations - For Error Checking"
     echo "                         | UVM_HIGH : Prints the UVM_INFO, UVM_WARNING, UVM_ERROR, UVM_FATAL Informations - For Debugging"
     echo ""
     echo "        run_test.csh -h[elp]"
     echo ""
 
exit(0)
 
 CLEANUP_DATABASE:
 
 echo ""
 echo "Cleaning up the Database.......";
 rm -rf  ./coverage ./logs ./work ./transcript ./INCA_libs ./simv.* ./csrc
 find . -name "*.log"  -exec rm -rf {} \; 
 find . -name "*.inf"  -exec rm -rf {} \; 
 find . -name "*.info" -exec rm -rf {} \; 
 find . -name "*.wlf"  -exec rm -rf {} \; 
 find . -name "*.vcd"  -exec rm -rf {} \; 
 find . -name "*.vpd"  -exec rm -rf {} \; 
 find . -name "*.ucdb" -exec rm -rf {} \; 
 find . -name "*.do"   -exec rm -rf {} \; 
 find . -name "*.vstf" -exec rm -rf {} \;
 find . -name "*.trn"  -exec rm -rf {} \;
 find . -name "*.dsn"  -exec rm -rf {} \;
 find . -name "*.key"  -exec rm -rf {} \;
 find . -name "*.history"  -exec rm -rf {} \;
 find . -name "*.sim*"  -exec rm -rf {} \;
 find . -name "*.sw*"  -exec rm -rf {} \;


#============================================================================

