#!/bin/bash 
## batch code

# # Specify subject identifier
subj='S01s1'
root_dir='/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023'
raw_dir=$root_dir/raw/$subj
output_dir=$root_dir/analysis/$subj
mkdir $output_dir

n_dummys=3
runs=(`count -digits 2 1 2`)

cd $output_dir




3dAFNItoNIFTI -prefix VASO01  VASO01+orig. -overwrite
3dAFNItoNIFTI -prefix BOLD01  BOLD01+orig. -overwrite
3dAFNItoNIFTI -prefix VASO02  VASO02+orig. -overwrite
3dAFNItoNIFTI -prefix BOLD02  BOLD02+orig. -overwrite


##################### EPI & reverse sort #####################
for label in BOLD VASO ; do    
    for run in ${runs[@]} ; do
        #Remove non-steady_state of first time stepts,(3 dummy TReff, 6 volumes)
        NumVol=`3dinfo -nv ${label}${run}.nii`   #get number of points in time from header information
        3dTcat -prefix ${label}${run}.nii ${label}${run}.nii'['$n_dummys'..'`expr $NumVol - 1`']'  -overwrite   #cat dummy TRs
    done
done
wait

##################### Despike #####################
for label in BOLD VASO ; do    
    for run in ${runs[@]} ; do
        3dDespike -NEW -localedit -nomask -prefix  ${label}${run}.despike.nii  ${label}${run}.nii -overwrite
    done
done
wait


##################### motion correction #####################
## ==================== volreg ==============================
## 6 parameters rigid body linear transform

for label in BOLD VASO ; do    
    3dbucket -prefix template.volreg_${label}.nii -overwrite \
         ${label}02.despike.nii'[0]'
done
wait


for label in BOLD VASO ; do
    for run in ${runs[@]} ; do
        3dvolreg -verbose -zpad 2 -base template.volreg_${label}.nii  \
            -prefix rm.volreg.${label}${run}.nii -overwrite \
            -1Dfile dfile.${label}${run}.1D \
            -1Dmatrix_save mat.${label}${run}.vr.aff12.1D \
                ${label}${run}.despike.nii
    done
done
wait


for label in BOLD VASO ; do    
    for run in ${runs[@]} ; do
        cat_matvec -ONELINE \
            mat.${label}${run}.vr.aff12.1D > mat.${label}${run}.warp.aff12.1D

        # Apply concatenated transform, and resample only once
        3dAllineate -base template.volreg_${label}.nii \
                -input ${label}${run}.despike.nii \
                -1Dmatrix_apply mat.${label}${run}.warp.aff12.1D \
                -prefix rm.nomask.${label}${run}.volreg.nii -overwrite 
    done
done
wait
    

## ==================== mask =========================
# Create data extents mask of all runs
# This is a mask of voxels that have valid data after rotation at every TR
for label in BOLD VASO ; do    
    for run in ${runs[@]} ; do
        # Create a 3D+t all-1 dataset to mask the extents of the warp
        3dcalc -a ${label}${run}.despike.nii -expr 1 \
            -prefix rm.all1.${label}${run} -overwrite
    done
done
wait


for label in BOLD VASO ; do    
    for run in ${runs[@]} ; do
        # Warp the all-1 dataset for extents masking
        # -nwarp "mat.$func$run.warp.aff12.1D  " is an error
        3dAllineate -base template.volreg_${label}.nii \
                -input rm.all1.${label}${run}+orig \
                -1Dmatrix_apply mat.${label}${run}.warp.aff12.1D \
                -prefix rm.all1.${label}${run} -overwrite 
    done
done
wait


# Compute intersection across runs
for label in BOLD VASO ; do    
    3dTstat -prefix mask.${label}_extents.nii -overwrite \
        -min rm.all1.${label}'??'+orig.HEAD
done
wait



# Apply extents mask to functional data
# Zero out any time series with missing data
for label in BOLD VASO ; do    
    for run in ${runs[@]} ; do
        3dcalc -a rm.nomask.${label}${run}.volreg.nii -b mask.${label}_extents.nii \
            -expr 'a*b' -prefix ${label}${run}.volreg.nii -overwrite &
    done
done
wait


rm -f rm.*


3dTstat -prefix VASO_mean.nii -overwrite \
    -mean VASO'??'.volreg.nii




##################### Align T1 to mean EPI #####################
##===align T1 to VASO dataset.
# Move the T1 image to basically match the fMRI image to make the subsequent registration more accurate (each subject is different and needs to be modified)
3dcopy T1.nii test.nii -overwrite
3drotate -prefix test.nii -rotate 0 0 30 test.nii -overwrite
3drefit -deoblique -dzorigin 0 -dxorigin 36 -dyorigin 40 test.nii

align_epi_anat.py -anat2epi \
    -anat test.nii -anat_has_skull no \
    -epi VASO_mean.nii -epi_base 0 \
    -cost lpa -epi_strip 3dAutomask \
    -big_move -volreg off -tshift off \
    -suffix _al -overwrite

3dAFNItoNIFTI -prefix T1_al -overwrite test_al+orig.   
rm -f test_al+orig*
rm -f test.nii
rm -f test_al_mat.aff12.1D
rm -f rm*



rm -f VASO01.nii
rm -f BOLD01.nii
rm -f VASO02.nii
rm -f BOLD02.nii
rm -f VASO01.despike.nii
rm -f BOLD01.despike.nii
rm -f VASO02.despike.nii
rm -f BOLD02.despike.nii



##################### combine the images with the same phase #####################
# Copy the code printed out using DisposalPulsatilityData.m
# VASO
3dMean -prefix  rm.VASO.phase1.nii    VASO01.volreg.nii'[11]'  VASO01.volreg.nii'[15]'  VASO01.volreg.nii'[32]'  \
           VASO01.volreg.nii'[58]'  VASO01.volreg.nii'[86]'  VASO01.volreg.nii'[93]'  \
           VASO01.volreg.nii'[95]'  VASO01.volreg.nii'[97]'  VASO01.volreg.nii'[111]'  \
           VASO01.volreg.nii'[114]'  VASO01.volreg.nii'[119]'  VASO01.volreg.nii'[132]'  \
           VASO01.volreg.nii'[135]'  VASO01.volreg.nii'[152]'  VASO01.volreg.nii'[154]'  \
           VASO01.volreg.nii'[157]'  VASO01.volreg.nii'[167]'  VASO01.volreg.nii'[173]'  \
           VASO01.volreg.nii'[188]'  VASO01.volreg.nii'[196]'  VASO01.volreg.nii'[198]'  \
           VASO01.volreg.nii'[201]'  VASO01.volreg.nii'[204]'  VASO01.volreg.nii'[209]'  \
           VASO01.volreg.nii'[214]'  VASO01.volreg.nii'[232]'  VASO01.volreg.nii'[247]'  \
           VASO01.volreg.nii'[249]'  VASO01.volreg.nii'[265]'  VASO01.volreg.nii'[278]'  \
           VASO01.volreg.nii'[288]'  VASO01.volreg.nii'[291]'  VASO01.volreg.nii'[296]'  \
           -overwrite  

3dMean -prefix  rm.VASO.phase2.nii    VASO01.volreg.nii'[3]'  VASO01.volreg.nii'[6]'  VASO01.volreg.nii'[9]'  \
           VASO01.volreg.nii'[28]'  VASO01.volreg.nii'[30]'  VASO01.volreg.nii'[41]'  \
           VASO01.volreg.nii'[48]'  VASO01.volreg.nii'[50]'  VASO01.volreg.nii'[63]'  \
           VASO01.volreg.nii'[65]'  VASO01.volreg.nii'[84]'  VASO01.volreg.nii'[88]'  \
           VASO01.volreg.nii'[108]'  VASO01.volreg.nii'[127]'  VASO01.volreg.nii'[160]'  \
           VASO01.volreg.nii'[165]'  VASO01.volreg.nii'[169]'  VASO01.volreg.nii'[171]'  \
           VASO01.volreg.nii'[177]'  VASO01.volreg.nii'[179]'  VASO01.volreg.nii'[184]'  \
           VASO01.volreg.nii'[207]'  VASO01.volreg.nii'[224]'  VASO01.volreg.nii'[237]'  \
           VASO01.volreg.nii'[256]'  VASO01.volreg.nii'[268]'  VASO01.volreg.nii'[273]'  \
           VASO01.volreg.nii'[275]'  VASO01.volreg.nii'[285]'  -overwrite  

