#!/bin/bash 
## batch code

##############========== transmit PI maps to MNI152 template
input_dir='/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/SUMA'
output_dir='/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/SUMA/GroupPImaps'
subjs=('S01' 'S02' 'S04' 'S06' 'S08' 'S09' 'S10' 'S11' 'S13' 'S14' 'S15' 'S16' 'S18' 'S19' 'S20' 'S21' 'S22' 'S23' 'S24' 'S25' 'S26' 'S27' 'S28')
session=1
for subj in ${subjs[@]} ; do
	cd ${input_dir}/${subj}/s${session}
	3dNwarpApply -master ${output_dir}/templateT1.nii.gz \
				-source PIMaps.rCBV.nii \
				-interp wsinc5 \
				-nwarp "T1warp_whole_1Warp.nii.gz antsAffine_whole.1D" \
				-prefix temp.nii -overwrite
    3dcalc -prefix ${output_dir}/${subj}_s${session}_PImaps.nii -a temp.nii -expr 'a' -overwrite
    rm -f temp.nii
done
wait


input_dir='/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/SUMA'
output_dir='/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/SUMA/GroupPImaps'
subjs=('S01' 'S02' 'S04' 'S09' 'S10' 'S11')
session=2
for subj in ${subjs[@]} ; do
	cd ${input_dir}/${subj}/s${session}
	3dNwarpApply -master ${output_dir}/templateT1.nii.gz \
				-source PIMaps.rCBV.nii \
				-interp wsinc5 \
				-nwarp "T1warp_whole_1Warp.nii.gz antsAffine_whole.1D" \
				-prefix temp.nii -overwrite
    3dcalc -prefix ${output_dir}/${subj}_s${session}_PImaps.nii -a temp.nii -expr 'a' -overwrite
    rm -f temp.nii
done
wait


##############========== 6 subjects test-retest MSE
output_dir='/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/SUMA/GroupPImaps'
cd ${output_dir}/
3dcalc -prefix Mask.nii -a templateT1.nii.gz -expr '1' -overwrite
session=1
subjs=('S01' 'S02' 'S04' 'S09' 'S10' 'S11') ## 'S21' 'S22' 'S23')
for subj in ${subjs[@]} ; do
    3dcalc -prefix Mask.nii -a Mask.nii -b ${subj}_s${session}_PImaps.nii -expr 'a*step(b)' -overwrite
done

session=2
subjs=('S01' 'S02' 'S04' 'S09' 'S10' 'S11')
for subj in ${subjs[@]} ; do
    3dcalc -prefix Mask.nii -a Mask.nii -b ${subj}_s${session}_PImaps.nii -expr 'a*step(b)' -overwrite
done

3dTcat -prefix tmp.nii -overwrite S01_s1_PImaps.nii S01_s2_PImaps.nii S02_s1_PImaps.nii S02_s2_PImaps.nii S04_s1_PImaps.nii S04_s2_PImaps.nii S09_s1_PImaps.nii S09_s2_PImaps.nii S10_s1_PImaps.nii S10_s2_PImaps.nii S11_s1_PImaps.nii S11_s2_PImaps.nii
rm -f compare_6subjs_PImaps.1D
3dmaskdump  -xyz  -o compare_6subjs_PImaps.1D  -mask Mask.nii  -noijk  tmp.nii -overwrite
rm -f tmp.nii



##############========== calculate all subjects mvPI maps MSE
subjs1=('S01' 'S02' 'S04' 'S06' 'S08' 'S09' 'S10' 'S11' 'S13' 'S14' 'S15' 'S16' 'S18' 'S19' 'S20' 'S21' 'S22' 'S23' 'S24' 'S25' 'S26' 'S27' 'S28')
subjs2=('S01' 'S02' 'S04' 'S06' 'S08' 'S09' 'S10' 'S11' 'S13' 'S14' 'S15' 'S16' 'S18' 'S19' 'S20' 'S21' 'S22' 'S23' 'S24' 'S25' 'S26' 'S27' 'S28')
session1=1
session2=1
for subj1 in ${subjs1[@]} ; do
for subj2 in ${subjs2[@]} ; do
3dcalc -prefix rm.mask.nii -a ${subj1}_s${session1}_PImaps.nii -b ${subj2}_s${session2}_PImaps.nii -expr 'step(a-0.01)*step(b-0.01)' -overwrite
3dcalc -prefix rm.SE.nii -a ${subj1}_s${session1}_PImaps.nii -b ${subj2}_s${session2}_PImaps.nii -expr '(a-b)^2' -overwrite
3dmaskave -q -mask rm.mask.nii rm.SE.nii > MSEdata/MSE_${subj1}s${session1}_${subj2}s${session2}.1D
rm -f rm.mask.nii
rm -f rm.SE.nii
done
wait
done
wait

