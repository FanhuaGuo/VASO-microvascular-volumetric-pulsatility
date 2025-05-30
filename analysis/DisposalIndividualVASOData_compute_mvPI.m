clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

% The purpose of this program is to disposal the VASO data to compute pulsatility index or some other things.

%% set some parameters
subj = 'S01';
which_session = 2;
pwd_dir = '/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/';
input_dir = [pwd_dir 'analysis/group/' subj];
NumPhase = 10;
NumLayers = 6;
which_regions = {'.whole','.ACA','.MCA','.PCA','.smooth'}; 
which_region = 1;
NameRegion = which_regions{which_region};

ifDrawDataProfile = 1;
ifSaveFWHM = 0;
ifSaveLPCompliance = 0;
ifundump = 1;

%% read data
% load MRI data
depth = load([input_dir '/depth.rROI.GMCSF.s' num2str(which_session) NameRegion '.1D']);

Data_VASO = load([input_dir '/rROI.GMCSF.VASO01.s' num2str(which_session) '.TS' NameRegion '.1D']);
tmp = load([input_dir '/rROI.GMCSF.VASO02.s' num2str(which_session) '.TS' NameRegion '.1D']);
Data_VASO = (Data_VASO+tmp)/2;
Data_BOLD = load([input_dir '/rROI.GMCSF.BOLD01.s' num2str(which_session) '.TS' NameRegion '.1D']);
tmp = load([input_dir '/rROI.GMCSF.BOLD02.s' num2str(which_session) '.TS' NameRegion '.1D']);
Data_BOLD = (Data_BOLD+tmp)/2;

WMs_VASO = load([input_dir '/rROI.WMs.VASO01.s' num2str(which_session) '.TS' NameRegion '.1D']);
tmp = load([input_dir '/rROI.WMs.VASO02.s' num2str(which_session) '.TS' NameRegion '.1D']);
WMs_VASO = (WMs_VASO+tmp)/2;
WMs_BOLD = load([input_dir '/rROI.WMs.BOLD01.s' num2str(which_session) '.TS' NameRegion '.1D']);
tmp = load([input_dir '/rROI.WMs.BOLD02.s' num2str(which_session) '.TS' NameRegion '.1D']);
WMs_BOLD = (WMs_BOLD+tmp)/2;

WMd_VASO = load([input_dir '/rROI.WMd.VASO01.s' num2str(which_session) '.TS' NameRegion '.1D']);
tmp = load([input_dir '/rROI.WMd.VASO02.s' num2str(which_session) '.TS' NameRegion '.1D']);
WMd_VASO = (WMd_VASO+tmp)/2;
WMd_BOLD = load([input_dir '/rROI.WMd.BOLD01.s' num2str(which_session) '.TS' NameRegion '.1D']);
tmp = load([input_dir '/rROI.WMd.BOLD02.s' num2str(which_session) '.TS' NameRegion '.1D']);
WMd_BOLD = (WMd_BOLD+tmp)/2;


% load CBF data
load([input_dir '/rROI.whole.CBF.LP_CBF.' num2str(NumLayers) 'layers.mat']);



%% compute the layer TS

Pointer_depth = depth(:,4);
Data_TS = Data_VASO(:,4:end);
LP_TS = [mean(WMd_VASO(:,4:end)); mean(WMs_VASO(:,4:end))]; 
for i = 1:NumLayers
    tempROI = (Pointer_depth>(i-1)/NumLayers)&(Pointer_depth<=i/NumLayers);
    LP_TS = [LP_TS; mean(Data_TS(tempROI,:),1)];
end
tempROI = (Pointer_depth>1)&(Pointer_depth<1.15);
LP_TS = [LP_TS; mean(Data_TS(tempROI,:),1)];
LP_TS_VASO = LP_TS;


Pointer_depth = depth(:,4);
Data_TS = Data_BOLD(:,4:end);
LP_TS = [mean(WMd_BOLD(:,4:end)); mean(WMs_BOLD(:,4:end))]; 
for i = 1:NumLayers
    tempROI = (Pointer_depth>(i-1)/NumLayers)&(Pointer_depth<=i/NumLayers);
    LP_TS = [LP_TS; mean(Data_TS(tempROI,:),1)];
end
tempROI = (Pointer_depth>1)&(Pointer_depth<1.15);
LP_TS = [LP_TS; mean(Data_TS(tempROI,:),1)];
LP_TS_BOLD = LP_TS;


LP_TS = LP_TS_VASO./LP_TS_BOLD;