3dMean -prefix  rm.VASO.phase3.nii    VASO01.volreg.nii'[0]'  VASO01.volreg.nii'[20]'  VASO01.volreg.nii'[22]'  \
           VASO01.volreg.nii'[24]'  VASO01.volreg.nii'[26]'  VASO01.volreg.nii'[37]'  \
           VASO01.volreg.nii'[39]'  VASO01.volreg.nii'[46]'  VASO01.volreg.nii'[52]'  \
           VASO01.volreg.nii'[54]'  VASO01.volreg.nii'[70]'  VASO01.volreg.nii'[73]'  \
           VASO01.volreg.nii'[106]'  VASO01.volreg.nii'[116]'  VASO01.volreg.nii'[129]'  \
           VASO01.volreg.nii'[139]'  VASO01.volreg.nii'[150]'  VASO01.volreg.nii'[156]'  \
           VASO01.volreg.nii'[190]'  VASO01.volreg.nii'[192]'  VASO01.volreg.nii'[205]'  \
           VASO01.volreg.nii'[217]'  VASO01.volreg.nii'[241]'  VASO01.volreg.nii'[245]'  \
           VASO01.volreg.nii'[252]'  VASO01.volreg.nii'[271]'  VASO01.volreg.nii'[280]'  \
           VASO01.volreg.nii'[297]'  -overwrite  

3dMean -prefix  rm.VASO.phase4.nii    VASO01.volreg.nii'[18]'  VASO01.volreg.nii'[35]'  VASO01.volreg.nii'[56]'  \
           VASO01.volreg.nii'[67]'  VASO01.volreg.nii'[75]'  VASO01.volreg.nii'[77]'  \
           VASO01.volreg.nii'[79]'  VASO01.volreg.nii'[82]'  VASO01.volreg.nii'[90]'  \
           VASO01.volreg.nii'[100]'  VASO01.volreg.nii'[110]'  VASO01.volreg.nii'[121]'  \
           VASO01.volreg.nii'[134]'  VASO01.volreg.nii'[142]'  VASO01.volreg.nii'[147]'  \
           VASO01.volreg.nii'[163]'  VASO01.volreg.nii'[174]'  VASO01.volreg.nii'[182]'  \
           VASO01.volreg.nii'[200]'  VASO01.volreg.nii'[215]'  VASO01.volreg.nii'[221]'  \
           VASO01.volreg.nii'[227]'  VASO01.volreg.nii'[229]'  VASO01.volreg.nii'[243]'  \
           VASO01.volreg.nii'[258]'  VASO01.volreg.nii'[263]'  VASO01.volreg.nii'[277]'  \
           VASO01.volreg.nii'[283]'  VASO01.volreg.nii'[286]'  VASO01.volreg.nii'[289]'  \
           -overwrite  

3dMean -prefix  rm.VASO.phase5.nii    VASO01.volreg.nii'[4]'  VASO01.volreg.nii'[42]'  VASO01.volreg.nii'[44]'  \
           VASO01.volreg.nii'[61]'  VASO01.volreg.nii'[98]'  VASO01.volreg.nii'[103]'  \
           VASO01.volreg.nii'[113]'  VASO01.volreg.nii'[118]'  VASO01.volreg.nii'[124]'  \
           VASO01.volreg.nii'[126]'  VASO01.volreg.nii'[131]'  VASO01.volreg.nii'[136]'  \
           VASO01.volreg.nii'[145]'  VASO01.volreg.nii'[158]'  VASO01.volreg.nii'[176]'  \
           VASO01.volreg.nii'[187]'  VASO01.volreg.nii'[202]'  VASO01.volreg.nii'[212]'  \
           VASO01.volreg.nii'[231]'  VASO01.volreg.nii'[235]'  VASO01.volreg.nii'[239]'  \
           VASO01.volreg.nii'[261]'  VASO01.volreg.nii'[266]'  VASO01.volreg.nii'[292]'  \
           VASO01.volreg.nii'[294]'  -overwrite  

3dMean -prefix  rm.VASO.phase6.nii    VASO01.volreg.nii'[7]'  VASO01.volreg.nii'[10]'  VASO01.volreg.nii'[12]'  \
           VASO01.volreg.nii'[14]'  VASO01.volreg.nii'[16]'  VASO01.volreg.nii'[31]'  \
           VASO01.volreg.nii'[33]'  VASO01.volreg.nii'[49]'  VASO01.volreg.nii'[59]'  \
           VASO01.volreg.nii'[68]'  VASO01.volreg.nii'[71]'  VASO01.volreg.nii'[87]'  \
           VASO01.volreg.nii'[92]'  VASO01.volreg.nii'[94]'  VASO01.volreg.nii'[96]'  \
           VASO01.volreg.nii'[101]'  VASO01.volreg.nii'[115]'  VASO01.volreg.nii'[140]'  \
           VASO01.volreg.nii'[153]'  VASO01.volreg.nii'[155]'  VASO01.volreg.nii'[161]'  \
           VASO01.volreg.nii'[180]'  VASO01.volreg.nii'[185]'  VASO01.volreg.nii'[189]'  \
           VASO01.volreg.nii'[193]'  VASO01.volreg.nii'[195]'  VASO01.volreg.nii'[197]'  \
           VASO01.volreg.nii'[199]'  VASO01.volreg.nii'[208]'  VASO01.volreg.nii'[210]'  \
           VASO01.volreg.nii'[218]'  VASO01.volreg.nii'[222]'  VASO01.volreg.nii'[225]'  \
           VASO01.volreg.nii'[233]'  VASO01.volreg.nii'[248]'  VASO01.volreg.nii'[253]'  \
           VASO01.volreg.nii'[255]'  VASO01.volreg.nii'[269]'  VASO01.volreg.nii'[298]'  \
           -overwrite  

3dMean -prefix  rm.VASO.phase7.nii    VASO01.volreg.nii'[1]'  VASO01.volreg.nii'[23]'  VASO01.volreg.nii'[27]'  \
           VASO01.volreg.nii'[29]'  VASO01.volreg.nii'[38]'  VASO01.volreg.nii'[57]'  \
           VASO01.volreg.nii'[64]'  VASO01.volreg.nii'[85]'  VASO01.volreg.nii'[105]'  \
           VASO01.volreg.nii'[107]'  VASO01.volreg.nii'[122]'  VASO01.volreg.nii'[128]'  \
           VASO01.volreg.nii'[133]'  VASO01.volreg.nii'[137]'  VASO01.volreg.nii'[148]'  \
           VASO01.volreg.nii'[151]'  VASO01.volreg.nii'[166]'  VASO01.volreg.nii'[168]'  \
           VASO01.volreg.nii'[170]'  VASO01.volreg.nii'[178]'  VASO01.volreg.nii'[216]'  \
           VASO01.volreg.nii'[246]'  VASO01.volreg.nii'[250]'  VASO01.volreg.nii'[257]'  \
           VASO01.volreg.nii'[260]'  VASO01.volreg.nii'[264]'  VASO01.volreg.nii'[272]'  \
           VASO01.volreg.nii'[274]'  VASO01.volreg.nii'[287]'  -overwrite  

3dMean -prefix  rm.VASO.phase8.nii    VASO01.volreg.nii'[21]'  VASO01.volreg.nii'[40]'  VASO01.volreg.nii'[47]'  \
           VASO01.volreg.nii'[51]'  VASO01.volreg.nii'[53]'  VASO01.volreg.nii'[74]'  \
           VASO01.volreg.nii'[76]'  VASO01.volreg.nii'[80]'  VASO01.volreg.nii'[83]'  \
           VASO01.volreg.nii'[89]'  VASO01.volreg.nii'[109]'  VASO01.volreg.nii'[112]'  \
           VASO01.volreg.nii'[144]'  VASO01.volreg.nii'[164]'  VASO01.volreg.nii'[172]'  \
           VASO01.volreg.nii'[181]'  VASO01.volreg.nii'[183]'  VASO01.volreg.nii'[203]'  \
           VASO01.volreg.nii'[206]'  VASO01.volreg.nii'[219]'  VASO01.volreg.nii'[223]'  \
           VASO01.volreg.nii'[240]'  VASO01.volreg.nii'[267]'  VASO01.volreg.nii'[276]'  \
           VASO01.volreg.nii'[281]'  VASO01.volreg.nii'[284]'  VASO01.volreg.nii'[290]'  \
           -overwrite  

