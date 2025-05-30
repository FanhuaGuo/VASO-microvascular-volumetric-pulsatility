#!/bin/tcsh

# Usage: tcsh batch_qcc_recon-all.sh QianCC | tee QianCC.log
# Example 1) Averaged, high resolution (0.7 iso), T1_div_PD_fused/MP2RAGE_ns volume:

# 2017-05-09: Created by Chencan Qian

# We would like to thank Associate Researcher Qian Chencan from the Institute of Biophysics, Chinese Academy of Sciences

# tic
echo "execution started: `date +%Y-%m-%d\ %H:%M:%S`"
set script_start = `date +%s`

## ==================== Set up
# source ~/PythonPlus/sources/mripy/scripts/switch_python.csh default

set subj = S01
set input = "T1"
set is_hires = 1
set k = 0
while ( $k < $#argv )
    @ k += 1
    switch ( $argv[$k] )
        case -i:
            @ k += 1
            set input = $argv[$k]
            breaksw
        case --normres:
            set is_hires = 0
            breaksw
        default:
            set subj = $argv[$k]
    endsw
end
if ( $subj == None ) then
    echo "Usage: source batch_qcc_recon-all.sh <subj>"
else
    echo $subj
endif

set root_dir = `pwd`
set subj_dir = $root_dir/$subj
if ( $is_hires ) then
    setenv SUBJECTS_DIR "$root_dir/fs_hires"
else
    setenv SUBJECTS_DIR "$root_dir/fs_surface"
endif
mkdir $SUBJECTS_DIR

## ==================== recon-all
set anat_prefix = "$subj_dir/$input"
# 3dAFNItoNIFTI -prefix $anat_prefix -overwrite $anat_prefix+orig

if ( $is_hires ) then
    set expert_file = $subj_dir/expert_options.txt
    echo "mris_inflate -n 18" > $expert_file

    recon-all -s $subj -i $anat_prefix.nii \
        -all -hires -expert $expert_file \
        -parallel -openmp 20 \
        | tee $subj_dir/$subj.log
else
    recon-all -s $subj -i $anat_prefix.nii \
        -all -parallel -openmp 24 \
        | tee $subj_dir/$subj.log
endif

## ==================== Create SUMA folder
# TODO: Shall I use -neuro so that left is left?
@SUMA_Make_Spec_FS -sid $subj -fspath $SUBJECTS_DIR/$subj
# Create viewing script
set SUMA_path = $SUBJECTS_DIR/$subj/SUMA
set surf = $SUMA_path/$subj
set viewing_script = "$SUMA_path/run_suma"
echo "afni -niml &" > $viewing_script
echo "suma -spec ${subj}_both.spec -sv ${subj}_SurfVol+orig &" >> $viewing_script
cd $SUMA_path

## ==================== Finalize
# Remove temporary files
# rm -f rm.*

# toc
echo "execution finished: `date +%Y-%m-%d\ %H:%M:%S`"
set script_end = `date +%s`
@ duration = $script_end - $script_start
@ h = $duration / 3600
@ m = $duration % 3600 / 60
@ s = $duration % 60
printf "%d hr %d min %d sec elapsed.\n" $h $m $s
