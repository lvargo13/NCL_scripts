#!/bin/bash

# Area
grep -h -m 1 'Total ice area*' glc.log.* > Area_TS_data.sh

sed -i 's/* Total ice area (km^2)//' Area_TS_data.sh   


# Volume 
grep -h -m 1 'Total ice volume*' glc.log.* > Vol_TS_data.sh

sed -i 's/* Total ice volume (km^3)//' Vol_TS_data.sh   