3dMean -prefix  rm.VASO.phase9.nii    VASO01.volreg.nii'[2]'  VASO01.volreg.nii'[5]'  VASO01.volreg.nii'[8]'  \
           VASO01.volreg.nii'[19]'  VASO01.volreg.nii'[25]'  VASO01.volreg.nii'[36]'  \
           VASO01.volreg.nii'[45]'  VASO01.volreg.nii'[62]'  VASO01.volreg.nii'[66]'  \
           VASO01.volreg.nii'[72]'  VASO01.volreg.nii'[78]'  VASO01.volreg.nii'[120]'  \
           VASO01.volreg.nii'[125]'  VASO01.volreg.nii'[146]'  VASO01.volreg.nii'[159]'  \
           VASO01.volreg.nii'[175]'  VASO01.volreg.nii'[191]'  VASO01.volreg.nii'[213]'  \
           VASO01.volreg.nii'[228]'  VASO01.volreg.nii'[234]'  VASO01.volreg.nii'[236]'  \
           VASO01.volreg.nii'[238]'  VASO01.volreg.nii'[242]'  VASO01.volreg.nii'[259]'  \
           VASO01.volreg.nii'[270]'  VASO01.volreg.nii'[279]'  VASO01.volreg.nii'[295]'  \
           -overwrite  

3dMean -prefix  rm.VASO.phase10.nii    VASO01.volreg.nii'[13]'  VASO01.volreg.nii'[17]'  VASO01.volreg.nii'[34]'  \
           VASO01.volreg.nii'[43]'  VASO01.volreg.nii'[55]'  VASO01.volreg.nii'[60]'  \
           VASO01.volreg.nii'[69]'  VASO01.volreg.nii'[81]'  VASO01.volreg.nii'[91]'  \
           VASO01.volreg.nii'[99]'  VASO01.volreg.nii'[102]'  VASO01.volreg.nii'[104]'  \
           VASO01.volreg.nii'[117]'  VASO01.volreg.nii'[123]'  VASO01.volreg.nii'[130]'  \
           VASO01.volreg.nii'[138]'  VASO01.volreg.nii'[141]'  VASO01.volreg.nii'[143]'  \
           VASO01.volreg.nii'[149]'  VASO01.volreg.nii'[162]'  VASO01.volreg.nii'[186]'  \
           VASO01.volreg.nii'[194]'  VASO01.volreg.nii'[211]'  VASO01.volreg.nii'[220]'  \
           VASO01.volreg.nii'[226]'  VASO01.volreg.nii'[230]'  VASO01.volreg.nii'[244]'  \
           VASO01.volreg.nii'[251]'  VASO01.volreg.nii'[254]'  VASO01.volreg.nii'[262]'  \
           VASO01.volreg.nii'[282]'  VASO01.volreg.nii'[293]'  VASO01.volreg.nii'[299]'  \
           -overwrite  

3dTcat -prefix VASO01.combphase -overwrite rm.VASO.phase1.nii 
3dbucket -glueto  VASO01.combphase+orig  rm.VASO.phase2.nii  rm.VASO.phase3.nii  rm.VASO.phase4.nii  rm.VASO.phase5.nii  rm.VASO.phase6.nii  rm.VASO.phase7.nii  rm.VASO.phase8.nii  rm.VASO.phase9.nii  rm.VASO.phase10.nii    -overwrite
3dAFNItoNIFTI -prefix VASO01.combphase  VASO01.combphase+orig. -overwrite
rm -f VASO01.combphase+orig*
rm -f rm*


3dMean -prefix  rm.VASO.phase1.nii    VASO02.volreg.nii'[0]'  VASO02.volreg.nii'[8]'  VASO02.volreg.nii'[15]'  \
           VASO02.volreg.nii'[52]'  VASO02.volreg.nii'[82]'  VASO02.volreg.nii'[87]'  \
           VASO02.volreg.nii'[93]'  VASO02.volreg.nii'[98]'  VASO02.volreg.nii'[105]'  \
           VASO02.volreg.nii'[114]'  VASO02.volreg.nii'[121]'  VASO02.volreg.nii'[124]'  \
           VASO02.volreg.nii'[127]'  VASO02.volreg.nii'[137]'  VASO02.volreg.nii'[141]'  \
           VASO02.volreg.nii'[165]'  VASO02.volreg.nii'[170]'  VASO02.volreg.nii'[174]'  \
           VASO02.volreg.nii'[178]'  VASO02.volreg.nii'[199]'  VASO02.volreg.nii'[204]'  \
           VASO02.volreg.nii'[211]'  VASO02.volreg.nii'[214]'  VASO02.volreg.nii'[215]'  \
           VASO02.volreg.nii'[218]'  VASO02.volreg.nii'[224]'  VASO02.volreg.nii'[230]'  \
           VASO02.volreg.nii'[234]'  VASO02.volreg.nii'[237]'  VASO02.volreg.nii'[239]'  \
           VASO02.volreg.nii'[249]'  VASO02.volreg.nii'[253]'  VASO02.volreg.nii'[262]'  \
           VASO02.volreg.nii'[290]'  -overwrite  

3dMean -prefix  rm.VASO.phase2.nii    VASO02.volreg.nii'[11]'  VASO02.volreg.nii'[17]'  VASO02.volreg.nii'[21]'  \
           VASO02.volreg.nii'[23]'  VASO02.volreg.nii'[33]'  VASO02.volreg.nii'[38]'  \
           VASO02.volreg.nii'[60]'  VASO02.volreg.nii'[77]'  VASO02.volreg.nii'[79]'  \
           VASO02.volreg.nii'[111]'  VASO02.volreg.nii'[117]'  VASO02.volreg.nii'[119]'  \
           VASO02.volreg.nii'[132]'  VASO02.volreg.nii'[135]'  VASO02.volreg.nii'[139]'  \
           VASO02.volreg.nii'[183]'  VASO02.volreg.nii'[209]'  VASO02.volreg.nii'[250]'  \
           VASO02.volreg.nii'[256]'  VASO02.volreg.nii'[258]'  VASO02.volreg.nii'[265]'  \
           VASO02.volreg.nii'[275]'  VASO02.volreg.nii'[281]'  VASO02.volreg.nii'[283]'  \
           VASO02.volreg.nii'[288]'  VASO02.volreg.nii'[294]'  VASO02.volreg.nii'[296]'  \
           -overwrite  

3dMean -prefix  rm.VASO.phase3.nii    VASO02.volreg.nii'[6]'  VASO02.volreg.nii'[18]'  VASO02.volreg.nii'[27]'  \
           VASO02.volreg.nii'[31]'  VASO02.volreg.nii'[42]'  VASO02.volreg.nii'[47]'  \
           VASO02.volreg.nii'[54]'  VASO02.volreg.nii'[58]'  VASO02.volreg.nii'[62]'  \
           VASO02.volreg.nii'[64]'  VASO02.volreg.nii'[69]'  VASO02.volreg.nii'[71]'  \
           VASO02.volreg.nii'[85]'  VASO02.volreg.nii'[101]'  VASO02.volreg.nii'[108]'  \
           VASO02.volreg.nii'[130]'  VASO02.volreg.nii'[144]'  VASO02.volreg.nii'[146]'  \
           VASO02.volreg.nii'[149]'  VASO02.volreg.nii'[152]'  VASO02.volreg.nii'[168]'  \
           VASO02.volreg.nii'[197]'  VASO02.volreg.nii'[221]'  VASO02.volreg.nii'[225]'  \
           VASO02.volreg.nii'[231]'  VASO02.volreg.nii'[246]'  VASO02.volreg.nii'[260]'  \
           VASO02.volreg.nii'[263]'  VASO02.volreg.nii'[267]'  VASO02.volreg.nii'[279]'  \
           VASO02.volreg.nii'[292]'  -overwrite  

