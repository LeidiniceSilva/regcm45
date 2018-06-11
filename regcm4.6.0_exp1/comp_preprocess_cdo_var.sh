#!/bin/bash

#__author__      = 'Leidinice Silva'
#__email__       = 'leidinicesilva@gmail.br'
#__date__        = '05/26/18'
#__description__ = 'Preprocessing the RegCM4.6.0 model data with CDO'
 

echo
echo "--------------- INIT PREPROCESSING MODEL ----------------"


cd /vol3/nice/output

echo 
echo "1. Select variable (PR and T2M)"

for YEAR in `seq 2001 2005`; do
    for MON in `seq -w 01 12`; do

        echo "Data: ${YEAR}${MON} - Variable: Precipitation"
        cdo selname,pr amz_neb_STS.${YEAR}${MON}0100.nc pre_amz_neb_regcm_exp1_${YEAR}${MON}0100.nc

        echo "Data: ${YEAR}${MON} - Variable: Temperature 2 m"
        cdo selname,tas amz_neb_SRF.${YEAR}${MON}0100.nc t2m_amz_neb_regcm_exp1_${YEAR}${MON}0100.nc

    done
done	


echo 
echo "2. Concatenate data (2001-2005)"

cdo cat pre_amz_neb_regcm_exp1_*0100.nc pre_flux_amz_neb_regcm_exp1_2001-2005.nc
cdo cat t2m_amz_neb_regcm_exp1_*0100.nc t2m_K_amz_neb_regcm_exp1_2001-2005.nc


echo 
echo "3. Unit convention (mm and celsius)"

cdo mulc,86400 pre_flux_amz_neb_regcm_exp1_2001-2005.nc pre_amz_neb_regcm_exp1_2001-2005.nc
cdo addc,-273.15 t2m_K_amz_neb_regcm_exp1_2001-2005.nc t2m_amz_neb_regcm_exp1_2001-2005.nc

echo 
echo "4. Grid inperpolation (obs ---> model)"

cdo remapbil,pre_cru_ts4.01_observation_1979-2010.nc pre_amz_neb_regcm_exp1_2001-2005.nc pre_amz_neb_regcm_exp1_2001-2005_interp.nc
cdo remapbil,tmp_cru_ts4.01_observation_1979-2010.nc t2m_amz_neb_regcm_exp1_2001-2005.nc t2m_amz_neb_regcm_exp1_2001-2005_interp.nc


echo 
echo "5. Creating new areas (A1, A2, A3, A4, A5, A6, A7, A8)"


for VAR in pre t2m; do

    echo
    echo "Variable: ${VAR}"
	
    cdo sellonlatbox,-63,-55,-9,-1 ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A1.nc
    cdo sellonlatbox,-52.5,-45.5,-3.55,3.5 ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A2.nc
    cdo sellonlatbox,-75,-71,-15,-11 ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A3.nc
    cdo sellonlatbox,-78,-72,0,8 ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A4.nc
    cdo sellonlatbox,-73,-65,-10,-3 ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A5.nc
    cdo sellonlatbox,-48,-38,-5,-1 ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A6.nc
    cdo sellonlatbox,-48,-38,-11,-5 ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A7.nc
    cdo sellonlatbox,-38,-34,-11,-5 ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A8.nc

    echo 
    echo "6. Variable: ${VAR} - Statistics index (mean and sum)"

    cdo monsum ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_monsum.nc
    cdo monmean ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_monmean.nc
    cdo ymonmean ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_monmean.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_clim.nc
    cdo -b 32 -ymonsub ${VAR}_*_interp_monmean.nc -ymonmean ${VAR}_*_interp_monmean.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_monanom.nc

    echo 
    echo "7. Variable: ${VAR} - Grads NC prepare (./GrADSNcPrepare)"
   
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A1.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A2.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A3.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A4.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A5.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A6.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A7.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_A8.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_monsum.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_monmean.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_clim.nc
    ./GrADSNcPrepare ${VAR}_amz_neb_regcm_exp1_2001-2005_interp_monanom.nc

done


echo 
echo "8. Deleted files"

rm pre_amz_neb_regcm_exp1_*0100.nc
rm t2m_amz_neb_regcm_exp1_*0100.nc
rm pre_flux_amz_neb_regcm_exp1_2001-2005.nc
rm t2m_K_amz_neb_regcm_exp1_2001-2005.nc


echo
echo "--------------- THE END PREPROCESSING MODEL ----------------"