subjs1=('S01' 'S02' 'S04' 'S09' 'S10' 'S11')
subjs2=('S01' 'S02' 'S04' 'S06' 'S08' 'S09' 'S10' 'S11' 'S13' 'S14' 'S15' 'S16' 'S18' 'S19' 'S20' 'S21' 'S22' 'S23' 'S24' 'S25' 'S26' 'S27' 'S28')
session1=2
session2=1
for subj1 in ${subjs1[@]} ; do
for subj2 in ${subjs2[@]} ; do
3dcalc -prefix rm.mask.nii -a ${subj1}_s${session1}_PImaps.nii -b ${subj2}_s${session2}_PImaps.nii -expr 'step(a-0.01)*step(b-0.01)' -overwrite
3dcalc -prefix rm.SE.nii -a ${subj1}_s${session1}_PImaps.nii -b ${subj2}_s${session2}_PImaps.nii -expr '(a-b)^2' -overwrite
3dmaskave -q -mask rm.mask.nii rm.SE.nii > MSEdata/MSE_${subj1}s${session1}_${subj2}s${session2}.1D
rm -f rm.mask.nii
rm -f rm.SE.nii
done
wait
done
wait

subjs1=('S01' 'S02' 'S04' 'S09' 'S10' 'S11')
subjs2=('S01' 'S02' 'S04' 'S09' 'S10' 'S11')
session1=2
session2=2
for subj1 in ${subjs1[@]} ; do
for subj2 in ${subjs2[@]} ; do
3dcalc -prefix rm.mask.nii -a ${subj1}_s${session1}_PImaps.nii -b ${subj2}_s${session2}_PImaps.nii -expr 'step(a-0.01)*step(b-0.01)' -overwrite
3dcalc -prefix rm.SE.nii -a ${subj1}_s${session1}_PImaps.nii -b ${subj2}_s${session2}_PImaps.nii -expr '(a-b)^2' -overwrite
3dmaskave -q -mask rm.mask.nii rm.SE.nii > MSEdata/MSE_${subj1}s${session1}_${subj2}s${session2}.1D
rm -f rm.mask.nii
rm -f rm.SE.nii
done
wait
done
wait




##############========== calculate density map
# young
subjs1=('S01' 'S02' 'S04' 'S06' 'S08' 'S09' 'S10' 'S11' 'S14' 'S15' 'S16')
subjs2=('S01' 'S02' 'S04' 'S09' 'S10' 'S11')
session1=1
session2=2
3dcalc -prefix rm.intensity.nii -a templateT1.nii.gz -expr '0' -overwrite
3dcalc -prefix rm.counts.nii -a templateT1.nii.gz -expr '0' -overwrite
3dcalc -prefix rm.densitycounts.nii -a templateT1.nii.gz -expr '0' -overwrite
for subj1 in ${subjs1[@]} ; do
	3dcalc -prefix rm.counts.nii -a ${subj1}_s${session1}_PImaps.nii -b rm.counts.nii -expr 'b+step(a-0.001)' -overwrite
	3dcalc -prefix rm.densitycounts.nii -a ${subj1}_s${session1}_PImaps.nii -b rm.densitycounts.nii -expr 'b+step(a-0.5)' -overwrite
	3dcalc -prefix rm.intensity.nii -a ${subj1}_s${session1}_PImaps.nii -b rm.intensity.nii -expr 'b+step(a-0.001)*a' -overwrite
done
wait

for subj2 in ${subjs2[@]} ; do
	3dcalc -prefix rm.counts.nii -a ${subj2}_s${session2}_PImaps.nii -b rm.counts.nii -expr 'b+step(a-0.001)' -overwrite
	3dcalc -prefix rm.densitycounts.nii -a ${subj2}_s${session2}_PImaps.nii -b rm.densitycounts.nii -expr 'b+step(a-0.5)' -overwrite
	3dcalc -prefix rm.intensity.nii -a ${subj2}_s${session2}_PImaps.nii -b rm.intensity.nii -expr 'b+step(a-0.001)*a' -overwrite
done
wait

3dcalc -prefix MeanIntensity_young.nii -a rm.counts.nii -b rm.intensity.nii -expr 'b/a*step(a-4)' -overwrite
3dcalc -prefix HighDensity_young.nii -a rm.counts.nii -b rm.densitycounts.nii -expr 'b/a*step(a-4)' -overwrite

rm -f rm*