3dMean -prefix  rm.VASO.phase4.nii    VASO02.volreg.nii'[1]'  VASO02.volreg.nii'[4]'  VASO02.volreg.nii'[9]'  \
           VASO02.volreg.nii'[19]'  VASO02.volreg.nii'[36]'  VASO02.volreg.nii'[40]'  \
           VASO02.volreg.nii'[50]'  VASO02.volreg.nii'[56]'  VASO02.volreg.nii'[73]'  \
           VASO02.volreg.nii'[99]'  VASO02.volreg.nii'[103]'  VASO02.volreg.nii'[112]'  \
           VASO02.volreg.nii'[115]'  VASO02.volreg.nii'[123]'  VASO02.volreg.nii'[125]'  \
           VASO02.volreg.nii'[154]'  VASO02.volreg.nii'[157]'  VASO02.volreg.nii'[163]'  \
           VASO02.volreg.nii'[181]'  VASO02.volreg.nii'[187]'  VASO02.volreg.nii'[188]'  \
           VASO02.volreg.nii'[191]'  VASO02.volreg.nii'[193]'  VASO02.volreg.nii'[195]'  \
           VASO02.volreg.nii'[202]'  VASO02.volreg.nii'[207]'  VASO02.volreg.nii'[216]'  \
           VASO02.volreg.nii'[235]'  VASO02.volreg.nii'[254]'  VASO02.volreg.nii'[299]'  \
           -overwrite  

3dMean -prefix  rm.VASO.phase5.nii    VASO02.volreg.nii'[14]'  VASO02.volreg.nii'[28]'  VASO02.volreg.nii'[43]'  \
           VASO02.volreg.nii'[45]'  VASO02.volreg.nii'[67]'  VASO02.volreg.nii'[80]'  \
           VASO02.volreg.nii'[83]'  VASO02.volreg.nii'[88]'  VASO02.volreg.nii'[92]'  \
           VASO02.volreg.nii'[94]'  VASO02.volreg.nii'[96]'  VASO02.volreg.nii'[106]'  \
           VASO02.volreg.nii'[109]'  VASO02.volreg.nii'[128]'  VASO02.volreg.nii'[159]'  \
           VASO02.volreg.nii'[161]'  VASO02.volreg.nii'[166]'  VASO02.volreg.nii'[175]'  \
           VASO02.volreg.nii'[179]'  VASO02.volreg.nii'[184]'  VASO02.volreg.nii'[200]'  \
           VASO02.volreg.nii'[212]'  VASO02.volreg.nii'[222]'  VASO02.volreg.nii'[228]'  \
           VASO02.volreg.nii'[232]'  VASO02.volreg.nii'[240]'  VASO02.volreg.nii'[242]'  \
           VASO02.volreg.nii'[244]'  VASO02.volreg.nii'[247]'  VASO02.volreg.nii'[251]'  \
           VASO02.volreg.nii'[270]'  VASO02.volreg.nii'[276]'  VASO02.volreg.nii'[286]'  \
           -overwrite  

3dMean -prefix  rm.VASO.phase6.nii    VASO02.volreg.nii'[20]'  VASO02.volreg.nii'[24]'  VASO02.volreg.nii'[34]'  \
           VASO02.volreg.nii'[53]'  VASO02.volreg.nii'[86]'  VASO02.volreg.nii'[90]'  \
           VASO02.volreg.nii'[118]'  VASO02.volreg.nii'[120]'  VASO02.volreg.nii'[133]'  \
           VASO02.volreg.nii'[150]'  VASO02.volreg.nii'[171]'  VASO02.volreg.nii'[173]'  \
           VASO02.volreg.nii'[177]'  VASO02.volreg.nii'[189]'  VASO02.volreg.nii'[205]'  \
           VASO02.volreg.nii'[219]'  VASO02.volreg.nii'[226]'  VASO02.volreg.nii'[238]'  \
           VASO02.volreg.nii'[268]'  VASO02.volreg.nii'[272]'  VASO02.volreg.nii'[284]'  \
           VASO02.volreg.nii'[289]'  -overwrite  

3dMean -prefix  rm.VASO.phase7.nii    VASO02.volreg.nii'[2]'  VASO02.volreg.nii'[7]'  VASO02.volreg.nii'[12]'  \
           VASO02.volreg.nii'[16]'  VASO02.volreg.nii'[22]'  VASO02.volreg.nii'[29]'  \
           VASO02.volreg.nii'[32]'  VASO02.volreg.nii'[48]'  VASO02.volreg.nii'[51]'  \
           VASO02.volreg.nii'[59]'  VASO02.volreg.nii'[61]'  VASO02.volreg.nii'[65]'  \
           VASO02.volreg.nii'[78]'  VASO02.volreg.nii'[122]'  VASO02.volreg.nii'[136]'  \
           VASO02.volreg.nii'[138]'  VASO02.volreg.nii'[140]'  VASO02.volreg.nii'[142]'  \
           VASO02.volreg.nii'[145]'  VASO02.volreg.nii'[147]'  VASO02.volreg.nii'[155]'  \
           VASO02.volreg.nii'[169]'  VASO02.volreg.nii'[186]'  VASO02.volreg.nii'[198]'  \
           VASO02.volreg.nii'[203]'  VASO02.volreg.nii'[210]'  VASO02.volreg.nii'[257]'  \
           VASO02.volreg.nii'[264]'  VASO02.volreg.nii'[266]'  VASO02.volreg.nii'[280]'  \
           VASO02.volreg.nii'[282]'  VASO02.volreg.nii'[291]'  VASO02.volreg.nii'[295]'  \
           -overwrite  

3dMean -prefix  rm.VASO.phase8.nii    VASO02.volreg.nii'[5]'  VASO02.volreg.nii'[10]'  VASO02.volreg.nii'[25]'  \
           VASO02.volreg.nii'[37]'  VASO02.volreg.nii'[46]'  VASO02.volreg.nii'[57]'  \
           VASO02.volreg.nii'[63]'  VASO02.volreg.nii'[70]'  VASO02.volreg.nii'[72]'  \
           VASO02.volreg.nii'[74]'  VASO02.volreg.nii'[97]'  VASO02.volreg.nii'[102]'  \
           VASO02.volreg.nii'[104]'  VASO02.volreg.nii'[113]'  VASO02.volreg.nii'[116]'  \
           VASO02.volreg.nii'[126]'  VASO02.volreg.nii'[129]'  VASO02.volreg.nii'[131]'  \
           VASO02.volreg.nii'[151]'  VASO02.volreg.nii'[164]'  VASO02.volreg.nii'[182]'  \
           VASO02.volreg.nii'[194]'  VASO02.volreg.nii'[208]'  VASO02.volreg.nii'[217]'  \
           VASO02.volreg.nii'[223]'  VASO02.volreg.nii'[229]'  VASO02.volreg.nii'[233]'  \
           VASO02.volreg.nii'[236]'  VASO02.volreg.nii'[255]'  VASO02.volreg.nii'[259]'  \
           VASO02.volreg.nii'[277]'  VASO02.volreg.nii'[287]'  VASO02.volreg.nii'[293]'  \
           VASO02.volreg.nii'[297]'  -overwrite  

3dMean -prefix  rm.VASO.phase9.nii    VASO02.volreg.nii'[39]'  VASO02.volreg.nii'[41]'  VASO02.volreg.nii'[55]'  \
           VASO02.volreg.nii'[75]'  VASO02.volreg.nii'[81]'  VASO02.volreg.nii'[84]'  \
           VASO02.volreg.nii'[100]'  VASO02.volreg.nii'[107]'  VASO02.volreg.nii'[110]'  \
           VASO02.volreg.nii'[134]'  VASO02.volreg.nii'[148]'  VASO02.volreg.nii'[153]'  \
           VASO02.volreg.nii'[156]'  VASO02.volreg.nii'[167]'  VASO02.volreg.nii'[180]'  \
           VASO02.volreg.nii'[192]'  VASO02.volreg.nii'[196]'  VASO02.volreg.nii'[213]'  \
           VASO02.volreg.nii'[245]'  VASO02.volreg.nii'[248]'  VASO02.volreg.nii'[252]'  \
           VASO02.volreg.nii'[261]'  VASO02.volreg.nii'[273]'  -overwrite  