%% draw the profile of data
if ifDrawDataProfile
    % draw layer-profile
    colors = [[zeros(1,5) 0:55:250]' [0:55:250 250:-50:1]' [250:-50:1 zeros(1,5)]']/255;
    legend_label = {};
    for i = 1:NumPhase
        legend_label = {legend_label{:}, ['Phase' num2str(i)]};
    end
    LineWidth = 1.5;

    figure; 
    subplot(1,2,1); hold on;
    for i = 1:NumPhase
        plot(LP_TS(:,i),'-','Color',colors(i,:),'linewidth',LineWidth);
    end
    set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
    xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
    ylabel(['VASO signal'],'FontSize',16);
    title('phase-profile of VASO','FontSize',16);
    legend(legend_label,'EdgeColor','w','FontSize',16);
    box off

    legend_label = {'WMd','WMs'};
    for i = 1:NumLayers
        legend_label = {legend_label{:}, ['Depth' num2str(i)]};
    end
    legend_label = {legend_label{:}, 'CSF'};
    subplot(1,2,2); hold on;
    for i = 1:NumLayers+3
        plot(LP_TS(i,:)/mean(LP_TS(i,:)),'-','Color',colors(i,:),'linewidth',LineWidth);
    end
    set(gca,'xlim',[0.5 NumPhase+0.5],'xTick',[1:NumPhase],'FontSize',16);
    xlabel(['Cardio-Phase'],'FontSize',16);
    ylabel(['VASO signal'],'FontSize',16);
    title('layer-profile of VASO','FontSize',16);
    legend(legend_label,'EdgeColor','w','FontSize',16);
    box off
%     save('/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/Draft/figure/PlotCode/figure1D_CardioPhaseProfile_DifferentDepth.mat','legend_label','LP_TS','colors');

end

if ifSaveFWHM
%     save([input_dir '/rROI.whole.PhaseProfile.' NameRegion '.mat'],'LP_TS','LP_TS_VASO','LP_TS_BOLD');
end

%% hypothesis 1  all CBV0=5%
colors = [[zeros(1,5) 0:55:250]' [0:55:250 250:-50:1]' [250:-50:1 zeros(1,5)]']/255;
LineWidth = 1.5;

LP_Normalized = LP_TS./mean(LP_TS,2);
rCBV = 20-19*LP_Normalized;
deltarCBV = [];
deltaNorVASO = [];
deltaVASOo = [];
deltaBOLD = [];
for i = 1:size(rCBV,1)
    deltarCBV = [deltarCBV; max(rCBV(i,:))-min(rCBV(i,:))];
    deltaNorVASO = [deltaNorVASO; max(LP_Normalized(i,:))-min(LP_Normalized(i,:))];
    deltaVASOo = [deltaVASOo; max(LP_TS_VASO(i,:))-min(LP_TS_VASO(i,:))];
    deltaBOLD = [deltaBOLD; max(LP_TS_BOLD(i,:))-min(LP_TS_BOLD(i,:))];
end

clear LP_Compliance
LP_Compliance{1} = deltaNorVASO;
LP_Compliance{2} = deltarCBV;

figure; 
subplot(2,6,3); hold on;
plot(deltarCBV,'-','Color',colors(1,:),'linewidth',LineWidth);
set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['rCBV'],'FontSize',16);
title('ΔrCBV with constant CBV0','FontSize',16);
box off
subplot(2,6,2); hold on;
plot(deltaNorVASO,'-','Color',colors(1,:),'linewidth',LineWidth);
set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['normalized VASO signal'],'FontSize',16);
title('ΔVASO','FontSize',16);
box off

subplot(2,6,1); hold on;
plot(deltaVASOo,'-','Color',colors(1,:),'linewidth',LineWidth);
plot(deltaBOLD,'-','Color',colors(10,:),'linewidth',LineWidth);
set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['normalized VASO signal'],'FontSize',16);
title('ΔVASO','FontSize',16);
legend({'Orig VASO','BOLD'},'EdgeColor','w','FontSize',16);
box off



%% hypothesis 2  trend CBV0 = trend CBF0
% CBV0~CBF
LP_Normalized = LP_TS./mean(LP_TS,2);
assumeCBV0 = 0.055;
correctMTT = 0;
if correctMTT
    calibration = LP_CBF.*assume_MTT;
else
    calibration = LP_CBF;
end
CBV0 = assumeCBV0/mean(calibration(3:end-1))*calibration;
CBV0_orig = CBV0;

