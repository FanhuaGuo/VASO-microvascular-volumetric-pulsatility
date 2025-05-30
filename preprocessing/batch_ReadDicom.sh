#!/bin/bash 
## batch code

# # Specify folder and subject identifier
subj='S01'
root_dir='/ifs/loni/groups/loft/FanhuaGuo/Experiment/Pulsatility_VASO2023'
raw_dir=$root_dir/raw/$subj
output_dir=$root_dir/analysis/$subj
runs=(`count -digits 2 1 2`)
mkdir $output_dir

cd $output_dir

##################### read MP2RAGE data #####################
# which_T1=MP2RAGE_INV1
# file=`ls ${raw_dir}/${which_T1}/*IMA | sed -n '1p'`
# suffix=`dicom_hdr ${file} | grep 'ID Series Description' | awk -F // '{print $3}' | sed s/'t1w_mp2rage_0.70iso_'/''/g`
# cd ${raw_dir}/${which_T1}
# uniq_images *.IMA > uniq_image_list.txt
# Dimon -infile_list uniq_image_list.txt \
#     -gert_create_dataset \
#     -gert_outdir ${output_dir} \
#     -gert_to3d_prefix T1_${suffix} -overwrite \
#     -dicom_org \
#     -use_obl_origin \
#     -save_details Dimon.details \
#     -gert_quit_on_err


which_T1=MP2RAGE_INV2
file=`ls ${raw_dir}/${which_T1}/*IMA | sed -n '1p'`
suffix=`dicom_hdr ${file} | grep 'ID Series Description' | awk -F // '{print $3}' | sed s/'t1w_mp2rage_0.70iso_'/''/g`
cd ${raw_dir}/${which_T1}
uniq_images *.IMA > uniq_image_list.txt
Dimon -infile_list uniq_image_list.txt \
    -gert_create_dataset \
    -gert_outdir ${output_dir} \
    -gert_to3d_prefix T1_${suffix} -overwrite \
    -dicom_org \
    -use_obl_origin \
    -save_details Dimon.details \
    -gert_quit_on_err


which_T1=MP2RAGE_UNI
file=`ls ${raw_dir}/${which_T1}/*IMA | sed -n '1p'`
suffix=`dicom_hdr ${file} | grep 'ID Series Description' | awk -F // '{print $3}' | sed s/'t1w_mp2rage_0.70iso_'/''/g`
cd ${raw_dir}/${which_T1}
uniq_images *.IMA > uniq_image_list.txt
Dimon -infile_list uniq_image_list.txt \
    -gert_create_dataset \
    -gert_outdir ${output_dir} \
    -gert_to3d_prefix T1_${suffix} -overwrite \
    -dicom_org \
    -use_obl_origin \
    -save_details Dimon.details \
    -gert_quit_on_err


which_T1=MP2RAGE_T1
file=`ls ${raw_dir}/${which_T1}/*IMA | sed -n '1p'`
suffix=`dicom_hdr ${file} | grep 'ID Series Description' | awk -F // '{print $3}' | sed s/'t1w_mp2rage_0.70iso_'/''/g`
cd ${raw_dir}/${which_T1}
uniq_images *.IMA > uniq_image_list.txt
Dimon -infile_list uniq_image_list.txt \
    -gert_create_dataset \
    -gert_outdir ${output_dir} \
    -gert_to3d_prefix T1_${suffix} -overwrite \
    -dicom_org \
    -use_obl_origin \
    -save_details Dimon.details \
    -gert_quit_on_err


cd $output_dir


3dSkullStrip -orig_vol -prefix T1_mp2rage_sag_p3_0.70mm_INV2_ns+orig -overwrite -input T1_mp2rage_sag_p3_0.70mm_INV2+orig -overwrite
3dAutomask -dilate 1 -prefix T1mask -overwrite T1_mp2rage_sag_p3_0.70mm_INV2_ns+orig 
3dcalc -a T1mask+orig -b T1_mp2rage_sag_p3_0.70mm_UNI_Images+orig -expr 'a*b' -prefix T1.nii -overwrite
3dcalc -a T1mask+orig -b T1_mp2rage_sag_p3_0.70mm_T1_Images+orig -expr 'a*b' -prefix T1_T1value.nii -overwrite
# 3dAFNItoNIFTI -prefix T1_T1value.nii  -overwrite  T1_mp2rage_sag_p3_0.70mm_T1_Images+orig
rm T1*+orig*


##################### read VASO data #####################
cdAndDimon(){
  cd $1
  uniq_images *.IMA > uniq_image_list.txt
  Dimon -infile_list uniq_image_list.txt \
      -gert_create_dataset \
      -gert_outdir $2 \
      -gert_to3d_prefix $3 -overwrite \
      -dicom_org \
      -use_obl_origin \
      -save_details Dimon.details \
      -gert_quit_on_err
}

cdAndDimon ${raw_dir}/VASO01 ${output_dir} VASO01
cdAndDimon ${raw_dir}/BOLD01 ${output_dir} BOLD01
cdAndDimon ${raw_dir}/VASO02 ${output_dir} VASO02
cdAndDimon ${raw_dir}/BOLD02 ${output_dir} BOLD02



##################### read 4D-flow data #####################
cdAndDimon ${raw_dir}/4DflowM ${output_dir} 4DflowM
cdAndDimon ${raw_dir}/4DflowP1 ${output_dir} 4DflowP1
cdAndDimon ${raw_dir}/4DflowP2 ${output_dir} 4DflowP2
cdAndDimon ${raw_dir}/4DflowP3 ${output_dir} 4DflowP3