3dMean -prefix  rm.VASO.phase10.nii    VASO02.volreg.nii'[3]'  VASO02.volreg.nii'[13]'  VASO02.volreg.nii'[26]'  \
           VASO02.volreg.nii'[30]'  VASO02.volreg.nii'[35]'  VASO02.volreg.nii'[44]'  \
           VASO02.volreg.nii'[49]'  VASO02.volreg.nii'[66]'  VASO02.volreg.nii'[68]'  \
           VASO02.volreg.nii'[76]'  VASO02.volreg.nii'[89]'  VASO02.volreg.nii'[91]'  \
           VASO02.volreg.nii'[95]'  VASO02.volreg.nii'[143]'  VASO02.volreg.nii'[158]'  \
           VASO02.volreg.nii'[160]'  VASO02.volreg.nii'[162]'  VASO02.volreg.nii'[172]'  \
           VASO02.volreg.nii'[176]'  VASO02.volreg.nii'[185]'  VASO02.volreg.nii'[190]'  \
           VASO02.volreg.nii'[201]'  VASO02.volreg.nii'[206]'  VASO02.volreg.nii'[220]'  \
           VASO02.volreg.nii'[227]'  VASO02.volreg.nii'[241]'  VASO02.volreg.nii'[243]'  \
           VASO02.volreg.nii'[269]'  VASO02.volreg.nii'[271]'  VASO02.volreg.nii'[274]'  \
           VASO02.volreg.nii'[278]'  VASO02.volreg.nii'[285]'  VASO02.volreg.nii'[298]'  \
           -overwrite  

3dTcat -prefix VASO02.combphase -overwrite rm.VASO.phase1.nii 
3dbucket -glueto  VASO02.combphase+orig  rm.VASO.phase2.nii  rm.VASO.phase3.nii  rm.VASO.phase4.nii  rm.VASO.phase5.nii  rm.VASO.phase6.nii  rm.VASO.phase7.nii  rm.VASO.phase8.nii  rm.VASO.phase9.nii  rm.VASO.phase10.nii    -overwrite
3dAFNItoNIFTI -prefix VASO02.combphase  VASO02.combphase+orig. -overwrite
rm -f VASO02.combphase+orig*
rm -f rm*



# BOLD
3dMean -prefix  rm.BOLD.phase1.nii    BOLD01.volreg.nii'[2]'  BOLD01.volreg.nii'[5]'  BOLD01.volreg.nii'[8]'  \
           BOLD01.volreg.nii'[19]'  BOLD01.volreg.nii'[25]'  BOLD01.volreg.nii'[36]'  \
           BOLD01.volreg.nii'[45]'  BOLD01.volreg.nii'[51]'  BOLD01.volreg.nii'[53]'  \
           BOLD01.volreg.nii'[62]'  BOLD01.volreg.nii'[74]'  BOLD01.volreg.nii'[76]'  \
           BOLD01.volreg.nii'[80]'  BOLD01.volreg.nii'[83]'  BOLD01.volreg.nii'[89]'  \
           BOLD01.volreg.nii'[109]'  BOLD01.volreg.nii'[112]'  BOLD01.volreg.nii'[128]'  \
           BOLD01.volreg.nii'[159]'  BOLD01.volreg.nii'[164]'  BOLD01.volreg.nii'[175]'  \
           BOLD01.volreg.nii'[183]'  BOLD01.volreg.nii'[213]'  BOLD01.volreg.nii'[236]'  \
           BOLD01.volreg.nii'[257]'  BOLD01.volreg.nii'[260]'  BOLD01.volreg.nii'[267]'  \
           BOLD01.volreg.nii'[276]'  BOLD01.volreg.nii'[295]'  -overwrite  

3dMean -prefix  rm.BOLD.phase2.nii    BOLD01.volreg.nii'[55]'  BOLD01.volreg.nii'[69]'  BOLD01.volreg.nii'[72]'  \
           BOLD01.volreg.nii'[78]'  BOLD01.volreg.nii'[120]'  BOLD01.volreg.nii'[130]'  \
           BOLD01.volreg.nii'[138]'  BOLD01.volreg.nii'[146]'  BOLD01.volreg.nii'[149]'  \
           BOLD01.volreg.nii'[162]'  BOLD01.volreg.nii'[181]'  BOLD01.volreg.nii'[191]'  \
           BOLD01.volreg.nii'[211]'  BOLD01.volreg.nii'[220]'  BOLD01.volreg.nii'[228]'  \
           BOLD01.volreg.nii'[242]'  BOLD01.volreg.nii'[244]'  BOLD01.volreg.nii'[262]'  \
           BOLD01.volreg.nii'[270]'  BOLD01.volreg.nii'[279]'  BOLD01.volreg.nii'[299]'  \
           -overwrite  

3dMean -prefix  rm.BOLD.phase3.nii    BOLD01.volreg.nii'[13]'  BOLD01.volreg.nii'[17]'  BOLD01.volreg.nii'[34]'  \
           BOLD01.volreg.nii'[43]'  BOLD01.volreg.nii'[60]'  BOLD01.volreg.nii'[66]'  \
           BOLD01.volreg.nii'[81]'  BOLD01.volreg.nii'[91]'  BOLD01.volreg.nii'[93]'  \
           BOLD01.volreg.nii'[97]'  BOLD01.volreg.nii'[99]'  BOLD01.volreg.nii'[102]'  \
           BOLD01.volreg.nii'[117]'  BOLD01.volreg.nii'[123]'  BOLD01.volreg.nii'[125]'  \
           BOLD01.volreg.nii'[141]'  BOLD01.volreg.nii'[143]'  BOLD01.volreg.nii'[144]'  \
           BOLD01.volreg.nii'[154]'  BOLD01.volreg.nii'[173]'  BOLD01.volreg.nii'[186]'  \
           BOLD01.volreg.nii'[194]'  BOLD01.volreg.nii'[204]'  BOLD01.volreg.nii'[214]'  \
           BOLD01.volreg.nii'[226]'  BOLD01.volreg.nii'[230]'  BOLD01.volreg.nii'[232]'  \
           BOLD01.volreg.nii'[234]'  BOLD01.volreg.nii'[238]'  BOLD01.volreg.nii'[249]'  \
           BOLD01.volreg.nii'[251]'  BOLD01.volreg.nii'[259]'  BOLD01.volreg.nii'[265]'  \
           BOLD01.volreg.nii'[282]'  BOLD01.volreg.nii'[288]'  BOLD01.volreg.nii'[293]'  \
           BOLD01.volreg.nii'[296]'  -overwrite  

3dMean -prefix  rm.BOLD.phase4.nii    BOLD01.volreg.nii'[3]'  BOLD01.volreg.nii'[11]'  BOLD01.volreg.nii'[15]'  \
           BOLD01.volreg.nii'[32]'  BOLD01.volreg.nii'[41]'  BOLD01.volreg.nii'[58]'  \
           BOLD01.volreg.nii'[86]'  BOLD01.volreg.nii'[104]'  BOLD01.volreg.nii'[114]'  \
           BOLD01.volreg.nii'[132]'  BOLD01.volreg.nii'[135]'  BOLD01.volreg.nii'[152]'  \
           BOLD01.volreg.nii'[157]'  BOLD01.volreg.nii'[160]'  BOLD01.volreg.nii'[165]'  \
           BOLD01.volreg.nii'[169]'  BOLD01.volreg.nii'[179]'  BOLD01.volreg.nii'[184]'  \
           BOLD01.volreg.nii'[188]'  BOLD01.volreg.nii'[196]'  BOLD01.volreg.nii'[198]'  \
           BOLD01.volreg.nii'[209]'  BOLD01.volreg.nii'[224]'  BOLD01.volreg.nii'[247]'  \
           BOLD01.volreg.nii'[254]'  BOLD01.volreg.nii'[273]'  BOLD01.volreg.nii'[285]'  \
           BOLD01.volreg.nii'[291]'  -overwrite  

