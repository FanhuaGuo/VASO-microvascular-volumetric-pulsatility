#!/bin/bash 

subj='S01'
root_dir='/ifs/loni/groups/loft/FanhuaGuo/Experiment/Pulsatility_VASO2023'
raw_dir=$root_dir/raw/$subj
output_dir=$root_dir/analysis/$subj
# output_dir=$root_dir/SUMA/$subj/CBF
cd $output_dir
#####===================== whole brain 
prefix=T1warp_whole
fixed=templateT1.nii.gz
moving=T1_al.nii
base_mask=none
in_mask=none
base_mask_SyN=none
in_mask_SyN=none
antsRegistration -d 3 --float 1 --verbose \
      --output [ ${prefix}_, ${prefix}_fwd_warped.nii.gz, ${prefix}_inv_warped.nii.gz ] \
      --interpolation LanczosWindowedSinc \
      --collapse-output-transforms 1 \
      --initial-moving-transform [ ${fixed}, ${moving}, 1 ]  \
      --winsorize-image-intensities [0.005,0.995] \
      --use-histogram-matching \
      --transform translation[ 0.1 ] \
          --metric mattes[ ${fixed}, ${moving}, 1, 32, regular, 0.3 ] \
          --convergence [ 1000x300x100, 1e-6, 10 ]  \
          --smoothing-sigmas 4x2x1vox  \
          --shrink-factors 8x4x2 \
          --masks [ ${base_mask}, ${in_mask} ] \
      -t rigid[ 0.1 ] \
          -m mattes[ ${fixed}, ${moving}, 1, 32, regular, 0.3 ] \
          -c [ 1000x300x100, 1e-6, 10 ]  \
          -s 4x2x1vox  \
          -f 4x2x1  \
          -x [ ${base_mask}, ${in_mask} ] \
      -t affine[ 0.1 ] \
          -m mattes[ ${fixed}, ${moving}, 1, 32, regular, 0.3 ] \
          -c [ 1000x300x100, 1e-6, 10 ]  \
          -s 2x1x0vox  \
          -f 4x2x1  \
          -x [ ${base_mask}, ${in_mask} ] \
      -t SyN[ 0.1, 3, 0 ] \
          -m mattes[ ${fixed}, ${moving}, 0.5 , 32 ] \
          -m cc[ ${fixed}, ${moving}, 0.5 , 4 ] \
          -c [ 100x100x50, 1e-6, 10 ]  \
          -s 1x0.5x0vox  \
          -f 4x2x1  \
          -x [ ${base_mask_SyN}, ${in_mask_SyN} ]
          

ants2afniMatrix.py -i T1warp_whole_0GenericAffine.mat -o antsAffine_whole.1D

