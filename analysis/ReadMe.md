The analysis process is as follows:

mvPI:
1. First, use the code in SUMA.txt to complete the calculation of cortical depth, segmentation, vascular territory ROI extraction, data extraction in each ROI and other analysis operations.

2. Use the DisposalCBF_LP_Data.m file to calculate the CBF laminar profile based on the extracted CBF data for subsequent analysis.

3. Use the DisposalIndividualVASOData_compute_mvPI.m file to analyze the extracted data and calculate the main results (including mvPI, ΔVASO, ΔCBV and other values ​​and their laminar profile results, and output the mvPI maps)

4. Use the Group PI maps analysis.sh, compare_6subjs_test_retest_mvPImaps_computeMSE.m and compare_allsubjects_mvPImaps_computeMSE.m files to calculate the mean square error (MSE) between the 6 test-retests and the MSE between all subjects' mvPI maps




verify:
1. Use Reliability_Test.m to perform a non-parametric reliability test.

2. Use simulation_pulsatility_RI.m for simulation




4D-flow:
1. Use the Analysis_4Dflow.m code to calculate the velocity PI and volume PI of this location based on the extracted ROI data of each arterial site