3dMean -prefix  rm.BOLD.phase5.nii    BOLD01.volreg.nii'[6]'  BOLD01.volreg.nii'[9]'  BOLD01.volreg.nii'[22]'  \
           BOLD01.volreg.nii'[26]'  BOLD01.volreg.nii'[28]'  BOLD01.volreg.nii'[30]'  \
           BOLD01.volreg.nii'[48]'  BOLD01.volreg.nii'[50]'  BOLD01.volreg.nii'[63]'  \
           BOLD01.volreg.nii'[65]'  BOLD01.volreg.nii'[67]'  BOLD01.volreg.nii'[70]'  \
           BOLD01.volreg.nii'[84]'  BOLD01.volreg.nii'[88]'  BOLD01.volreg.nii'[95]'  \
           BOLD01.volreg.nii'[106]'  BOLD01.volreg.nii'[108]'  BOLD01.volreg.nii'[111]'  \
           BOLD01.volreg.nii'[119]'  BOLD01.volreg.nii'[127]'  BOLD01.volreg.nii'[139]'  \
           BOLD01.volreg.nii'[167]'  BOLD01.volreg.nii'[171]'  BOLD01.volreg.nii'[177]'  \
           BOLD01.volreg.nii'[201]'  BOLD01.volreg.nii'[207]'  BOLD01.volreg.nii'[217]'  \
           BOLD01.volreg.nii'[252]'  BOLD01.volreg.nii'[256]'  BOLD01.volreg.nii'[268]'  \
           BOLD01.volreg.nii'[275]'  BOLD01.volreg.nii'[278]'  -overwrite  

3dMean -prefix  rm.BOLD.phase6.nii    BOLD01.volreg.nii'[0]'  BOLD01.volreg.nii'[20]'  BOLD01.volreg.nii'[24]'  \
           BOLD01.volreg.nii'[37]'  BOLD01.volreg.nii'[39]'  BOLD01.volreg.nii'[46]'  \
           BOLD01.volreg.nii'[52]'  BOLD01.volreg.nii'[73]'  BOLD01.volreg.nii'[77]'  \
           BOLD01.volreg.nii'[82]'  BOLD01.volreg.nii'[100]'  BOLD01.volreg.nii'[129]'  \
           BOLD01.volreg.nii'[150]'  BOLD01.volreg.nii'[182]'  BOLD01.volreg.nii'[190]'  \
           BOLD01.volreg.nii'[192]'  BOLD01.volreg.nii'[205]'  BOLD01.volreg.nii'[215]'  \
           BOLD01.volreg.nii'[221]'  BOLD01.volreg.nii'[237]'  BOLD01.volreg.nii'[241]'  \
           BOLD01.volreg.nii'[245]'  BOLD01.volreg.nii'[263]'  BOLD01.volreg.nii'[271]'  \
           BOLD01.volreg.nii'[277]'  BOLD01.volreg.nii'[280]'  BOLD01.volreg.nii'[297]'  \
           -overwrite  

3dMean -prefix  rm.BOLD.phase7.nii    BOLD01.volreg.nii'[4]'  BOLD01.volreg.nii'[18]'  BOLD01.volreg.nii'[35]'  \
           BOLD01.volreg.nii'[54]'  BOLD01.volreg.nii'[56]'  BOLD01.volreg.nii'[61]'  \
           BOLD01.volreg.nii'[75]'  BOLD01.volreg.nii'[79]'  BOLD01.volreg.nii'[90]'  \
           BOLD01.volreg.nii'[116]'  BOLD01.volreg.nii'[121]'  BOLD01.volreg.nii'[134]'  \
           BOLD01.volreg.nii'[136]'  BOLD01.volreg.nii'[142]'  BOLD01.volreg.nii'[145]'  \
           BOLD01.volreg.nii'[147]'  BOLD01.volreg.nii'[156]'  BOLD01.volreg.nii'[163]'  \
           BOLD01.volreg.nii'[174]'  BOLD01.volreg.nii'[218]'  BOLD01.volreg.nii'[227]'  \
           BOLD01.volreg.nii'[229]'  BOLD01.volreg.nii'[235]'  BOLD01.volreg.nii'[239]'  \
           BOLD01.volreg.nii'[243]'  BOLD01.volreg.nii'[258]'  BOLD01.volreg.nii'[266]'  \
           BOLD01.volreg.nii'[283]'  BOLD01.volreg.nii'[286]'  BOLD01.volreg.nii'[289]'  \
           -overwrite  

3dMean -prefix  rm.BOLD.phase8.nii    BOLD01.volreg.nii'[44]'  BOLD01.volreg.nii'[68]'  BOLD01.volreg.nii'[71]'  \
           BOLD01.volreg.nii'[92]'  BOLD01.volreg.nii'[98]'  BOLD01.volreg.nii'[103]'  \
           BOLD01.volreg.nii'[110]'  BOLD01.volreg.nii'[113]'  BOLD01.volreg.nii'[118]'  \
           BOLD01.volreg.nii'[124]'  BOLD01.volreg.nii'[131]'  BOLD01.volreg.nii'[153]'  \
           BOLD01.volreg.nii'[158]'  BOLD01.volreg.nii'[180]'  BOLD01.volreg.nii'[185]'  \
           BOLD01.volreg.nii'[187]'  BOLD01.volreg.nii'[200]'  BOLD01.volreg.nii'[202]'  \
           BOLD01.volreg.nii'[212]'  BOLD01.volreg.nii'[222]'  BOLD01.volreg.nii'[231]'  \
           BOLD01.volreg.nii'[233]'  BOLD01.volreg.nii'[255]'  BOLD01.volreg.nii'[261]'  \
           BOLD01.volreg.nii'[292]'  -overwrite  

3dMean -prefix  rm.BOLD.phase9.nii    BOLD01.volreg.nii'[1]'  BOLD01.volreg.nii'[7]'  BOLD01.volreg.nii'[10]'  \
           BOLD01.volreg.nii'[12]'  BOLD01.volreg.nii'[14]'  BOLD01.volreg.nii'[16]'  \
           BOLD01.volreg.nii'[29]'  BOLD01.volreg.nii'[31]'  BOLD01.volreg.nii'[33]'  \
           BOLD01.volreg.nii'[42]'  BOLD01.volreg.nii'[49]'  BOLD01.volreg.nii'[59]'  \
           BOLD01.volreg.nii'[87]'  BOLD01.volreg.nii'[94]'  BOLD01.volreg.nii'[96]'  \
           BOLD01.volreg.nii'[101]'  BOLD01.volreg.nii'[107]'  BOLD01.volreg.nii'[115]'  \
           BOLD01.volreg.nii'[122]'  BOLD01.volreg.nii'[126]'  BOLD01.volreg.nii'[140]'  \
           BOLD01.volreg.nii'[148]'  BOLD01.volreg.nii'[161]'  BOLD01.volreg.nii'[168]'  \
           BOLD01.volreg.nii'[176]'  BOLD01.volreg.nii'[193]'  BOLD01.volreg.nii'[195]'  \
           BOLD01.volreg.nii'[197]'  BOLD01.volreg.nii'[208]'  BOLD01.volreg.nii'[210]'  \
           BOLD01.volreg.nii'[225]'  BOLD01.volreg.nii'[246]'  BOLD01.volreg.nii'[248]'  \
           BOLD01.volreg.nii'[253]'  BOLD01.volreg.nii'[269]'  BOLD01.volreg.nii'[287]'  \
           BOLD01.volreg.nii'[294]'  BOLD01.volreg.nii'[298]'  -overwrite  

3dMean -prefix  rm.BOLD.phase10.nii    BOLD01.volreg.nii'[21]'  BOLD01.volreg.nii'[23]'  BOLD01.volreg.nii'[27]'  \
           BOLD01.volreg.nii'[38]'  BOLD01.volreg.nii'[40]'  BOLD01.volreg.nii'[47]'  \
           BOLD01.volreg.nii'[57]'  BOLD01.volreg.nii'[64]'  BOLD01.volreg.nii'[85]'  \
           BOLD01.volreg.nii'[105]'  BOLD01.volreg.nii'[133]'  BOLD01.volreg.nii'[137]'  \
           BOLD01.volreg.nii'[151]'  BOLD01.volreg.nii'[155]'  BOLD01.volreg.nii'[166]'  \
           BOLD01.volreg.nii'[170]'  BOLD01.volreg.nii'[172]'  BOLD01.volreg.nii'[178]'  \
           BOLD01.volreg.nii'[189]'  BOLD01.volreg.nii'[199]'  BOLD01.volreg.nii'[203]'  \
           BOLD01.volreg.nii'[206]'  BOLD01.volreg.nii'[216]'  BOLD01.volreg.nii'[219]'  \
           BOLD01.volreg.nii'[223]'  BOLD01.volreg.nii'[240]'  BOLD01.volreg.nii'[250]'  \
           BOLD01.volreg.nii'[264]'  BOLD01.volreg.nii'[272]'  BOLD01.volreg.nii'[274]'  \
           BOLD01.volreg.nii'[281]'  BOLD01.volreg.nii'[284]'  BOLD01.volreg.nii'[290]'  \
           -overwrite  

