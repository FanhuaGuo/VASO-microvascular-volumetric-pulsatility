#!/bin/bash 
## batch code

# # Specify subject identifier
subj='S01_4D'
root_dir='/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023'
raw_dir=$root_dir/raw/$subj
output_dir=$root_dir/analysis/$subj
mkdir $output_dir

cd $output_dir




## ==================== compute the velocity =========================
for phase in 1 2 3 ; do    
    3dcalc -prefix velocity.P${phase}.nii -a 4DflowP${phase}.nii -expr '200*a/4096-100' -overwrite
done
3dcalc -prefix velocity.nii -a velocity.P1.nii -b velocity.P2.nii -c velocity.P3.nii -expr 'sqrt(a^2+b^2+c^2)' -overwrite


## ==================== try to draw the vessel mask =========================
3dTstat -prefix rm.max.M.nii -overwrite -max 4DflowM.nii
3dTstat -prefix rm.min.M.nii -overwrite -min 4DflowM.nii
3dcalc -prefix vessel_mask.nii -a rm.max.M.nii -b rm.min.M.nii -c 4DflowM_mean.nii -expr 'step(step(a-b-c/20)*step(a-b-50)+step(c-800))' -overwrite



##################### draw ROI manually and then: #####################
3dresample  -dxyz 0.4 0.4 0.4   -rmode Cu  -prefix 4DflowM.resample.nii  -input 4DflowM.nii  -overwrite
3dresample  -master 4DflowM.resample.nii   -rmode Cu  -prefix velocity.P1.resample.nii  -input velocity.P1.nii  -overwrite
3dresample  -master 4DflowM.resample.nii   -rmode Cu  -prefix velocity.P2.resample.nii  -input velocity.P2.nii  -overwrite
3dresample  -master 4DflowM.resample.nii   -rmode Cu  -prefix velocity.P3.resample.nii  -input velocity.P3.nii  -overwrite
label1='resample'
label2='.resample'

## ==================== change to nifiti =========================
for vessel in ICA MCA PCA ; do
    3dresample  -master 4DflowM.resample.nii   -rmode NN  -prefix Mask_lh_${vessel}1.nii  -input Mask_lh_${vessel}1+orig  -overwrite
    3dcalc -prefix Mask_lh_${vessel}1.nii -a Mask_lh_${vessel}1.nii -expr 'step(a-0.8)' -overwrite
    3dresample  -master 4DflowM.resample.nii   -rmode NN  -prefix Mask_rh_${vessel}1.nii  -input Mask_rh_${vessel}1+orig  -overwrite
    3dcalc -prefix Mask_rh_${vessel}1.nii -a Mask_rh_${vessel}1.nii -expr 'step(a-0.8)' -overwrite
    # 3dAFNItoNIFTI -prefix Mask_lh_${vessel}1  Mask_lh_${vessel}1+orig. -overwrite
    # 3dAFNItoNIFTI -prefix Mask_rh_${vessel}1  Mask_rh_${vessel}1+orig. -overwrite
done
wait

for vessel in ICA MCA PCA ; do    
    3dresample  -master 4DflowM.resample.nii   -rmode NN  -prefix Mask_lh_${vessel}2.nii  -input Mask_lh_${vessel}2+orig  -overwrite
    3dcalc -prefix Mask_lh_${vessel}2.nii -a Mask_lh_${vessel}2.nii -expr 'step(a-0.8)' -overwrite
    3dresample  -master 4DflowM.resample.nii   -rmode NN  -prefix Mask_rh_${vessel}2.nii  -input Mask_rh_${vessel}2+orig  -overwrite
    3dcalc -prefix Mask_rh_${vessel}2.nii -a Mask_rh_${vessel}2.nii -expr 'step(a-0.8)' -overwrite
    # 3dAFNItoNIFTI -prefix Mask_lh_${vessel}2  Mask_lh_${vessel}2+orig. -overwrite
    # 3dAFNItoNIFTI -prefix Mask_rh_${vessel}2  Mask_rh_${vessel}2+orig. -overwrite
done
wait

for vessel in MCA ; do    
    3dresample  -master 4DflowM.resample.nii   -rmode NN  -prefix Mask_lh_${vessel}3.nii  -input Mask_lh_${vessel}3+orig  -overwrite
    3dcalc -prefix Mask_lh_${vessel}3.nii -a Mask_lh_${vessel}3.nii -expr 'step(a-0.8)' -overwrite
    3dresample  -master 4DflowM.resample.nii   -rmode NN  -prefix Mask_rh_${vessel}3.nii  -input Mask_rh_${vessel}3+orig  -overwrite
    3dcalc -prefix Mask_rh_${vessel}3.nii -a Mask_rh_${vessel}3.nii -expr 'step(a-0.8)' -overwrite
    # 3dAFNItoNIFTI -prefix Mask_lh_${vessel}3  Mask_lh_${vessel}3+orig. -overwrite
    # 3dAFNItoNIFTI -prefix Mask_rh_${vessel}3  Mask_rh_${vessel}3+orig. -overwrite
