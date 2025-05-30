clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

%% ========================================================= %%
%  VASO = M(1-CBV)
% ========================================================== %%
%% set parameters
tSNR = 7;
Num_voxels = 5000;
M = 0.7;
PI_assumed = 0.2;
CBV0_assumed = 0.06;
TR = 3.1;
Num_TRs = 600;
heartRate = 60;          % heart rate (bpm)
heartbeatSignal_assumed = [0.1+sin(0:pi/30:pi) 0.1-0.05*sin(0:pi/10:pi) 0.1+0.1*sin(0:pi/20:pi) [0.1:-0.01:0] zeros(1,round(60/heartRate*100)-74)]';
breatheRate = 13.54;          % breath rate (bpm)
breathebeatSignal_assumed = (sin(0:2*pi/(60/breatheRate*100-1):2*pi)'+1)/2;
BreatheEffect = 1;

%% model1: variation: voxels 
tmp_RI = [];
tmp_PI = [];
for j = 1:5

RI = [];
PI = [];
for Num_voxels = [2 100:100:900 1000:1000:15000]


    tmpBRTS_orig = [];
    while numel(tmpBRTS_orig) < Num_TRs*TR*100
        tmpBRTS_orig = [tmpBRTS_orig; (1+rand/10)*(sin(0:2*pi/(60/(12+randn*3)*100-1):2*pi)'+1)/2];
    end
    tmpHRTS_orig = [];
    CardiacPhases_orig = [];
    while numel(tmpHRTS_orig) < Num_TRs*TR*100
        tmp = (sin(0:2*pi/(60/(80+randn*10)*100-1):2*pi)'+1)/2;
        tmpHRTS_orig = [tmpHRTS_orig; (1+rand/10)*tmp];
        tmpC = zeros(numel(tmp),1);
        for i = 1:10
            tmpC(round((i-1)*numel(tmp)/10)+1:round(i*numel(tmp)/10)) = i;
        end
        CardiacPhases_orig = [CardiacPhases_orig; tmpC];
    end


    tmpHRTS = tmpHRTS_orig-0.5;
    tmpHRTS = [tmpHRTS; zeros(200000-numel(tmpHRTS),1)];
    tmpBRTS = (tmpBRTS_orig-0.5)*BreatheEffect;
    tmpBRTS = [tmpBRTS; zeros(200000-numel(tmpBRTS),1)];

    tmpTS = (tmpHRTS+tmpBRTS)*PI_assumed*CBV0_assumed;
    TimeSeries_CBV = [];
    CardiacPhases = [];
    for i = 1:Num_TRs
        tmp_pos = round((i-1)*TR*100+1);
        TimeSeries_CBV = [TimeSeries_CBV; CBV0_assumed+tmpTS(tmp_pos)];
        CardiacPhases = [CardiacPhases; CardiacPhases_orig(tmp_pos)];
    end
    TimeSeries_VASO_noneNoise = M*(1-TimeSeries_CBV);

    TimeSeries_VASO = [];
    parfor i = 1:Num_voxels
        tmp = TimeSeries_VASO_noneNoise + mean(TimeSeries_VASO_noneNoise)/tSNR*randn(1,Num_TRs)'; 
        TimeSeries_VASO = [TimeSeries_VASO; tmp'];
    end
    mean(TimeSeries_VASO(1,:))/std(TimeSeries_VASO(1,:))
    TimeSeries_VASO = mean(TimeSeries_VASO);

    [dVASO,Mean_dVASO,HI_dVASO,LI_dVASO,P] = Bootstrap_checkRebinAndRandom(TimeSeries_VASO,CardiacPhases,10);
    PI = [PI; dVASO*(1/CBV0_assumed-1)];
    RI = [RI; (dVASO-Mean_dVASO)/(HI_dVASO-Mean_dVASO)];
end
tmp_RI = [tmp_RI RI];
tmp_PI = [tmp_PI PI];
end
RI = mean(tmp_RI,2);
PI = mean(tmp_PI,2);

figure;
subplot(1,2,1); hold on;
plot([2 100:100:900 1000:1000:15000],PI,'r-');
subplot(1,2,2); hold on;
plot([2 100:100:900 1000:1000:15000],RI,'r-');


Result.varVolume = [[2 100:100:900 1000:1000:15000]' PI RI];


%% draw for figure S6A
figure; 
subplot(2,1,1); hold on;
plot(tmpHRTS_orig(1:2000),'k-','LineWidth',3);
set(gca,'xlim',[0 2200],'xTick',[],'XTickLabels',[]);
set(gca,'ylim',[-0.1 1.3],'yTick',[],'yTickLabels',[]);
box on

subplot(2,1,2); hold on;
plot(tmpBRTS_orig(1:2000),'k-','LineWidth',3);
set(gca,'xlim',[0 2200],'xTick',[],'XTickLabels',[]);
set(gca,'ylim',[-0.1 1.3],'yTick',[],'yTickLabels',[]);
box on

%% model1: variation: tSNR 
tmp_RI = [];
tmp_PI = [];
for j = 1:5

RI = [];
PI = [];
for tSNR = [1:15]


    tmpBRTS_orig = [];
    while numel(tmpBRTS_orig) < Num_TRs*TR*100
        tmpBRTS_orig = [tmpBRTS_orig; (1+rand/10)*(sin(0:2*pi/(60/(12+randn*3)*100-1):2*pi)'+1)/2];
    end
    tmpHRTS_orig = [];
    CardiacPhases_orig = [];
    while numel(tmpHRTS_orig) < Num_TRs*TR*100
        tmp = (sin(0:2*pi/(60/(80+randn*10)*100-1):2*pi)'+1)/2;
        tmpHRTS_orig = [tmpHRTS_orig; (1+rand/10)*tmp];
        tmpC = zeros(numel(tmp),1);
        for i = 1:10
            tmpC(round((i-1)*numel(tmp)/10)+1:round(i*numel(tmp)/10)) = i;
        end
        CardiacPhases_orig = [CardiacPhases_orig; tmpC];
    end


    tmpHRTS = tmpHRTS_orig-0.5;
    tmpHRTS = [tmpHRTS; zeros(200000-numel(tmpHRTS),1)];
    tmpBRTS = (tmpBRTS_orig-0.5)*BreatheEffect;
    tmpBRTS = [tmpBRTS; zeros(200000-numel(tmpBRTS),1)];

    tmpTS = (tmpHRTS+tmpBRTS)*PI_assumed*CBV0_assumed;
    TimeSeries_CBV = [];
    CardiacPhases = [];
    for i = 1:Num_TRs
        tmp_pos = round((i-1)*TR*100+1);
        TimeSeries_CBV = [TimeSeries_CBV; CBV0_assumed+tmpTS(tmp_pos)];
        CardiacPhases = [CardiacPhases; CardiacPhases_orig(tmp_pos)];
    end
    TimeSeries_VASO_noneNoise = M*(1-TimeSeries_CBV);

    TimeSeries_VASO = [];
    parfor i = 1:Num_voxels
        tmp = TimeSeries_VASO_noneNoise + mean(TimeSeries_VASO_noneNoise)/tSNR*randn(1,Num_TRs)'; 
        TimeSeries_VASO = [TimeSeries_VASO; tmp'];
    end
    mean(TimeSeries_VASO(1,:))/std(TimeSeries_VASO(1,:))
    TimeSeries_VASO = mean(TimeSeries_VASO);

    [dVASO,Mean_dVASO,HI_dVASO,LI_dVASO,P] = Bootstrap_checkRebinAndRandom(TimeSeries_VASO,CardiacPhases,10);
    PI = [PI; dVASO*(1/CBV0_assumed-1)];
    RI = [RI; (dVASO-Mean_dVASO)/(HI_dVASO-Mean_dVASO)];
end
tmp_RI = [tmp_RI RI];
tmp_PI = [tmp_PI PI];
end
RI = mean(tmp_RI,2);
PI = mean(tmp_PI,2);

figure;
subplot(1,2,1); hold on;
plot([1:15],PI,'r-');
subplot(1,2,2); hold on;
plot([1:15],RI,'r-');


Result.vartSNR = [[1:15]' PI RI];


%% model1: variation: BreatheEffect 
tmp_RI = [];
tmp_PI = [];
tmp_HI = [];
tmp_Md = [];
for j = 1:5

RI = [];
PI = [];
HI = [];
Md = [];
for BreatheEffect = [0:0.2:2]


    tmpBRTS_orig = [];
    while numel(tmpBRTS_orig) < Num_TRs*TR*100
        tmpBRTS_orig = [tmpBRTS_orig; (1+rand/10)*(sin(0:2*pi/(60/(12+randn*3)*100-1):2*pi)'+1)/2];
    end
    tmpHRTS_orig = [];
    CardiacPhases_orig = [];
    while numel(tmpHRTS_orig) < Num_TRs*TR*100
        tmp = (sin(0:2*pi/(60/(80+randn*10)*100-1):2*pi)'+1)/2;
        tmpHRTS_orig = [tmpHRTS_orig; (1+rand/10)*tmp];
        tmpC = zeros(numel(tmp),1);
        for i = 1:10
            tmpC(round((i-1)*numel(tmp)/10)+1:round(i*numel(tmp)/10)) = i;
        end
        CardiacPhases_orig = [CardiacPhases_orig; tmpC];
    end


    tmpHRTS = tmpHRTS_orig-0.5;
    tmpHRTS = [tmpHRTS; zeros(200000-numel(tmpHRTS),1)];
    tmpBRTS = (tmpBRTS_orig-0.5)*BreatheEffect;
    tmpBRTS = [tmpBRTS; zeros(200000-numel(tmpBRTS),1)];

    tmpTS = (tmpHRTS+tmpBRTS)*PI_assumed*CBV0_assumed;
    TimeSeries_CBV = [];
    CardiacPhases = [];
    for i = 1:Num_TRs
        tmp_pos = round((i-1)*TR*100+1);
        TimeSeries_CBV = [TimeSeries_CBV; CBV0_assumed+tmpTS(tmp_pos)];
        CardiacPhases = [CardiacPhases; CardiacPhases_orig(tmp_pos)];
    end
    TimeSeries_VASO_noneNoise = M*(1-TimeSeries_CBV);

    TimeSeries_VASO = [];
    parfor i = 1:Num_voxels
        tmp = TimeSeries_VASO_noneNoise + mean(TimeSeries_VASO_noneNoise)/tSNR*randn(1,Num_TRs)'; 
        TimeSeries_VASO = [TimeSeries_VASO; tmp'];
    end
    mean(TimeSeries_VASO(1,:))/std(TimeSeries_VASO(1,:))
    TimeSeries_VASO = mean(TimeSeries_VASO);

    [dVASO,Mean_dVASO,HI_dVASO,LI_dVASO,P] = Bootstrap_checkRebinAndRandom(TimeSeries_VASO,CardiacPhases,10);
    PI = [PI; dVASO*(1/CBV0_assumed-1)];
    RI = [RI; (dVASO-Mean_dVASO)/(HI_dVASO-Mean_dVASO)];
    HI = [HI; HI_dVASO];
    Md = [Md; Mean_dVASO];
end
tmp_RI = [tmp_RI RI];
tmp_PI = [tmp_PI PI];
tmp_HI = [tmp_HI HI];
tmp_Md = [tmp_Md Md];
end
RI = mean(tmp_RI,2);
PI = mean(tmp_PI,2);
HI = mean(tmp_HI,2);
Md = mean(tmp_Md,2);

figure;
subplot(1,2,1); hold on;
plot([0:0.2:2],PI,'r-');
subplot(1,2,2); hold on;
plot([0:0.2:2],RI,'r-');

figure; hold on;
plot([0:0.2:2],HI,'r-');
plot([0:0.2:2],Md,'b-');

figure; hold on;
plot([0:0.2:2],(HI-Md)./Md,'r-');


% Result.varBreatheEffect = [[0:0.2:2]' PI RI];
Result.BreatheEffectNoiseBaseline = [[0:0.2:2]' HI Md];

%% model1: variation: PI_assumed 
tmp_RI = [];
tmp_PI = [];
for j = 1:5

RI = [];
PI = [];
for PI_assumed = [0:0.02:0.1 0.15:0.05:0.3]


    tmpBRTS_orig = [];
    while numel(tmpBRTS_orig) < Num_TRs*TR*100
        tmpBRTS_orig = [tmpBRTS_orig; (1+rand/10)*(sin(0:2*pi/(60/(12+randn*3)*100-1):2*pi)'+1)/2];
    end
    tmpHRTS_orig = [];
    CardiacPhases_orig = [];
    while numel(tmpHRTS_orig) < Num_TRs*TR*100
        tmp = (sin(0:2*pi/(60/(80+randn*10)*100-1):2*pi)'+1)/2;
        tmpHRTS_orig = [tmpHRTS_orig; (1+rand/10)*tmp];
        tmpC = zeros(numel(tmp),1);
        for i = 1:10
            tmpC(round((i-1)*numel(tmp)/10)+1:round(i*numel(tmp)/10)) = i;
        end
        CardiacPhases_orig = [CardiacPhases_orig; tmpC];
    end


    tmpHRTS = tmpHRTS_orig-0.5;
    tmpHRTS = [tmpHRTS; zeros(200000-numel(tmpHRTS),1)];
    tmpBRTS = (tmpBRTS_orig-0.5)*BreatheEffect;
    tmpBRTS = [tmpBRTS; zeros(200000-numel(tmpBRTS),1)];

    tmpTS = (tmpHRTS+tmpBRTS)*PI_assumed*CBV0_assumed;
    TimeSeries_CBV = [];
    CardiacPhases = [];
    for i = 1:Num_TRs
        tmp_pos = round((i-1)*TR*100+1);
        TimeSeries_CBV = [TimeSeries_CBV; CBV0_assumed+tmpTS(tmp_pos)];
        CardiacPhases = [CardiacPhases; CardiacPhases_orig(tmp_pos)];
    end
    TimeSeries_VASO_noneNoise = M*(1-TimeSeries_CBV);

    TimeSeries_VASO = [];
    parfor i = 1:Num_voxels
        tmp = TimeSeries_VASO_noneNoise + mean(TimeSeries_VASO_noneNoise)/tSNR*randn(1,Num_TRs)'; 
        TimeSeries_VASO = [TimeSeries_VASO; tmp'];
    end
    mean(TimeSeries_VASO(1,:))/std(TimeSeries_VASO(1,:))
    TimeSeries_VASO = mean(TimeSeries_VASO);

    [dVASO,Mean_dVASO,HI_dVASO,LI_dVASO,P] = Bootstrap_checkRebinAndRandom(TimeSeries_VASO,CardiacPhases,10);
    PI = [PI; dVASO*(1/CBV0_assumed-1)];
    RI = [RI; (dVASO-Mean_dVASO)/(HI_dVASO-Mean_dVASO)];
end
tmp_RI = [tmp_RI RI];
tmp_PI = [tmp_PI PI];
end
RI = mean(tmp_RI,2);
PI = mean(tmp_PI,2);

figure;
subplot(1,2,1); hold on;
plot([0:0.02:0.1 0.15:0.05:0.3],PI,'r-');
subplot(1,2,2); hold on;
plot([0:0.02:0.1 0.15:0.05:0.3],RI,'r-');


% Result.varPI = [[0:0.02:0.1 0.15:0.05:0.3]' PI RI];
% Result.varPI01 = [[0:0.02:0.1 0.15:0.05:0.3]' PI RI];
% Result.varPI02 = [[0:0.02:0.1 0.15:0.05:0.3]' PI RI];
% Result.varPI03 = [[0:0.02:0.1 0.15:0.05:0.3]' PI RI];
% Result.varPI04 = [[0:0.02:0.1 0.15:0.05:0.3]' PI RI];
% Result.varPI05 = [[0:0.02:0.1 0.15:0.05:0.3]' PI RI];
Result.varPI06 = [[0:0.02:0.1 0.15:0.05:0.3]' PI RI];


%% model: variation: CBV0_assumed 
tmp_RI = [];
tmp_PI = [];
for j = 1:5

RI = [];
PI = [];
for CBV0_assumed = [0:0.005:0.06]


    tmpBRTS_orig = [];
    while numel(tmpBRTS_orig) < Num_TRs*TR*100
        tmpBRTS_orig = [tmpBRTS_orig; (1+rand/10)*(sin(0:2*pi/(60/(12+randn*3)*100-1):2*pi)'+1)/2];
    end
    tmpHRTS_orig = [];
    CardiacPhases_orig = [];
    while numel(tmpHRTS_orig) < Num_TRs*TR*100
        tmp = (sin(0:2*pi/(60/(80+randn*10)*100-1):2*pi)'+1)/2;
        tmpHRTS_orig = [tmpHRTS_orig; (1+rand/10)*tmp];
        tmpC = zeros(numel(tmp),1);
        for i = 1:10
            tmpC(round((i-1)*numel(tmp)/10)+1:round(i*numel(tmp)/10)) = i;
        end
        CardiacPhases_orig = [CardiacPhases_orig; tmpC];
    end


    tmpHRTS = tmpHRTS_orig-0.5;
    tmpHRTS = [tmpHRTS; zeros(200000-numel(tmpHRTS),1)];
    tmpBRTS = (tmpBRTS_orig-0.5)*BreatheEffect;
    tmpBRTS = [tmpBRTS; zeros(200000-numel(tmpBRTS),1)];

    tmpTS = (tmpHRTS+tmpBRTS)*PI_assumed*CBV0_assumed;
    TimeSeries_CBV = [];
    CardiacPhases = [];
    for i = 1:Num_TRs
        tmp_pos = round((i-1)*TR*100+1);
        TimeSeries_CBV = [TimeSeries_CBV; CBV0_assumed+tmpTS(tmp_pos)];
        CardiacPhases = [CardiacPhases; CardiacPhases_orig(tmp_pos)];
    end
    TimeSeries_VASO_noneNoise = M*(1-TimeSeries_CBV);

    TimeSeries_VASO = [];
    parfor i = 1:Num_voxels
        tmp = TimeSeries_VASO_noneNoise + mean(TimeSeries_VASO_noneNoise)/tSNR*randn(1,Num_TRs)'; 
        TimeSeries_VASO = [TimeSeries_VASO; tmp'];
    end
    mean(TimeSeries_VASO(1,:))/std(TimeSeries_VASO(1,:))
    TimeSeries_VASO = mean(TimeSeries_VASO);

    [dVASO,Mean_dVASO,HI_dVASO,LI_dVASO,P] = Bootstrap_checkRebinAndRandom(TimeSeries_VASO,CardiacPhases,10);
    PI = [PI; dVASO*(1/CBV0_assumed-1)];
    RI = [RI; (dVASO-Mean_dVASO)/(HI_dVASO-Mean_dVASO)];
end
tmp_RI = [tmp_RI RI];
tmp_PI = [tmp_PI PI];
end
RI = mean(tmp_RI,2);
PI = mean(tmp_PI,2);

figure;
subplot(1,2,1); hold on;
plot([0:0.005:0.06],PI,'r-');
subplot(1,2,2); hold on;
plot([0:0.005:0.06],RI,'r-');


Result.varCBV0 = [[0:0.005:0.06]' PI RI];




%% model: variation: Num_TRs 
RI = [];

for Num_TRs = [100:100:800]
    tmpHRTS = repmat(heartbeatSignal_assumed,ceil(Num_TRs*3.1*heartRate/60),1);
    tmpHRTS = tmpHRTS/max(tmpHRTS) - mean(tmpHRTS);
    tmpHRTS = [tmpHRTS; zeros(250000-numel(tmpHRTS),1)];
    tmpBRTS = repmat(breathebeatSignal_assumed,ceil(Num_TRs*3.1*breatheRate/60),1);
    tmpBRTS = (tmpBRTS-0.5)*BreatheEffect;
    tmpBRTS = [tmpBRTS; zeros(250000-numel(tmpBRTS),1)];


    tmpTS = (tmpHRTS+tmpBRTS)*PI_assumed*CBV0_assumed;
    TimeSeries_CBV = [];
    CardiacPhases = [];
    for i = 1:Num_TRs
        tmp_pos = round((i-1)*TR*100+1);
        TimeSeries_CBV = [TimeSeries_CBV; CBV0_assumed+tmpTS(tmp_pos)];
        CardiacPhases = [CardiacPhases; ceil(mod(tmp_pos,round(100*60/heartRate))/round(100*60/heartRate/10))];
    end
    TimeSeries_VASO_noneNoise = M*(1-TimeSeries_CBV);

    TimeSeries_VASO = [];
    parfor i = 1:Num_voxels
        tmp = TimeSeries_VASO_noneNoise + mean(TimeSeries_VASO_noneNoise)/tSNR*randn(1,Num_TRs)'; 
        TimeSeries_VASO = [TimeSeries_VASO; tmp'];
    end
    TimeSeries_VASO = mean(TimeSeries_VASO);
    mean(TimeSeries_VASO)/std(TimeSeries_VASO)

    [dVASO,Mean_dVASO,HI_dVASO,LI_dVASO,P] = Bootstrap_checkRebinAndRandom(TimeSeries_VASO,CardiacPhases,10);
    RI = [RI; (dVASO-Mean_dVASO)/(HI_dVASO-Mean_dVASO)];
end

figure;
plot([100:100:800],RI,'r-');




%% model: variation: heartRate 
RI = [];

for heartRate = [45:2:80]
    heartbeatSignal_assumed = [0.1+sin(0:pi/30:pi) 0.1-0.05*sin(0:pi/10:pi) 0.1+0.1*sin(0:pi/20:pi) [0.1:-0.01:0] zeros(1,round(60/heartRate*100)-74)]';

    tmpHRTS = repmat(heartbeatSignal_assumed,ceil(Num_TRs*3.1*heartRate/60),1);
    tmpHRTS = tmpHRTS/max(tmpHRTS) - mean(tmpHRTS);
    tmpHRTS = [tmpHRTS; zeros(250000-numel(tmpHRTS),1)];
    tmpBRTS = repmat(breathebeatSignal_assumed,ceil(Num_TRs*3.1*breatheRate/60),1);
    tmpBRTS = (tmpBRTS-0.5)*BreatheEffect;
    tmpBRTS = [tmpBRTS; zeros(250000-numel(tmpBRTS),1)];


    tmpTS = (tmpHRTS+tmpBRTS)*PI_assumed*CBV0_assumed;
    TimeSeries_CBV = [];
    CardiacPhases = [];
    for i = 1:Num_TRs
        tmp_pos = round((i-1)*TR*100+1);
        TimeSeries_CBV = [TimeSeries_CBV; CBV0_assumed+tmpTS(tmp_pos)];
        CardiacPhases = [CardiacPhases; ceil(mod(tmp_pos,round(100*60/heartRate))/round(100*60/heartRate/10))];
    end
    TimeSeries_VASO_noneNoise = M*(1-TimeSeries_CBV);

    TimeSeries_VASO = [];
    parfor i = 1:Num_voxels
        tmp = TimeSeries_VASO_noneNoise + mean(TimeSeries_VASO_noneNoise)/tSNR*randn(1,Num_TRs)'; 
        TimeSeries_VASO = [TimeSeries_VASO; tmp'];
    end
    TimeSeries_VASO = mean(TimeSeries_VASO);
    mean(TimeSeries_VASO)/std(TimeSeries_VASO)

    [dVASO,Mean_dVASO,HI_dVASO,LI_dVASO,P] = Bootstrap_checkRebinAndRandom(TimeSeries_VASO,CardiacPhases,10);
    RI = [RI; (dVASO-Mean_dVASO)/(HI_dVASO-Mean_dVASO)];
end

figure;
plot([45:2:80],RI,'r-');




%% save
save('/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/Draft/figure/PlotCode/figure3GH_simulation.mat','Result');