3dTcat -prefix BOLD01.combphase -overwrite rm.BOLD.phase1.nii 
3dbucket -glueto  BOLD01.combphase+orig  rm.BOLD.phase2.nii  rm.BOLD.phase3.nii  rm.BOLD.phase4.nii  rm.BOLD.phase5.nii  rm.BOLD.phase6.nii  rm.BOLD.phase7.nii  rm.BOLD.phase8.nii  rm.BOLD.phase9.nii  rm.BOLD.phase10.nii    -overwrite
3dAFNItoNIFTI -prefix BOLD01.combphase  BOLD01.combphase+orig. -overwrite
rm -f BOLD01.combphase+orig*
rm -f rm*


3dMean -prefix  rm.BOLD.phase1.nii    BOLD02.volreg.nii'[5]'  BOLD02.volreg.nii'[37]'  BOLD02.volreg.nii'[41]'  \
           BOLD02.volreg.nii'[46]'  BOLD02.volreg.nii'[57]'  BOLD02.volreg.nii'[63]'  \
           BOLD02.volreg.nii'[72]'  BOLD02.volreg.nii'[84]'  BOLD02.volreg.nii'[100]'  \
           BOLD02.volreg.nii'[107]'  BOLD02.volreg.nii'[129]'  BOLD02.volreg.nii'[131]'  \
           BOLD02.volreg.nii'[134]'  BOLD02.volreg.nii'[143]'  BOLD02.volreg.nii'[151]'  \
           BOLD02.volreg.nii'[180]'  BOLD02.volreg.nii'[208]'  BOLD02.volreg.nii'[213]'  \
           BOLD02.volreg.nii'[245]'  BOLD02.volreg.nii'[248]'  BOLD02.volreg.nii'[255]'  \
           BOLD02.volreg.nii'[259]'  BOLD02.volreg.nii'[261]'  BOLD02.volreg.nii'[266]'  \
           BOLD02.volreg.nii'[291]'  BOLD02.volreg.nii'[293]'  -overwrite  

3dMean -prefix  rm.BOLD.phase2.nii    BOLD02.volreg.nii'[3]'  BOLD02.volreg.nii'[26]'  BOLD02.volreg.nii'[30]'  \
           BOLD02.volreg.nii'[39]'  BOLD02.volreg.nii'[55]'  BOLD02.volreg.nii'[68]'  \
           BOLD02.volreg.nii'[76]'  BOLD02.volreg.nii'[102]'  BOLD02.volreg.nii'[110]'  \
           BOLD02.volreg.nii'[148]'  BOLD02.volreg.nii'[153]'  BOLD02.volreg.nii'[156]'  \
           BOLD02.volreg.nii'[167]'  BOLD02.volreg.nii'[192]'  BOLD02.volreg.nii'[194]'  \
           BOLD02.volreg.nii'[196]'  BOLD02.volreg.nii'[201]'  BOLD02.volreg.nii'[220]'  \
           BOLD02.volreg.nii'[230]'  BOLD02.volreg.nii'[262]'  BOLD02.volreg.nii'[274]'  \
           BOLD02.volreg.nii'[278]'  -overwrite  

3dMean -prefix  rm.BOLD.phase3.nii    BOLD02.volreg.nii'[0]'  BOLD02.volreg.nii'[8]'  BOLD02.volreg.nii'[13]'  \
           BOLD02.volreg.nii'[35]'  BOLD02.volreg.nii'[44]'  BOLD02.volreg.nii'[49]'  \
           BOLD02.volreg.nii'[66]'  BOLD02.volreg.nii'[87]'  BOLD02.volreg.nii'[89]'  \
           BOLD02.volreg.nii'[93]'  BOLD02.volreg.nii'[95]'  BOLD02.volreg.nii'[98]'  \
           BOLD02.volreg.nii'[114]'  BOLD02.volreg.nii'[127]'  BOLD02.volreg.nii'[160]'  \
           BOLD02.volreg.nii'[162]'  BOLD02.volreg.nii'[165]'  BOLD02.volreg.nii'[172]'  \
           BOLD02.volreg.nii'[174]'  BOLD02.volreg.nii'[178]'  BOLD02.volreg.nii'[183]'  \
           BOLD02.volreg.nii'[185]'  BOLD02.volreg.nii'[190]'  BOLD02.volreg.nii'[206]'  \
           BOLD02.volreg.nii'[214]'  BOLD02.volreg.nii'[215]'  BOLD02.volreg.nii'[224]'  \
           BOLD02.volreg.nii'[227]'  BOLD02.volreg.nii'[234]'  BOLD02.volreg.nii'[241]'  \
           BOLD02.volreg.nii'[243]'  BOLD02.volreg.nii'[249]'  BOLD02.volreg.nii'[253]'  \
           BOLD02.volreg.nii'[269]'  BOLD02.volreg.nii'[285]'  BOLD02.volreg.nii'[298]'  \
           -overwrite  

3dMean -prefix  rm.BOLD.phase4.nii    BOLD02.volreg.nii'[15]'  BOLD02.volreg.nii'[17]'  BOLD02.volreg.nii'[18]'  \
           BOLD02.volreg.nii'[33]'  BOLD02.volreg.nii'[52]'  BOLD02.volreg.nii'[82]'  \
           BOLD02.volreg.nii'[91]'  BOLD02.volreg.nii'[105]'  BOLD02.volreg.nii'[111]'  \
           BOLD02.volreg.nii'[119]'  BOLD02.volreg.nii'[124]'  BOLD02.volreg.nii'[132]'  \
           BOLD02.volreg.nii'[158]'  BOLD02.volreg.nii'[170]'  BOLD02.volreg.nii'[176]'  \
           BOLD02.volreg.nii'[199]'  BOLD02.volreg.nii'[204]'  BOLD02.volreg.nii'[211]'  \
           BOLD02.volreg.nii'[218]'  BOLD02.volreg.nii'[237]'  BOLD02.volreg.nii'[239]'  \
           BOLD02.volreg.nii'[250]'  BOLD02.volreg.nii'[256]'  BOLD02.volreg.nii'[271]'  \
           BOLD02.volreg.nii'[288]'  BOLD02.volreg.nii'[290]'  -overwrite  

3dMean -prefix  rm.BOLD.phase5.nii    BOLD02.volreg.nii'[11]'  BOLD02.volreg.nii'[21]'  BOLD02.volreg.nii'[23]'  \
           BOLD02.volreg.nii'[27]'  BOLD02.volreg.nii'[42]'  BOLD02.volreg.nii'[47]'  \
           BOLD02.volreg.nii'[58]'  BOLD02.volreg.nii'[60]'  BOLD02.volreg.nii'[71]'  \
           BOLD02.volreg.nii'[77]'  BOLD02.volreg.nii'[79]'  BOLD02.volreg.nii'[85]'  \
           BOLD02.volreg.nii'[108]'  BOLD02.volreg.nii'[117]'  BOLD02.volreg.nii'[121]'  \
           BOLD02.volreg.nii'[130]'  BOLD02.volreg.nii'[135]'  BOLD02.volreg.nii'[137]'  \
           BOLD02.volreg.nii'[139]'  BOLD02.volreg.nii'[141]'  BOLD02.volreg.nii'[149]'  \
           BOLD02.volreg.nii'[168]'  BOLD02.volreg.nii'[209]'  BOLD02.volreg.nii'[221]'  \
           BOLD02.volreg.nii'[225]'  BOLD02.volreg.nii'[231]'  BOLD02.volreg.nii'[246]'  \
           BOLD02.volreg.nii'[258]'  BOLD02.volreg.nii'[263]'  BOLD02.volreg.nii'[265]'  \
           BOLD02.volreg.nii'[267]'  BOLD02.volreg.nii'[275]'  BOLD02.volreg.nii'[283]'  \
           BOLD02.volreg.nii'[292]'  BOLD02.volreg.nii'[294]'  BOLD02.volreg.nii'[296]'  \
           -overwrite  

