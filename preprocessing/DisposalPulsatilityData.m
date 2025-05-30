clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

% The purpose of this program is to disposal the ACQ data.
% We can get the cadio phase of every time points.

% version2: for the second group of data with double run

%% set some parameters
subj = 'S02';
which_session = 2;
pwd_dir = '/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/';
input_dir = [pwd_dir 'code/Matlab/Data/' subj '/S' num2str(which_session) '/'];
NameFile = 'acq_raw.mat';
NumPhase = 10;
NumLayers = 6;
Dummy = 3;
which_run = 1;
ifDeInversionPulse = 1;

% some other
switch subj
    case 'test'
        ifsmooth = 0;
        inversion_delay = 77;
        switch which_session
            case 1
                switch which_run
                    case 1
                        peak = [110]; % input manually
                        HeartRate = 95; % points
                        Index_outlier = 1.5;
                    case 2
                        peak = [104]; % input manually
                        HeartRate = 95; % points
                        Index_outlier = 1.5;
                end
            case 2
                inversion_delay = 78;
                ifDeInversionPulse = 0;
                switch which_run
                    case 1
                        peak = [26]; % input manually
                        HeartRate = 75; % points
                        Index_outlier = 2.5;
                    case 2
                        peak = [84]; % input manually
                        HeartRate = 75; % points
                        Index_outlier = 2.5;
                end
            case 3
                switch which_run
                    case 1
                        peak = [113]; % input manually
                        HeartRate = 95; % points
                        Index_outlier = 1.5;
                    case 2
                        peak = [61]; % input manually
                        HeartRate = 90; % points
                        Index_outlier = 1.5;
                end
        end
    % same format for other subjects
end


%% read data
% load acq data
load([input_dir NameFile]);


%% find the peak point of pulsatility
Trigger_orig = Trigger_acqData{which_run}(run{which_run}(1):run{which_run}(2));
Pulsatility_orig = Pulsatility_acqData{which_run}(run{which_run}(1):run{which_run}(2));

% downsample and filter pulsatility
Pulsatility_downsample = [];
for i = 1:10:numel(Pulsatility_orig)
    Pulsatility_downsample = [Pulsatility_downsample; mean(Pulsatility_orig(i:i+9))];
end

if ifsmooth
    filter_width = 5;
    Pulsatility_filter = Pulsatility_downsample;
    for i = (filter_width+1)/2:numel(Pulsatility_downsample)-(filter_width+1)/2+1
        Pulsatility_filter(i) = mean(Pulsatility_downsample(i-(filter_width-1)/2:i+(filter_width-1)/2));
    end
else
    Pulsatility_filter = Pulsatility_downsample;
end


% find trigger
tmp_Trigger_position = find(Trigger_orig>1);
tmp_Trigger_position = [tmp_Trigger_position; 1000000000];
Trigger_position = [0];
i = 1;
while 1
    tmp = i;
    while 1
        if tmp_Trigger_position(i+1)-tmp_Trigger_position(tmp) > 100
            break
        else
            i = i+1;
        end
    end
    Trigger_position = [Trigger_position; round(mean(tmp_Trigger_position(tmp:i)))];
    i = i+1;
    if i == numel(tmp_Trigger_position)
        break;
    end
end
if Trigger_position(2)<100
    Trigger_position(1) = [];
end


% try to find the peak roughly
tmp_Pulsatility = Pulsatility_filter;
inversion_peak_position = round(Trigger_position(3:2:end)/10-inversion_delay);
inversionLine = zeros(size(Pulsatility_filter));
inversionLine(inversion_peak_position) = 1;
if ifDeInversionPulse
    for i = 1:numel(inversion_peak_position)
        s = Pulsatility_filter(inversion_peak_position(i)-11);
        e = Pulsatility_filter(inversion_peak_position(i)+26);
        step = (e-s)/37;
        add_line = [s+step:step:e-step]';
        if numel(add_line) == 35
            add_line = [s+step:step:e-step*0.9]';
        end
        tmp_Pulsatility(inversion_peak_position(i)-10:inversion_peak_position(i)+25) = add_line;
    end
