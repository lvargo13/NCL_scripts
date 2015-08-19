#!/bin/bash

# INSTRUCTIONS FOR RUNNING THE SCRIPT: 
# Configuration parameter combinations can be narrowed down within the 'grep command string' (lines 37-44)
# To narrow down configurations, either 1) remove the string of the parameter you do not want to search or 2) set both strings to the parameter you do want to search
# For example, to only see configurations in which evolution=3, the line would either be:
# | xargs grep -l 'evolution=3' \  
# or 
# | xargs grep -l 'evolution=3\|evolution=3' \
#
# The first line of the grep string should follow this style: egrep -l 'parameter1=a|parameter1=b' "$RunPath"/runscript_CISM_config_test_*.sh \
# The following lines should follow this stlye: | xargs grep -l 'parameter2=a\|parameter2=b' \

# PARAMETER OPTIONS: 
# which_ho_babc options: 4 5 
# which_ho_approx options: 2 3 4
# which_ho_gradient options: 0 1 
# which_ho_gradient_margin options: 0 1 2
# which_ho_precond options: 1 2
# input_file options: /glade/p/cesm/cseg/inputdata/glc/cism/Greenland/glissade/init/greenland_4km.glissade.10kyr.beta6.SSacab_c140919.nc
#	              /glade/u/home/sprice/greenland_4km_ICs/nosliding/greenland_4km_2015_03_12.mcb.nofloat.nc
#		      /glade/u/home/sprice/greenland_4km_ICs/sliding/greenland_4km_2015_03_12.mcb.nofloat.4310a.beta7.nc
# evolution options: 3 4
# which_ho_assemble_beta options: 0 1



# Allow script to be run from anywhere
RunPath=/glade/u/home/lvargo/CISM_tests/IG_test_ensemble_setup

# Remove old list_CISMTest_files.sh if it exists 
if [ -f list_CISMTest_files.sh ]; then
  rm list_CISMTest_files.sh
fi

# Remove old list_CISMTest_files.sh if it exists 
if [ -f failed_runs.sh ]; then
  rm failed_runs.sh
fi

# grep command string  
 egrep -l 'which_ho_babc=4|which_ho_babc=4' "$RunPath"/runscript_CISM_config_test_*.sh \
| xargs grep -l 'which_ho_approx=2\|which_ho_approx=3\|which_ho_approx=4' \
| xargs grep -l 'which_ho_gradient=0\|which_ho_gradient=1' \
| xargs grep -l 'which_ho_gradient_margin=0\|which_ho_gradient_margin=1\|which_ho_gradient_margin=2' \
| xargs grep -l 'which_ho_precond=1\|which_ho_precond=2' \
| xargs grep -l 'greenland_4km.glissade.10kyr.beta6.SSacab_c140919.nc\|greenland_4km_2015_03_12.mcb.nofloat.nc\|greenland_4km_2015_03_12.mcb.nofloat.4310a.beta7.nc' \
| xargs grep -l 'evolution=3\|evolution=4' \
| xargs grep -l 'which_ho_assemble_beta=0\|which_ho_assemble_beta=1' > list_CISMTest_files.sh
 
 # Extract only the configuration # from list_CISMTest_files.sh
 sed -i s?"$RunPath"/runscript_CISM_config_test_?? list_CISMTest_files.sh
 sed -i s/.sh// list_CISMTest_files.sh

 # List only tests that failed 
while read File_num; do

 if [ ! -f /glade/u/home/lvargo/scratch/IG_CISM2_test_$File_num/run/*clm2.h0.*-12.nc ] && [ -f /glade/u/home/lvargo/scratch/IG_CISM2_test_$File_num/bld/cesm.exe ]; then 
   printf "$File_num\n" $File_num >> failed_runs.sh
 fi 
 
 if [ ! -d /glade/u/home/lvargo/scratch/archive/IG_CISM2_test_$File_num ] && [ -f /glade/u/home/lvargo/scratch/IG_CISM2_test_$File_num/run/*clm2.h0.*-12.nc ]; then 
   printf "$File_num\n" $File_num >> failed_runs.sh
 fi
 
done <list_CISMTest_files.sh


# Print files associated with each error message
  printf "%s\n" "**ERROR- departure points out of bounds:"
while read File_num; do
  
  grep -l 'departure points out of bounds' ~lvargo/scratch/IG_CISM2_test_$File_num/run/cesm.log*
  
done <failed_runs.sh		

  printf "%s\n" "**ERROR- GLISSADE SOLUTION HAS NOT CONVERGED:"
while read File_num; do
  
  grep -l 'GLISSADE SOLUTION HAS NOT CONVERGED' ~lvargo/scratch/IG_CISM2_test_$File_num/run/cesm.log*
  
done <failed_runs.sh
 
