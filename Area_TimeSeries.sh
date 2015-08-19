#!/bin/bash


grep -h -m 1 'Total ice area*' glc.log.* > Area_TS_data.sh

sed -i 's/* Total ice area (km^2)//' Area_TS_data.sh   