# older
subjs1=('S13' 'S18' 'S19' 'S20' 'S21' 'S22' 'S23' 'S24' 'S25' 'S26' 'S27' 'S28')
session1=1
3dcalc -prefix rm.intensity.nii -a templateT1.nii.gz -expr '0' -overwrite
3dcalc -prefix rm.counts.nii -a templateT1.nii.gz -expr '0' -overwrite
3dcalc -prefix rm.densitycounts.nii -a templateT1.nii.gz -expr '0' -overwrite
for subj1 in ${subjs1[@]} ; do
	3dcalc -prefix rm.counts.nii -a ${subj1}_s${session1}_PImaps.nii -b rm.counts.nii -expr 'b+step(a-0.001)' -overwrite
	3dcalc -prefix rm.densitycounts.nii -a ${subj1}_s${session1}_PImaps.nii -b rm.densitycounts.nii -expr 'b+step(a-0.5)' -overwrite
	3dcalc -prefix rm.intensity.nii -a ${subj1}_s${session1}_PImaps.nii -b rm.intensity.nii -expr 'b+step(a-0.001)*a' -overwrite
done
wait

3dcalc -prefix MeanIntensity_older.nii -a rm.counts.nii -b rm.intensity.nii -expr 'b/a'*step(a-3) -overwrite
3dcalc -prefix HighDensity_older.nii -a rm.counts.nii -b rm.densitycounts.nii -expr 'b/a*step(a-3)' -overwrite

rm -f rm*


# both
subjs1=('S01' 'S02' 'S04' 'S06' 'S08' 'S09' 'S10' 'S11' 'S14' 'S15' 'S16' 'S13' 'S18' 'S19' 'S20' 'S21' 'S22' 'S23' 'S24' 'S25' 'S26' 'S27' 'S28')
subjs2=('S01' 'S02' 'S04' 'S09' 'S10' 'S11')
session1=1
session2=2
3dcalc -prefix rm.intensity.nii -a templateT1.nii.gz -expr '0' -overwrite
3dcalc -prefix rm.counts.nii -a templateT1.nii.gz -expr '0' -overwrite
3dcalc -prefix rm.densitycounts.nii -a templateT1.nii.gz -expr '0' -overwrite
for subj1 in ${subjs1[@]} ; do
	3dcalc -prefix rm.counts.nii -a ${subj1}_s${session1}_PImaps.nii -b rm.counts.nii -expr 'b+step(a-0.001)' -overwrite
	3dcalc -prefix rm.densitycounts.nii -a ${subj1}_s${session1}_PImaps.nii -b rm.densitycounts.nii -expr 'b+step(a-0.6)' -overwrite
	3dcalc -prefix rm.intensity.nii -a ${subj1}_s${session1}_PImaps.nii -b rm.intensity.nii -expr 'b+step(a-0.001)*a' -overwrite
done
wait

for subj2 in ${subjs2[@]} ; do
	3dcalc -prefix rm.counts.nii -a ${subj2}_s${session2}_PImaps.nii -b rm.counts.nii -expr 'b+step(a-0.001)' -overwrite
	3dcalc -prefix rm.densitycounts.nii -a ${subj2}_s${session2}_PImaps.nii -b rm.densitycounts.nii -expr 'b+step(a-0.6)' -overwrite
	3dcalc -prefix rm.intensity.nii -a ${subj2}_s${session2}_PImaps.nii -b rm.intensity.nii -expr 'b+step(a-0.001)*a' -overwrite
done
wait

3dcalc -prefix MeanIntensity.nii -a rm.counts.nii -b rm.intensity.nii -expr 'b/a*step(a-10)' -overwrite
3dcalc -prefix HighDensity.nii -a rm.counts.nii -b rm.densitycounts.nii -expr 'b/a*step(a-10)' -overwrite

rm -f rm*



# display
3drotate -prefix T1show.nii -rotate 20 0 0 templateT1.nii.gz -overwrite
# 3dSeg -anat T1show.nii -mask AUTO -classes 'CSF[0.1] ; GM[0.4] ; WM[0.5]' -prefix Seg_T1_whole
3dcalc -prefix SegmentWhole.nii -a Seg_T1_whole/Posterior+orig'[0]' -b Seg_T1_whole/Posterior+orig'[1]' -c Seg_T1_whole/Posterior+orig'[2]' -expr 'step(a-0.85)+step(c-0.5)*3+step(b-0.1)*step(0.85-a)*step(0.5-c)*2' -overwrite
3dcalc -prefix rm.WM.nii -a Seg_T1_whole/Posterior+orig'[2]' -expr 'step(a-0.9)' -overwrite
for label in MeanIntensity_older HighDensity_older MeanIntensity_young HighDensity_young MeanIntensity HighDensity ; do
	3drotate -prefix ${label}show.nii -rotate 20 0 0 ${label}.nii -overwrite
	3dcalc -prefix ${label}show.nii -a ${label}show.nii -expr 'a*step(a-0.05)' -overwrite
	3dcalc -prefix ${label}showWM.nii -a ${label}show.nii -b rm.WM.nii -expr 'a*step(a-0.05)*step(b)' -overwrite
done




