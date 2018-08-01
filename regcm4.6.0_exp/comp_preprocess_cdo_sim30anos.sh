#!/bin/bash

#__author__      = 'Leidinice Silva'
#__email__       = 'leidinicesilva@gmail.br'
#__date__        = '07/26/18'
#__description__ = 'Preprocessing the RegCM4.6.0 model data with CDO'
 

echo
echo "--------------- INIT PREPROCESSING MODEL ----------------"

SIM='SIM30ANOS1'
VAR='SRF'
DIR='/vol3/claudio/${SIM}/${VAR}'

echo
cd ${DIR}
echo ${DIR}


echo 
echo "1. Select variable (PR and T2M)"

for YEAR in `seq 1981 2010`; do
    for MON in `seq -w 01 12`; do

        echo "Data: ${YEAR}${MON}"
        cdo selname,tas SRF.${YEAR}${MON}.nc t2m_${YEAR}_${MON}.nc

    done
done	


echo 
echo "2. Concatenate data (1981-2010)"

cdo cat t2m_*.nc t2m_mon_1981_2010.nc


echo 
echo "3. Deleted files"

rm  t2m_*.nc


echo
echo "--------------- THE END PREPROCESSING MODEL ----------------"
