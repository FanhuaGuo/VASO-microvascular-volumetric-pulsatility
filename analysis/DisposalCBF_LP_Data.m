clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

% The purpose of this program is to disposal the VASO data to compute pulsatility index or some other things.
% LP: laminar profile
% TS: time series
% VT: vascular territory

%% set some parameters
subj = 'S01';
pwd_dir = '/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/';
input_dir = [pwd_dir 'analysis/group/' subj];
NumLayers = 6;
roiRegions = {'GMCSF'};
roiReg = 1;
roiRegion = roiRegions{roiReg};


%% read data
% load MRI data
depth = load([input_dir '/depth.rROI.' roiRegion '.CBF.1D']);
Data = load([input_dir '/rROI.' roiRegion '.CBF.TS.1D']);
Mask_GM = load([input_dir '/rROI.' roiRegion '.CBF.VTmask.1D']);

if roiReg == 1
    Data_WMs = load([input_dir '/rROI.WMs.CBF.TS.1D']);
    Data_WMd = load([input_dir '/rROI.WMd.CBF.TS.1D']);
    Mask_WMs = load([input_dir '/rROI.WMs.CBF.VTmask.1D']);
    Mask_WMd = load([input_dir '/rROI.WMd.CBF.VTmask.1D']);
end

%% compute the layer profile
% whole brain
Pointer_depth = depth(:,4);
Data_CBF = Data(:,4);
LP_CBF = []; 
LP_CBF = [LP_CBF; mean(Data_WMd(:,4),1); mean(Data_WMs(:,4),1)];
for i = 1:NumLayers
    tempROI = (Pointer_depth>(i-1)/NumLayers)&(Pointer_depth<=i/NumLayers);
    LP_CBF = [LP_CBF; mean(Data_CBF(tempROI),1)];
end
tempROI = (Pointer_depth>1)&(Pointer_depth<1.15);
LP_CBF = [LP_CBF; mean(Data_CBF(tempROI),1)];

save([input_dir '/rROI.whole.CBF.LP_CBF.' num2str(NumLayers) 'layers.mat'],'LP_CBF');



% ACA/MCA/PCA LP
NameVTmasks = {'ACA','MCA','PCA'};
for roi = 1:3
    LP_CBF = []; 
    LP_CBF = [LP_CBF; mean(Data_WMd(Mask_WMd(:,4)==roi,4),1); mean(Data_WMs(Mask_WMs(:,4)==roi,4),1)];
    for i = 1:NumLayers
        tempROI = (Pointer_depth>(i-1)/NumLayers)&(Pointer_depth<=i/NumLayers)&(Mask_GM(:,4)==roi);
        LP_CBF = [LP_CBF; mean(Data_CBF(tempROI),1)];
    end
    tempROI = (Pointer_depth>1)&(Pointer_depth<1.15)&(Mask_GM(:,4)==roi);
    LP_CBF = [LP_CBF; mean(Data_CBF(tempROI),1)];
    save([input_dir '/rROI.' NameVTmasks{roi} '.CBF.LP_CBF.' num2str(NumLayers) 'layers.mat'],'LP_CBF');
end
    
    