% save('/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/Draft/figure/PlotCode/figure1C_LaminarProfileCBFandCBV0.mat','CBV0','LP_CBF');

clear rCBV
for i = 1:NumLayers+3
    rCBV(i,:) = 1/CBV0(i)-(1-CBV0(i))/CBV0(i)*LP_Normalized(i,:);
end
deltarCBV = [];
for i = 1:size(LP_Normalized,1)
    deltarCBV = [deltarCBV; max(rCBV(i,:))-min(rCBV(i,:))];
end
LP_Compliance{3} = deltarCBV;

subplot(2,6,4); hold on;
plot(deltarCBV,'-','Color',colors(1,:),'linewidth',LineWidth);
set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['rCBV'],'FontSize',16);
title('ΔrCBV corrected without MTT','FontSize',16);
box off



clear CBV
for i = 1:NumLayers+3
    CBV(i,:) = 1-(1-CBV0(i))*LP_Normalized(i,:);
end
deltaCBV = [];
for i = 1:size(LP_Normalized,1)
    deltaCBV = [deltaCBV; max(CBV(i,:))-min(CBV(i,:))];
end
LP_Compliance{4} = deltaCBV;
subplot(2,6,5); hold on;
plot(deltaCBV,'-','Color',colors(1,:),'linewidth',LineWidth);
set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['CBV'],'FontSize',16);
title('ΔCBV corrected without MTT','FontSize',16);
box off


% CBV0~CBF^0.38
LP_Normalized = LP_TS./mean(LP_TS,2);
assumeCBV0 = 0.055;
correctMTT = 0;
if correctMTT
    calibration = LP_CBF.*assume_MTT;
else
    calibration = LP_CBF.^0.38;
end
CBV0 = assumeCBV0/mean(calibration(3:end-1))*calibration;
CBV0_orig = CBV0;


clear rCBV
for i = 1:NumLayers+3
    rCBV(i,:) = 1/CBV0(i)-(1-CBV0(i))/CBV0(i)*LP_Normalized(i,:);
end
deltarCBV = [];
for i = 1:size(LP_Normalized,1)
    deltarCBV = [deltarCBV; max(rCBV(i,:))-min(rCBV(i,:))];
end
LP_Compliance{5} = deltarCBV;

subplot(2,6,6); hold on;
plot(deltarCBV,'-','Color',colors(1,:),'linewidth',LineWidth);
set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['rCBV'],'FontSize',16);
title('ΔrCBV corrected without MTT','FontSize',16);
box off


clear CBV
for i = 1:NumLayers+3
    CBV(i,:) = 1-(1-CBV0(i))*LP_Normalized(i,:);
end
deltaCBV = [];
for i = 1:size(LP_Normalized,1)
    deltaCBV = [deltaCBV; max(CBV(i,:))-min(CBV(i,:))];
end
LP_Compliance{6} = deltaCBV;
subplot(2,6,7); hold on;
plot(deltaCBV,'-','Color',colors(1,:),'linewidth',LineWidth);
set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['CBV'],'FontSize',16);
title('ΔCBV corrected without MTT','FontSize',16);
box off



% CBV0~CBF^0.38 and CBV0 = 0.04
LP_Normalized = LP_TS./mean(LP_TS,2);
assumeCBV0 = 0.04;
correctMTT = 0;
if correctMTT
    calibration = LP_CBF.*assume_MTT;
else
    calibration = LP_CBF.^0.38;
end
CBV0 = assumeCBV0/mean(calibration(3:end-1))*calibration;
CBV0_orig = CBV0;


clear rCBV
for i = 1:NumLayers+3
    rCBV(i,:) = 1/CBV0(i)-(1-CBV0(i))/CBV0(i)*LP_Normalized(i,:);
end
deltarCBV = [];
for i = 1:size(LP_Normalized,1)
    deltarCBV = [deltarCBV; max(rCBV(i,:))-min(rCBV(i,:))];
end
LP_Compliance{7} = deltarCBV;

subplot(2,6,8); hold on;
plot(deltarCBV,'-','Color',colors(1,:),'linewidth',LineWidth);
set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['rCBV'],'FontSize',16);
title('ΔrCBV corrected without MTT','FontSize',16);
box off


clear CBV
for i = 1:NumLayers+3
    CBV(i,:) = 1-(1-CBV0(i))*LP_Normalized(i,:);
end
deltaCBV = [];
for i = 1:size(LP_Normalized,1)
    deltaCBV = [deltaCBV; max(CBV(i,:))-min(CBV(i,:))];
