function [ Result1 , Result2 , Result3 ] = Bootstrap_checkRebinAndRandom_forLP( Data1 , Data2 , NumPhase )
% Use bootstrap to check the stability of Rebin data

%% get the raw rebin data
Num_EveryPhase1 = {};  Num_EveryPhase1{2} = [];
Mean_Rebin1 = {};      Mean_Rebin1{2} = [];
Num_EveryPhase2 = {};  Num_EveryPhase2{2} = [];
Mean_Rebin2 = {};      Mean_Rebin2{2} = [];
for i = 1:NumPhase
    Num_EveryPhase1{1} = [Num_EveryPhase1{1}; sum(Data1.Vphase == i)];
    Mean_Rebin1{1} = [Mean_Rebin1{1} mean(Data1.Vdata(Data1.Vphase == i))];
    Num_EveryPhase1{2} = [Num_EveryPhase1{2}; sum(Data1.Bphase == i)];
    Mean_Rebin1{2} = [Mean_Rebin1{2} mean(Data1.Bdata(Data1.Bphase == i))];
    
    Num_EveryPhase2{1} = [Num_EveryPhase2{1}; sum(Data2.Vphase == i)];
    Mean_Rebin2{1} = [Mean_Rebin2{1} mean(Data2.Vdata(Data2.Vphase == i))];
    Num_EveryPhase2{2} = [Num_EveryPhase2{2}; sum(Data2.Bphase == i)];
    Mean_Rebin2{2} = [Mean_Rebin2{2} mean(Data2.Bdata(Data2.Bphase == i))];
end
clear Result1 Result2 Result3
tmp1 = Mean_Rebin1{1}./Mean_Rebin1{2};
Result1.meanRebin = (max(tmp1)-min(tmp1))/mean(tmp1);
tmp2 = Mean_Rebin2{1}./Mean_Rebin2{2};
Result2.meanRebin = (max(tmp2)-min(tmp2))/mean(tmp2);
Result3.meanRebin = (Result1.meanRebin+Result2.meanRebin)/2;


%% bootstrap
NumSample = 10000;
BootStrap1 = [];
BootStrap2 = [];
BootStrapCombine = [];
for i = 1:NumSample
    % run1
    tmp_order = randperm(numel(Data1.Vdata));
    tmp1 = [];
    for k = 1:NumPhase
        tmp1 = [tmp1 mean(Data1.Vdata(tmp_order(sum(Num_EveryPhase1{1}(1:k-1))+1:sum(Num_EveryPhase1{1}(1:k)))))];
    end
    tmp2 = [];
    for k = 1:NumPhase
        tmp2 = [tmp2 mean(Data1.Bdata(tmp_order(sum(Num_EveryPhase1{2}(1:k-1))+1:sum(Num_EveryPhase1{2}(1:k)))))];
    end
    tmp_correct1 = tmp1./tmp2;
    BootStrap1 = [BootStrap1; (max(tmp_correct1)-min(tmp_correct1))/mean(tmp_correct1)];
    
    % run2
    tmp_order = randperm(numel(Data2.Vdata));
    tmp1 = [];
    for k = 1:NumPhase
        tmp1 = [tmp1 mean(Data2.Vdata(tmp_order(sum(Num_EveryPhase2{1}(1:k-1))+1:sum(Num_EveryPhase2{1}(1:k)))))];
    end
    tmp2 = [];
    for k = 1:NumPhase
        tmp2 = [tmp2 mean(Data2.Bdata(tmp_order(sum(Num_EveryPhase2{2}(1:k-1))+1:sum(Num_EveryPhase2{2}(1:k)))))];
    end
    tmp_correct2 = tmp1./tmp2;
    BootStrap2 = [BootStrap2; (max(tmp_correct2)-min(tmp_correct2))/mean(tmp_correct2)];
    
    % combine
    BootStrapCombine = [BootStrapCombine; (BootStrap1(end)+BootStrap2(end))/2];
end
Result1.meanRandom = mean(BootStrap1);
BootStrap1 = sort(BootStrap1);
Result1.stdRandom = [BootStrap1(NumSample*0.025) BootStrap1(NumSample*0.975)];

Result2.meanRandom = mean(BootStrap2);
BootStrap2 = sort(BootStrap2);
Result2.stdRandom = [BootStrap2(NumSample*0.025) BootStrap2(NumSample*0.975)];

Result3.meanRandom = mean(BootStrapCombine);
BootStrapCombine = sort(BootStrapCombine);
Result3.stdRandom = [BootStrapCombine(NumSample*0.05) BootStrapCombine(NumSample*0.95)];


%% statistics
Mean_Random = Result1.meanRandom;
Mean_Rebin = Result1.meanRebin;
BootStrap = BootStrap1;
if Mean_Random > Mean_Rebin
    P = sum(BootStrap<Mean_Rebin)/NumSample;
else
    P = sum(BootStrap>Mean_Rebin)/NumSample;
end
Result1.P = P;

Mean_Random = Result2.meanRandom;
Mean_Rebin = Result2.meanRebin;
BootStrap = BootStrap2;
if Mean_Random > Mean_Rebin
    P = sum(BootStrap<Mean_Rebin)/NumSample;
else
    P = sum(BootStrap>Mean_Rebin)/NumSample;
end
Result2.P = P;

Mean_Random = Result3.meanRandom;
Mean_Rebin = Result3.meanRebin;
BootStrap = BootStrapCombine;
if Mean_Random > Mean_Rebin
    P = sum(BootStrap<Mean_Rebin)/NumSample;
else
    P = sum(BootStrap>Mean_Rebin)/NumSample;
end
Result3.P = P;




end