end
while 1
    tmp_lp = peak(end);
    [maxV maxL] = max(tmp_Pulsatility(tmp_lp+HeartRate-20:tmp_lp+HeartRate+40));
    coord_peak = tmp_lp+HeartRate-20+maxL-1;
    while 1
        tmp_line = tmp_Pulsatility(coord_peak-30:coord_peak+30);
        [maxV maxL] = max(tmp_line);
        if tmp_Pulsatility(coord_peak) < maxV
            coord_peak = coord_peak-31+maxL;
        else
            break;
        end
    end
    
    if coord_peak == peak(end)
        peak = [peak; coord_peak+80];
    else
        peak = [peak; coord_peak];
    end
    if peak(end) > round((run{which_run}(2)-run{which_run}(1))/10)-200
        break;
    end
end
peak_line = -0.1*ones(size(Pulsatility_filter));
peak_line(peak) = 0.1;


% process the peak near inversion pulse
if ifDeInversionPulse
    for i = 1:numel(peak)
        tmp = 1000000;
        j = 1;
        while j < numel(inversion_peak_position)
            if abs(peak(i)-inversion_peak_position(j)) < tmp
                tmp = abs(peak(i)-inversion_peak_position(j));
                j = j+1;
            else
                break;
            end
        end
        j = j-1;
        if peak(i) >= inversion_peak_position(j)-12  &&  peak(i) <= inversion_peak_position(j)+27
            peak(i) = round((peak(i-1)+peak(i+1))/2);
        else
            tmp = peak(i)-20:peak(i)+20;
            if max(tmp_Pulsatility(tmp)) > tmp_Pulsatility(peak(i))
                peak(i) = round((peak(i-1)+peak(i+1))/2);
            end
        end
    end
end
peak_line = -0.1*ones(size(Pulsatility_filter));
peak_line(peak) = 0.1;



% check peak
DistributionInterval_peak = peak(2:end)-peak(1:end-1);
Mean_dis = mean(DistributionInterval_peak);
Std_dis = std(DistributionInterval_peak);

% try to correct the peak automated
peak_modify = peak(1);
i = 1;
while i <= numel(DistributionInterval_peak)
    if abs(DistributionInterval_peak(i)-Mean_dis) > Std_dis*Index_outlier
        if abs(DistributionInterval_peak(i+1)-Mean_dis) > Std_dis*Index_outlier
            k = round((DistributionInterval_peak(i)+DistributionInterval_peak(i+1))/Mean_dis);
            Interval = round((peak(i+2)-peak(i))/k);
            for kk = 1:k-1
                peak_modify = [peak_modify; peak(i)+Interval*kk];
            end
            peak_modify = [peak_modify; peak(i+2)];
            i = i+1;
        else
            k = round(DistributionInterval_peak(i)/Mean_dis);
            Interval = round((peak(i+1)-peak(i))/k);
            for kk = 1:k-1
                peak_modify = [peak_modify; peak(i)+Interval*kk];
            end
            peak_modify = [peak_modify; peak(i+1)];
        end
    else
        peak_modify = [peak_modify; peak(i+1)];
    end
    i = i+1;
end
peak = peak_modify;
DistributionInterval_peak = peak(2:end)-peak(1:end-1);
Mean_dis = mean(DistributionInterval_peak);
Std_dis = std(DistributionInterval_peak);

peak_line = -0.1*ones(size(Pulsatility_filter));
peak_line(peak) = 0.1;




% corrected manually
switch subj
    case {'S02'}
        switch which_session
            case 1
                switch which_run
                    case 1
                        % get center value
                        kk = [47];
                        for i = kk
                            peak(i+1) = round((peak(i)+peak(i+2))/2);
                        end
                        
                        % change single point    
                        peak(peak==83824) = 83813;
                        peak(peak==85425) = 85417;
                        
                        % complex process
                        k = 3;
                        tmp = (3113-2825)/k;
                        peak(peak==2937) = [];
                        peak(peak==3048) = [];
                        for i = 1:k-1
                            peak = [peak; 2825+round(tmp*i)];
                        end
                    case 2
                        % complex process
                        k = 5;
                        tmp = (8371-7865)/k;
                        peak(peak==7985) = [];
                        peak(peak==8105) = [];
                        peak(peak==8178) = [];
                        peak(peak==8275) = [];
                        for i = 1:k-1
                            peak = [peak; 7865+round(tmp*i)];
                        end
                end
            case 2
                switch which_run
                    case 1
                    case 2
                end
        end
    % same format for other subjects
