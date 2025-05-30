clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

%    The purpose of this program uses bootstrap to check the rebin signal
% and delta CBV is from cardiac phase or noise?


%% set some parameters
subj = 'S01';
which_session = 1;
pwd_dir = '/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/';
input_dir = [pwd_dir 'analysis/group/' subj];
NumPhase = 10;
NumLayers = 6;
which_regions = {'whole','ACA','MCA','PCA'};
which_region = 1;
NameRegion = which_regions{which_region};

%% read data
for which_run = 1:2
    % load MRI data
    Data_VASO = {};
    Data_BOLD = {};
    Data_VASO{1} = load([input_dir '/rROI.WMd.VASO0' num2str(which_run) '.s' num2str(which_session) '.TS.' NameRegion 'Mean.1D']);
    Data_VASO{2} = load([input_dir '/rROI.WMs.VASO0' num2str(which_run) '.s' num2str(which_session) '.TS.' NameRegion 'Mean.1D']);
    Data_BOLD{1} = load([input_dir '/rROI.WMd.BOLD0' num2str(which_run) '.s' num2str(which_session) '.TS.' NameRegion 'Mean.1D']);
    Data_BOLD{2} = load([input_dir '/rROI.WMs.BOLD0' num2str(which_run) '.s' num2str(which_session) '.TS.' NameRegion 'Mean.1D']);
    for i = 1:NumLayers
        Data_VASO{i+2} = load([input_dir '/rROI.GM' num2str(i) '.VASO0' num2str(which_run) '.s' num2str(which_session) '.TS.' NameRegion 'Mean.1D']);
        Data_BOLD{i+2} = load([input_dir '/rROI.GM' num2str(i) '.BOLD0' num2str(which_run) '.s' num2str(which_session) '.TS.' NameRegion 'Mean.1D']);
    end
    Data_VASO{NumLayers+3} = load([input_dir '/rROI.CSF.VASO0' num2str(which_run) '.s' num2str(which_session) '.TS.' NameRegion 'Mean.1D']);
    Data_BOLD{NumLayers+3} = load([input_dir '/rROI.CSF.BOLD0' num2str(which_run) '.s' num2str(which_session) '.TS.' NameRegion 'Mean.1D']);

    % load cardiac phase data
    load([pwd_dir 'code/Matlab/Data/' subj '/PhaseData_' subj '_s' num2str(which_session) '_run' num2str(which_run) '.mat']);

    if which_run == 1
        Data_VASO1 = Data_VASO;
        Data_BOLD1 = Data_BOLD;
        Phase_VASO1 = Phase_VASO;
        Phase_BOLD1 = Phase_BOLD;
    else 
        Data_VASO2 = Data_VASO;
        Data_BOLD2 = Data_BOLD;
        Phase_VASO2 = Phase_VASO;
        Phase_BOLD2 = Phase_BOLD;
    end
end



%% run reliability test
RebinLP_mean = [];
BootstrapLP_mean = [];
BootstrapLP_ConIL = [];
BootstrapLP_ConIH = [];
P_bootstrap = [];
for i = 1:numel(Data_VASO)
    clear tmpData1 tmpData2
    tmpData1.Vdata = Data_VASO1{i};
    tmpData1.Bdata = Data_BOLD1{i};
    tmpData1.Vphase = Phase_VASO1;
    tmpData1.Bphase = Phase_BOLD1;
    tmpData2.Vdata = Data_VASO2{i};
    tmpData2.Bdata = Data_BOLD2{i};
    tmpData2.Vphase = Phase_VASO2;
    tmpData2.Bphase = Phase_BOLD2;
    [result1,result2,resultCombine] = Bootstrap_checkRebinAndRandom_forLP(tmpData1,tmpData2,NumPhase);
    RebinLP_mean = [RebinLP_mean [result1.meanRebin; result2.meanRebin; resultCombine.meanRebin]];
    BootstrapLP_mean = [BootstrapLP_mean [result1.meanRandom; result2.meanRandom; resultCombine.meanRandom]];
    BootstrapLP_ConIL = [BootstrapLP_ConIL [result1.stdRandom(1); result2.stdRandom(1); resultCombine.stdRandom(1)]];
    BootstrapLP_ConIH = [BootstrapLP_ConIH [result1.stdRandom(2); result2.stdRandom(2); resultCombine.stdRandom(2)]];
    P_bootstrap = [P_bootstrap [result1.P; result2.P; resultCombine.P]];
end

clear Result
Result.LP = RebinLP_mean(3,:);
Result.ConIH = BootstrapLP_ConIH(3,:);
Result.ConIL = BootstrapLP_ConIL(3,:);
Result.BootMean = BootstrapLP_mean(3,:);
save([input_dir '/rROI.VASOLPand95Range.s' num2str(which_session) '.' NameRegion 'Mean.mat'],'Result');