end
LP_Compliance{8} = deltaCBV;
subplot(2,6,9); hold on;
plot(deltaCBV,'-','Color',colors(1,:),'linewidth',LineWidth);
set(gca,'xlim',[0.5 NumLayers+3.5],'xTick',[1 2 NumLayers+3],'XTickLabels',{'WMd','WMs','CSF'},'FontSize',16);
xlabel(['Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['CBV'],'FontSize',16);
title('ΔCBV corrected without MTT','FontSize',16);
box off

%% save
if ifSaveLPCompliance
    save([input_dir '/rROI.whole.LP_Compliance.' num2str(NumLayers) 'layers' NameRegion '.mat'],'LP_Compliance');
end

%% undump
if ifundump
    ifconstantCBV0 = 0;
    if ifconstantCBV0
        suffix_undump = '.constantCBV0';
        CBV0 = 0.05*ones(9,1);
    else
        suffix_undump = '';
        calibration = LP_CBF.^0.38;
        CBV0 = 0.055/mean(calibration(3:end-1))*calibration;
    end
    % white matter
    VASO_WMd = WMd_VASO(:,4:end)./WMd_BOLD(:,4:end);
    clear rCBV deltaCBV
    rCBV = 1/CBV0(1)-(1-CBV0(1))/CBV0(1)*VASO_WMd./nanmean(VASO_WMd,2);
    CBV = rCBV*CBV0(1);
    deltaCBV = max(rCBV')-min(rCBV');
    output_data = [WMd_VASO(:,1:3) deltaCBV'];
    save([input_dir '/Undump.rROI.whole.WMd.compliance' suffix_undump '.rCBV.1D'],'output_data','-ascii');
    deltaCBV = max(CBV')-min(CBV');
    output_data = [WMd_VASO(:,1:3) deltaCBV'];
%     save([input_dir '/Undump.rROI.whole.WMd.compliance' suffix_undump '.CBV.1D'],'output_data','-ascii');

    VASO_WMs = WMs_VASO(:,4:end)./WMs_BOLD(:,4:end);
    clear rCBV deltaCBV
    rCBV = 1/CBV0(2)-(1-CBV0(2))/CBV0(2)*VASO_WMs./nanmean(VASO_WMs,2);
    CBV = rCBV*CBV0(2);
    deltaCBV = max(rCBV')-min(rCBV');
    output_data = [WMs_VASO(:,1:3) deltaCBV'];
    save([input_dir '/Undump.rROI.whole.WMs.compliance' suffix_undump '.rCBV.1D'],'output_data','-ascii');
    deltaCBV = max(CBV')-min(CBV');
    output_data = [WMs_VASO(:,1:3) deltaCBV'];
%     save([input_dir '/Undump.rROI.whole.WMs.compliance' suffix_undump '.CBV.1D'],'output_data','-ascii');


    % gray matter and CSF
    clear rCBV deltaCBV
    Pointer_depth = depth(:,4);
    Data_TS = Data_VASO(:,4:end)./Data_BOLD(:,4:end);
    rCBV = Data_TS;
    CBV = Data_TS;
    for i = 1:NumLayers
        tempROI = (Pointer_depth>(i-1)/NumLayers)&(Pointer_depth<=i/NumLayers);
        rCBV(tempROI,:) = 1/CBV0(i+2)-(1-CBV0(i+2))/CBV0(i+2)*Data_TS(tempROI,:)./nanmean(Data_TS(tempROI,:),2);
        CBV(tempROI,:) = rCBV(tempROI,:)*CBV0(i+2);
    end
    tempROI = (Pointer_depth>1)&(Pointer_depth<1.15);
    rCBV(tempROI,:) = 1/CBV0(9)-(1-CBV0(9))/CBV0(9)*Data_TS(tempROI,:)./nanmean(Data_TS(tempROI,:),2);
    CBV(tempROI,:) = rCBV(tempROI,:)*CBV0(9);
    deltaCBV = max(rCBV')-min(rCBV');
    output_data = [Data_VASO(:,1:3) deltaCBV'];
    save([input_dir '/Undump.rROI.whole.GMCSF.compliance' suffix_undump '.rCBV.1D'],'output_data','-ascii');
    deltaCBV = max(CBV')-min(CBV');
    output_data = [Data_VASO(:,1:3) deltaCBV'];
%     save([input_dir '/Undump.rROI.whole.GMCSF.compliance' suffix_undump '.CBV.1D'],'output_data','-ascii');

end