end
peak = sort(peak);
peak_line = -0.1*ones(size(Pulsatility_filter));
peak_line(peak) = 0.1;




%% rebin the phase of pulsatility
PhaseLine = zeros(size(Pulsatility_filter));
for i = 2:numel(peak)
    tmp_length = peak(i)-peak(i-1);
    tmp_step = tmp_length/NumPhase;
    for k = peak(i-1):peak(i)-1
        PhaseLine(k) = ceil((k-peak(i-1)+1)/tmp_step);
    end
end

Trigger_VASO = Trigger_position(1:2:end);
Trigger_BOLD = Trigger_position(2:2:end);
Trigger_VASO(1:Dummy) = [];
Trigger_BOLD(1:Dummy) = [];

Phase_VASO = [];
Phase_BOLD = [];
for i = 1:numel(Trigger_VASO)
    Phase_VASO = [Phase_VASO; PhaseLine(round(Trigger_VASO(i)/10))];
    Phase_BOLD = [Phase_BOLD; PhaseLine(round(Trigger_BOLD(i)/10))];
end



%% save
save([pwd_dir 'code/Matlab/Data/' subj '/PhaseData_' subj '_s' num2str(which_session) '_run' num2str(which_run) '.mat'],'Phase_VASO','Phase_BOLD','peak','PhaseLine','Trigger_VASO','Trigger_BOLD');


%% write code for editing VASO preprocessing batch
% % for test half point
% Phase_BOLD = Phase_BOLD(1:105);
% Phase_VASO = Phase_VASO(1:105);

% set some parameters
prefix1_VASO = ['3dMean -prefix  rm.VASO.phase'];
prefix1_BOLD = ['3dMean -prefix  rm.BOLD.phase'];
prefix2 = ['.nii    '];
suffix = ['-overwrite  \n'];
suffix_type = ['0' num2str(which_run)];
Type_pipeline = '.volreg';
SaveName_BOLD = [pwd_dir 'code/Matlab/Data/' subj '/CombineBOLDPhaseCodeRun' num2str(which_run) '.sh'];
SaveName_VASO = [pwd_dir 'code/Matlab/Data/' subj '/CombineVASOPhaseCodeRun' num2str(which_run) '.sh'];

% generate the code
fid = fopen(SaveName_BOLD,'w');
for phase = 1:NumPhase
    Pointer = 0;
    fprintf(fid,[prefix1_BOLD num2str(phase) prefix2]);
    tmp_loc = Phase_BOLD==phase;
    for i = 1:numel(Phase_BOLD)
        if tmp_loc(i)
            fprintf(fid,['BOLD' suffix_type Type_pipeline '.nii''[' num2str(i-1) ']''  ']);
            Pointer = Pointer+1;
        end
        if Pointer == 3
            fprintf(fid,['\\\n']);
            fprintf(fid,['           ']);
            Pointer = 0;
        end
    end
    fprintf(fid,suffix);
    fprintf(fid,['\n']);
end
fclose(fid);

fid = fopen(SaveName_VASO,'w');
for phase = 1:NumPhase
    Pointer = 0;
    fprintf(fid,[prefix1_VASO num2str(phase) prefix2]);
    tmp_loc = Phase_VASO==phase;
    for i = 1:numel(Phase_VASO)
        if tmp_loc(i)
            fprintf(fid,['VASO' suffix_type Type_pipeline '.nii''[' num2str(i-1) ']''  ']);
            Pointer = Pointer+1;
        end
        if Pointer == 3
            fprintf(fid,['\\\n']);
            fprintf(fid,['           ']);
            Pointer = 0;
        end
    end
    fprintf(fid,suffix);
    fprintf(fid,['\n']);
end
fclose(fid);
           





