#!/bin/bash

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
	
# one option/variable: | xargs grep -l 'variable_string' \
# multiple options/variable: | xargs grep -l 'which_ho_babc=4\|which_ho_babc=5' \

# Define colors 
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)

egrep -l 'which_ho_babc=4|which_ho_babc=5' *.sh \
| xargs grep -l 'which_ho_approx=2\|which_ho_approx=3\|which_ho_approx=4' \
| xargs grep -l 'which_ho_gradient=0\|which_ho_gradient=1' \
| xargs grep -l 'which_ho_gradient_margin=0\|which_ho_gradient_margin=1\|which_ho_gradient_margin=2' \
| xargs grep -l 'which_ho_precond=1\|which_ho_precond=2' \
| xargs grep -l 'greenland_4km.glissade.10kyr.beta6.SSacab_c140919.nc\|greenland_4km_2015_03_12.mcb.nofloat.nc\|greenland_4km_2015_03_12.mcb.nofloat.4310a.beta7.nc' \
| xargs grep -l 'evolution=3\|evolution=4' \
| xargs grep -l 'which_ho_assemble_beta=0\|which_ho_assemble_beta=1' > list_CISMTest_files.sh


 # Remove this file name from list_CISMTest_files.sh 
 sed -i '/find_CISMTest_files.sh/d' list_CISMTest_files.sh 
 
 # Extract only # from list_CISMTest_files.sh
 sed -i s/runscript_CISM_config_test_// list_CISMTest_files.sh
 sed -i s/.sh// list_CISMTest_files.sh


while read File_num; do

 if [ -d /glade/u/home/lvargo/scratch/archive/IG_CISM2_test_$File_num ]; then 
   printf "%40s\n" "${green}$File_num ran ${normal}" 
 fi

 if [ ! -f /glade/u/home/lvargo/scratch/IG_CISM2_test_$File_num/bld/cesm.exe ]; then 
   printf "%40s\n" "${red}$File_num did not build ${normal}" 
 fi

 if [ ! -f /glade/u/home/lvargo/scratch/IG_CISM2_test_$File_num/run/*clm2.h0.*-12.nc ] && [ -f /glade/u/home/lvargo/scratch/IG_CISM2_test_$File_num/bld/cesm.exe ]; then 
   printf "%40s\n" "${red}$File_num failed during initialization ${normal}" 
 fi 
 
 if [ ! -d /glade/u/home/lvargo/scratch/archive/IG_CISM2_test_$File_num ] && [ -f /glade/u/home/lvargo/scratch/IG_CISM2_test_$File_num/run/*clm2.h0.*-12.nc ]; then 
   printf "%40s\n" "${red}$File_num failed during run ${normal}" 
 fi
 
done <list_CISMTest_files.sh		
