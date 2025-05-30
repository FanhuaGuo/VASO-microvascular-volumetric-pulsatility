clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

%% set some parameters
subj = 'test';    % usually its the subject-ID, like S01 S02 ...
which_session = 1;
pwd_dir = '/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/';
input_dir = [pwd_dir 'raw/acq_data/' subj '/'];
output_dir = [pwd_dir 'code/Matlab/Data/' subj '/'];
mkdir(output_dir);
output_dir = [pwd_dir 'code/Matlab/Data/' subj '/S' num2str(which_session) '/'];
mkdir(output_dir);
NameSave = 'acq_raw.mat';
switch subj
    case 'test'
        switch which_session
            case 1
                NameRead1 = '[Time]_[Name]_VASO_s1_run1.mat';
                NameRead2 = '[Time]_[Name]_VASO_s1_run2.mat';
                run{1} = [1 940000];
                run{2} = [1 940000];
            case 2
                NameRead1 = '[Time]_[Name]_VASO_s2_run1.mat';
                NameRead2 = '[Time]_[Name]_VASO_s2_run2.mat';
                run{1} = [1 940000];
                run{2} = [1 940000];
        end
    % same format for other subjects
end



%% read and disposal data(single run)
% 
% % read
% load([input_dir NameRead]);
% Total_points = size(data,1);
% Total_points = floor(Total_points/2)*2;
% Pulsatility_acqData = (data(1:2:Total_points,3)+data(2:2:Total_points,3))/2;
% unit_x = 0.001;  % seconds
% Trigger_acqData = (data(1:2:Total_points,5)+data(2:2:Total_points,5))/2;
% 
% 
% % save
% save([output_dir NameSave],'run','Pulsatility_acqData','Trigger_acqData','unit_x');




%% read and disposal data(double run)

% read
clear Trigger_acqData Pulsatility_acqData

load([input_dir NameRead1]);
Total_points = size(data,1);
Total_points = floor(Total_points/2)*2;
Pulsatility_acqData{1} = (data(1:2:Total_points,3)+data(2:2:Total_points,3))/2;
unit_x = 0.001;  % seconds
Trigger_acqData{1} = (data(1:2:Total_points,5)+data(2:2:Total_points,5))/2;

load([input_dir NameRead2]);
Total_points = size(data,1);
Total_points = floor(Total_points/2)*2;
Pulsatility_acqData{2} = (data(1:2:Total_points,3)+data(2:2:Total_points,3))/2;
unit_x = 0.001;  % seconds
Trigger_acqData{2} = (data(1:2:Total_points,5)+data(2:2:Total_points,5))/2;


% save
save([output_dir NameSave],'run','Pulsatility_acqData','Trigger_acqData','unit_x');










