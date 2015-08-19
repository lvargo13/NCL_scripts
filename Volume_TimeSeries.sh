#!/bin/bash


grep -h -m 1 'Total ice volume*' glc.log.* > Vol_TS_data.sh

sed -i 's/* Total ice volume (km^3)//' Vol_TS_data.sh   