done
wait

3dresample  -master 4DflowM.resample.nii   -rmode NN  -prefix Mask_ACA.nii  -input Mask_ACA+orig  -overwrite
3dcalc -prefix Mask_ACA.nii -a Mask_ACA.nii -expr 'step(a-0.8)' -overwrite
# 3dAFNItoNIFTI -prefix Mask_ACA  Mask_ACA+orig. -overwrite

## ==================== dump to 1D =========================
for vessel in ICA MCA PCA ; do
    rm -f 4DflowM.lh.${vessel}1.1D
    rm -f 4DflowM.rh.${vessel}1.1D
    3dmaskdump -xyz -o 4DflowM.lh.${vessel}1.1D -mask Mask_lh_${vessel}1.nii -noijk 4DflowM.${label1}.nii -overwrite
    3dmaskdump -xyz -o 4DflowM.rh.${vessel}1.1D -mask Mask_rh_${vessel}1.nii -noijk 4DflowM.${label1}.nii -overwrite
    for label in P1 P2 P3 ; do
    rm -f ${label}
        rm -f 4Dflow${label}.lh.${vessel}1.1D
        rm -f 4Dflow${label}.rh.${vessel}1.1D
        3dmaskdump -xyz -o 4Dflow${label}.lh.${vessel}1.1D -mask Mask_lh_${vessel}1.nii -noijk velocity.${label}${label2}.nii -overwrite
        3dmaskdump -xyz -o 4Dflow${label}.rh.${vessel}1.1D -mask Mask_rh_${vessel}1.nii -noijk velocity.${label}${label2}.nii -overwrite
    done
done
wait

for vessel in ICA MCA PCA ; do
    rm -f 4DflowM.lh.${vessel}2.1D
    rm -f 4DflowM.rh.${vessel}2.1D
    3dmaskdump -xyz -o 4DflowM.lh.${vessel}2.1D -mask Mask_lh_${vessel}2.nii -noijk 4DflowM.${label1}.nii -overwrite
    3dmaskdump -xyz -o 4DflowM.rh.${vessel}2.1D -mask Mask_rh_${vessel}2.nii -noijk 4DflowM.${label1}.nii -overwrite
    for label in P1 P2 P3 ; do
    rm -f ${label}
        rm -f 4Dflow${label}.lh.${vessel}2.1D
        rm -f 4Dflow${label}.rh.${vessel}2.1D
        3dmaskdump -xyz -o 4Dflow${label}.lh.${vessel}2.1D -mask Mask_lh_${vessel}2.nii -noijk velocity.${label}${label2}.nii -overwrite
        3dmaskdump -xyz -o 4Dflow${label}.rh.${vessel}2.1D -mask Mask_rh_${vessel}2.nii -noijk velocity.${label}${label2}.nii -overwrite
    done
done
wait

for vessel in MCA ; do
    rm -f 4DflowM.lh.${vessel}3.1D
    rm -f 4DflowM.rh.${vessel}3.1D
    3dmaskdump -xyz -o 4DflowM.lh.${vessel}3.1D -mask Mask_lh_${vessel}3.nii -noijk 4DflowM.${label1}.nii -overwrite
    3dmaskdump -xyz -o 4DflowM.rh.${vessel}3.1D -mask Mask_rh_${vessel}3.nii -noijk 4DflowM.${label1}.nii -overwrite
    for label in P1 P2 P3 ; do
    rm -f ${label}
        rm -f 4Dflow${label}.lh.${vessel}3.1D
        rm -f 4Dflow${label}.rh.${vessel}3.1D
        3dmaskdump -xyz -o 4Dflow${label}.lh.${vessel}3.1D -mask Mask_lh_${vessel}3.nii -noijk velocity.${label}${label2}.nii -overwrite
        3dmaskdump -xyz -o 4Dflow${label}.rh.${vessel}3.1D -mask Mask_rh_${vessel}3.nii -noijk velocity.${label}${label2}.nii -overwrite
    done
done
wait

rm -f 4DflowM.ACA.1D
3dmaskdump -xyz -o 4DflowM.ACA.1D -mask Mask_ACA.nii -noijk 4DflowM.${label1}.nii -overwrite
for label in P1 P2 P3 ; do
    rm -f 4Dflow${label}.ACA.1D
    3dmaskdump -xyz -o 4Dflow${label}.ACA.1D -mask Mask_ACA.nii -noijk velocity.${label}${label2}.nii -overwrite
done
wait


rm -f Mask_*.nii
rm -f 4DflowM.resample.nii
rm -f velocity.P*.resample.nii










