The preprocessing process is as follows:

1. First, use the DisposalRawData_acq.m and DisposalPulsatilityData.m files to extract the pulse signal collected by Biopac and find the positions of all peaks. Then define the cardiac phase, and define the cardiac phase of each image according to the trigger time of the recorded acquisition image.

2. The VASO signal preprocessing is performed using the batch_VASO.sh file. It should be noted that due to the different cardiac phase information of each subject, the code of the combine phase process needs to be replaced according to the code output by the DisposalPulsatilityData.m file.

3. Use the SUMA_recon_Surface_Prepare.sh file to perform the FreeSurfer cortical reconstruction process to prepare for the subsequent segmentation and calculation of cortical depth values.

4. Use the align_standardbrain.sh and ants2afniMatrix.py files to calculate the nonlinear registration of the structural image of the individual subject and the MNI template brain to prepare for subsequent vascular territory segmentation.

5. 4D-flow processing requires the use of AFNI (other software can also be used) to manually select each target site and intercept the spherical ROI in preparation for subsequent analysis.