3dMean -prefix  rm.BOLD.phase6.nii    BOLD02.volreg.nii'[1]'  BOLD02.volreg.nii'[4]'  BOLD02.volreg.nii'[6]'  \
           BOLD02.volreg.nii'[19]'  BOLD02.volreg.nii'[31]'  BOLD02.volreg.nii'[36]'  \
           BOLD02.volreg.nii'[38]'  BOLD02.volreg.nii'[50]'  BOLD02.volreg.nii'[54]'  \
           BOLD02.volreg.nii'[62]'  BOLD02.volreg.nii'[64]'  BOLD02.volreg.nii'[69]'  \
           BOLD02.volreg.nii'[101]'  BOLD02.volreg.nii'[103]'  BOLD02.volreg.nii'[144]'  \
           BOLD02.volreg.nii'[146]'  BOLD02.volreg.nii'[152]'  BOLD02.volreg.nii'[163]'  \
           BOLD02.volreg.nii'[187]'  BOLD02.volreg.nii'[188]'  BOLD02.volreg.nii'[193]'  \
           BOLD02.volreg.nii'[197]'  BOLD02.volreg.nii'[202]'  BOLD02.volreg.nii'[207]'  \
           BOLD02.volreg.nii'[216]'  BOLD02.volreg.nii'[254]'  BOLD02.volreg.nii'[260]'  \
           BOLD02.volreg.nii'[279]'  BOLD02.volreg.nii'[281]'  BOLD02.volreg.nii'[299]'  \
           -overwrite  

3dMean -prefix  rm.BOLD.phase7.nii    BOLD02.volreg.nii'[9]'  BOLD02.volreg.nii'[28]'  BOLD02.volreg.nii'[40]'  \
           BOLD02.volreg.nii'[45]'  BOLD02.volreg.nii'[56]'  BOLD02.volreg.nii'[73]'  \
           BOLD02.volreg.nii'[83]'  BOLD02.volreg.nii'[96]'  BOLD02.volreg.nii'[99]'  \
           BOLD02.volreg.nii'[112]'  BOLD02.volreg.nii'[115]'  BOLD02.volreg.nii'[125]'  \
           BOLD02.volreg.nii'[128]'  BOLD02.volreg.nii'[154]'  BOLD02.volreg.nii'[157]'  \
           BOLD02.volreg.nii'[181]'  BOLD02.volreg.nii'[195]'  BOLD02.volreg.nii'[212]'  \
           BOLD02.volreg.nii'[226]'  BOLD02.volreg.nii'[235]'  BOLD02.volreg.nii'[244]'  \
           BOLD02.volreg.nii'[251]'  BOLD02.volreg.nii'[270]'  BOLD02.volreg.nii'[276]'  \
           BOLD02.volreg.nii'[286]'  -overwrite  

3dMean -prefix  rm.BOLD.phase8.nii    BOLD02.volreg.nii'[14]'  BOLD02.volreg.nii'[24]'  BOLD02.volreg.nii'[43]'  \
           BOLD02.volreg.nii'[67]'  BOLD02.volreg.nii'[80]'  BOLD02.volreg.nii'[90]'  \
           BOLD02.volreg.nii'[94]'  BOLD02.volreg.nii'[106]'  BOLD02.volreg.nii'[109]'  \
           BOLD02.volreg.nii'[123]'  BOLD02.volreg.nii'[133]'  BOLD02.volreg.nii'[150]'  \
           BOLD02.volreg.nii'[166]'  BOLD02.volreg.nii'[171]'  BOLD02.volreg.nii'[179]'  \
           BOLD02.volreg.nii'[191]'  BOLD02.volreg.nii'[222]'  BOLD02.volreg.nii'[228]'  \
           BOLD02.volreg.nii'[232]'  BOLD02.volreg.nii'[240]'  BOLD02.volreg.nii'[242]'  \
           BOLD02.volreg.nii'[247]'  BOLD02.volreg.nii'[289]'  -overwrite  

3dMean -prefix  rm.BOLD.phase9.nii    BOLD02.volreg.nii'[2]'  BOLD02.volreg.nii'[7]'  BOLD02.volreg.nii'[12]'  \
           BOLD02.volreg.nii'[20]'  BOLD02.volreg.nii'[25]'  BOLD02.volreg.nii'[29]'  \
           BOLD02.volreg.nii'[34]'  BOLD02.volreg.nii'[51]'  BOLD02.volreg.nii'[86]'  \
           BOLD02.volreg.nii'[88]'  BOLD02.volreg.nii'[92]'  BOLD02.volreg.nii'[118]'  \
           BOLD02.volreg.nii'[120]'  BOLD02.volreg.nii'[136]'  BOLD02.volreg.nii'[140]'  \
           BOLD02.volreg.nii'[142]'  BOLD02.volreg.nii'[147]'  BOLD02.volreg.nii'[155]'  \
           BOLD02.volreg.nii'[159]'  BOLD02.volreg.nii'[161]'  BOLD02.volreg.nii'[169]'  \
           BOLD02.volreg.nii'[173]'  BOLD02.volreg.nii'[175]'  BOLD02.volreg.nii'[177]'  \
           BOLD02.volreg.nii'[184]'  BOLD02.volreg.nii'[189]'  BOLD02.volreg.nii'[198]'  \
           BOLD02.volreg.nii'[200]'  BOLD02.volreg.nii'[205]'  BOLD02.volreg.nii'[210]'  \
           BOLD02.volreg.nii'[219]'  BOLD02.volreg.nii'[236]'  BOLD02.volreg.nii'[238]'  \
           BOLD02.volreg.nii'[257]'  BOLD02.volreg.nii'[268]'  BOLD02.volreg.nii'[277]'  \
           -overwrite  

3dMean -prefix  rm.BOLD.phase10.nii    BOLD02.volreg.nii'[10]'  BOLD02.volreg.nii'[16]'  BOLD02.volreg.nii'[22]'  \
           BOLD02.volreg.nii'[32]'  BOLD02.volreg.nii'[48]'  BOLD02.volreg.nii'[53]'  \
           BOLD02.volreg.nii'[59]'  BOLD02.volreg.nii'[61]'  BOLD02.volreg.nii'[65]'  \
           BOLD02.volreg.nii'[70]'  BOLD02.volreg.nii'[74]'  BOLD02.volreg.nii'[75]'  \
           BOLD02.volreg.nii'[78]'  BOLD02.volreg.nii'[81]'  BOLD02.volreg.nii'[97]'  \
           BOLD02.volreg.nii'[104]'  BOLD02.volreg.nii'[113]'  BOLD02.volreg.nii'[116]'  \
           BOLD02.volreg.nii'[122]'  BOLD02.volreg.nii'[126]'  BOLD02.volreg.nii'[138]'  \
           BOLD02.volreg.nii'[145]'  BOLD02.volreg.nii'[164]'  BOLD02.volreg.nii'[182]'  \
           BOLD02.volreg.nii'[186]'  BOLD02.volreg.nii'[203]'  BOLD02.volreg.nii'[217]'  \
           BOLD02.volreg.nii'[223]'  BOLD02.volreg.nii'[229]'  BOLD02.volreg.nii'[233]'  \
           BOLD02.volreg.nii'[252]'  BOLD02.volreg.nii'[264]'  BOLD02.volreg.nii'[272]'  \
           BOLD02.volreg.nii'[273]'  BOLD02.volreg.nii'[280]'  BOLD02.volreg.nii'[282]'  \
           BOLD02.volreg.nii'[284]'  BOLD02.volreg.nii'[287]'  BOLD02.volreg.nii'[295]'  \
           BOLD02.volreg.nii'[297]'  -overwrite  

3dTcat -prefix BOLD02.combphase -overwrite rm.BOLD.phase1.nii 
3dbucket -glueto  BOLD02.combphase+orig  rm.BOLD.phase2.nii  rm.BOLD.phase3.nii  rm.BOLD.phase4.nii  rm.BOLD.phase5.nii  rm.BOLD.phase6.nii  rm.BOLD.phase7.nii  rm.BOLD.phase8.nii  rm.BOLD.phase9.nii  rm.BOLD.phase10.nii    -overwrite
3dAFNItoNIFTI -prefix BOLD02.combphase  BOLD02.combphase+orig. -overwrite
rm -f BOLD02.combphase+orig*
rm -f rm*



##################### segment the WM/GM/CSF #####################
## segment WM/GM/CSF
3dSeg -anat T1_al.nii -mask AUTO -classes 'CSF; GM; WM' -prefix Seg_T1
3dcopy Seg_T1/Classes+orig. Segment.nii










