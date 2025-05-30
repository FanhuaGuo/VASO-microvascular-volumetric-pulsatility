clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

%    The purpose of this program analysis 4Dflow data to get the cardica
% phase profile of every vessel mask 

%% set some parameters
subj = 'S01';
pwd_dir = '/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/';
Input_dir = [pwd_dir 'analysis/' subj '_4Dflow'];
Output_dir = [pwd_dir 'analysis/group/' subj];
which_regions = {'ICA','ACA','MCA','PCA'};
Num_masks2everyVessel = [2 1 3 2];
Threshold_velocity = 0.3;
Threshold_MagneticVariation = 20;
Threshold_BloodVelocity = 10;
colors = [255 0 0; 0 0 255; 0 255 0; 255 150 0]/255;%'rbgy';
Proportion_pick = 0.05;
PI_threshold = 0.4;
clear Result


%% ICA
which_region = 1;
NameRegion = which_regions{which_region};

ProfileVelocity = {};
ProfileVolume = {};
PI_Ve = zeros(2,Num_masks2everyVessel(which_region));
PI_Vo = zeros(2,Num_masks2everyVessel(which_region));
for label_lr = 1:2
    switch label_lr
        case 1
            hemi = '.lh';
        case 2
            hemi = '.rh';
    end
    for label = 1:Num_masks2everyVessel(which_region)
        [ProfileVelocity{label_lr,label},ProfileVolume{label_lr,label},PI_Ve(label_lr,label),...
            PI_Vo(label_lr,label)] = subfunc_Main_4Dflow_PIcompute(Input_dir,hemi,NameRegion,label,Proportion_pick,...
                                                                   Threshold_MagneticVariation,Threshold_BloodVelocity,Threshold_velocity);
    end
    
    % draw
    figure;
    subplot(1,2,1); hold on;
    for label = 1:Num_masks2everyVessel(which_region)
        plot(ProfileVelocity{label_lr,label},'-','Color',colors(label,:),'linewidth',2);
    end
    ylabel(['velocity (cm/s)'],'FontSize',16);
    xlabel(['cardiac phase'],'FontSize',16);
    box off
    
    subplot(1,2,2); hold on;
    for label = 1:Num_masks2everyVessel(which_region)
        plot(ProfileVolume{label_lr,label},'-','Color',colors(label,:),'linewidth',2);
    end
    ylabel(['sectional area (mm2)'],'FontSize',16);
    xlabel(['cardiac phase'],'FontSize',16);
end

figure;
subplot(1,3,1); hold on;
for label = 1:Num_masks2everyVessel(which_region)
    plot((ProfileVelocity{1,label}+ProfileVelocity{2,label})/2,'-','Color',colors(label,:),'linewidth',2);
end
ylabel(['velocity (cm/s)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off

subplot(1,3,2); hold on;
for label = 1:Num_masks2everyVessel(which_region)
    plot((ProfileVolume{1,label}+ProfileVolume{2,label})/2,'-','Color',colors(label,:),'linewidth',2);
end
ylabel(['sectional area (mm2)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off

subplot(1,3,3); hold on;
PI_Q = [];
for label = 1:Num_masks2everyVessel(which_region)
    tmp = 10*(ProfileVelocity{1,label}+ProfileVelocity{2,label})/2.*(ProfileVolume{1,label}+ProfileVolume{2,label})/2;
    plot(tmp,'-','Color',colors(label,:),'linewidth',2);
    PI_Q = [PI_Q (max(tmp)-min(tmp))/mean(tmp)];
end
ylabel(['Q (mm3/s)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off



ICA_ProfileVelocity = ProfileVelocity;
ICA_ProfileVolume = ProfileVolume;
ICA_PI_Ve = PI_Ve;
ICA_PI_Vo = PI_Vo;

Result.ICAVe = mean(PI_Ve);
Result.ICAVo = mean(PI_Vo);


figure; hold on;
label = 1;
yyaxis left
plot((ProfileVelocity{1,label}+ProfileVelocity{2,label})/2,'-','Color',colors(2,:),'linewidth',2);
ylabel(['velocity (cm/s)'],'FontSize',16);
yyaxis right
plot((ProfileVolume{1,label}+ProfileVolume{2,label})/2,'-','Color',colors(1,:),'linewidth',2);
ylabel(['sectional area (mm2)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
set(gca,'xlim',[0 13],'FontSize',16);

%% ACA
which_region = 2;
NameRegion = which_regions{which_region};

ProfileVelocity = {};
ProfileVolume = {};
PI_Ve = zeros(2,Num_masks2everyVessel(which_region));
PI_Vo = zeros(2,Num_masks2everyVessel(which_region));
for label_lr = 1
    switch label_lr
        case 1
            hemi = '';
        case 2
            hemi = '.rh';
    end
    for label = 1:Num_masks2everyVessel(which_region)
        [ProfileVelocity{label_lr,label},ProfileVolume{label_lr,label},PI_Ve(label_lr,label),...
            PI_Vo(label_lr,label)] = subfunc_Main_4Dflow_PIcompute(Input_dir,hemi,NameRegion,label,Proportion_pick,...
                                                                   Threshold_MagneticVariation,Threshold_BloodVelocity,Threshold_velocity);
    end

    % draw
    figure;
    subplot(1,2,1); hold on;
    for label = 1:Num_masks2everyVessel(which_region)
        plot(ProfileVelocity{label_lr,label},'-','Color',colors(label,:),'linewidth',2);
    end
    ylabel(['velocity (cm/s)'],'FontSize',16);
    xlabel(['cardiac phase'],'FontSize',16);
    box off
    
    subplot(1,2,2); hold on;
    for label = 1:Num_masks2everyVessel(which_region)
        plot(ProfileVolume{label_lr,label},'-','Color',colors(label,:),'linewidth',2);
    end
    ylabel(['sectional area (mm2)'],'FontSize',16);
    xlabel(['cardiac phase'],'FontSize',16);
end

figure;
subplot(1,3,1); hold on;
for label = 1:Num_masks2everyVessel(which_region)
    plot((ProfileVelocity{1,label}+ProfileVelocity{1,label})/2,'-','Color',colors(label,:),'linewidth',2);
end
ylabel(['velocity (cm/s)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off

subplot(1,3,2); hold on;
for label = 1:Num_masks2everyVessel(which_region)
    plot((ProfileVolume{1,label}+ProfileVolume{1,label})/2,'-','Color',colors(label,:),'linewidth',2);
end
ylabel(['sectional area (mm2)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off

subplot(1,3,3); hold on;
PI_Q = [];
for label = 1:Num_masks2everyVessel(which_region)
    tmp = 10*(ProfileVelocity{1,label}+ProfileVelocity{1,label})/2.*(ProfileVolume{1,label}+ProfileVolume{1,label})/2;
    plot(tmp,'-','Color',colors(label,:),'linewidth',2);
    PI_Q = [PI_Q (max(tmp)-min(tmp))/mean(tmp)];
end
ylabel(['Q (mm3/s)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off



ACA_ProfileVelocity = ProfileVelocity;
ACA_ProfileVolume = ProfileVolume;
ACA_PI_Ve = PI_Ve;
ACA_PI_Vo = PI_Vo;

Result.ACAVe = PI_Ve(1);
Result.ACAVo = PI_Vo(1);


%% PCA
which_region = 4;
NameRegion = which_regions{which_region};

ProfileVelocity = {};
ProfileVolume = {};
PI_Ve = zeros(2,Num_masks2everyVessel(which_region));
PI_Vo = zeros(2,Num_masks2everyVessel(which_region));
for label_lr = 1:2
    switch label_lr
        case 1
            hemi = '.lh';
        case 2
            hemi = '.rh';
    end
    for label = 1:Num_masks2everyVessel(which_region)
        [ProfileVelocity{label_lr,label},ProfileVolume{label_lr,label},PI_Ve(label_lr,label),...
            PI_Vo(label_lr,label)] = subfunc_Main_4Dflow_PIcompute(Input_dir,hemi,NameRegion,label,Proportion_pick,...
                                                                   Threshold_MagneticVariation,Threshold_BloodVelocity,Threshold_velocity);
    end

    % draw
    figure;
    subplot(1,2,1); hold on;
    for label = 1:Num_masks2everyVessel(which_region)
        plot(ProfileVelocity{label_lr,label},'-','Color',colors(label,:),'linewidth',2);
    end
    ylabel(['velocity (cm/s)'],'FontSize',16);
    xlabel(['cardiac phase'],'FontSize',16);
    box off
    
    subplot(1,2,2); hold on;
    for label = 1:Num_masks2everyVessel(which_region)
        plot(ProfileVolume{label_lr,label},'-','Color',colors(label,:),'linewidth',2);
    end
    ylabel(['sectional area (mm2)'],'FontSize',16);
    xlabel(['cardiac phase'],'FontSize',16);
end

figure;
subplot(1,3,1); hold on;
for label = 1:Num_masks2everyVessel(which_region)
    plot((ProfileVelocity{1,label}+ProfileVelocity{2,label})/2,'-','Color',colors(label,:),'linewidth',2);
end
ylabel(['velocity (cm/s)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off

subplot(1,3,2); hold on;
for label = 1:Num_masks2everyVessel(which_region)
    plot((ProfileVolume{1,label}+ProfileVolume{2,label})/2,'-','Color',colors(label,:),'linewidth',2);
end
ylabel(['sectional area (mm2)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off

subplot(1,3,3); hold on;
PI_Q = [];
for label = 1:Num_masks2everyVessel(which_region)
    tmp = 10*(ProfileVelocity{1,label}+ProfileVelocity{2,label})/2.*(ProfileVolume{1,label}+ProfileVolume{2,label})/2;
    plot(tmp,'-','Color',colors(label,:),'linewidth',2);
    PI_Q = [PI_Q (max(tmp)-min(tmp))/mean(tmp)];
end
ylabel(['Q (mm3/s)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off



PCA_ProfileVelocity = ProfileVelocity;
PCA_ProfileVolume = ProfileVolume;
PCA_PI_Ve = PI_Ve;
PCA_PI_Vo = PI_Vo;

Result.PCAVe = mean(PI_Ve);
Result.PCAVo = mean(PI_Vo);



%% MCA
which_region = 3;
NameRegion = which_regions{which_region};

ProfileVelocity = {};
ProfileVolume = {};
PI_Ve = zeros(2,Num_masks2everyVessel(which_region));
PI_Vo = zeros(2,Num_masks2everyVessel(which_region));
for label_lr = 1:2
    switch label_lr
        case 1
            hemi = '.lh';
        case 2
            hemi = '.rh';
    end
    for label = 1:Num_masks2everyVessel(which_region)
        [ProfileVelocity{label_lr,label},ProfileVolume{label_lr,label},PI_Ve(label_lr,label),...
            PI_Vo(label_lr,label)] = subfunc_Main_4Dflow_PIcompute(Input_dir,hemi,NameRegion,label,Proportion_pick,...
                                                                   Threshold_MagneticVariation,Threshold_BloodVelocity,Threshold_velocity);
    end

    % draw
    figure;
    subplot(1,2,1); hold on;
    for label = 1:Num_masks2everyVessel(which_region)
        plot(ProfileVelocity{label_lr,label},'-','Color',colors(label,:),'linewidth',2);
    end
    ylabel(['velocity (cm/s)'],'FontSize',16);
    xlabel(['cardiac phase'],'FontSize',16);
    box off
    
    subplot(1,2,2); hold on;
    for label = 1:Num_masks2everyVessel(which_region)
        plot(ProfileVolume{label_lr,label},'-','Color',colors(label,:),'linewidth',2);
    end
    ylabel(['sectional area (mm2)'],'FontSize',16);
    xlabel(['cardiac phase'],'FontSize',16);
end

figure;
subplot(1,3,1); hold on;
for label = 1:Num_masks2everyVessel(which_region)
    plot((ProfileVelocity{1,label}+ProfileVelocity{2,label})/2,'-','Color',colors(label,:),'linewidth',2);
end
ylabel(['velocity (cm/s)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off

subplot(1,3,2); hold on;
for label = 1:Num_masks2everyVessel(which_region)
    plot((ProfileVolume{1,label}+ProfileVolume{2,label})/2,'-','Color',colors(label,:),'linewidth',2);
end
ylabel(['sectional area (mm2)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off

subplot(1,3,3); hold on;
PI_Q = [];
for label = 1:Num_masks2everyVessel(which_region)
    tmp = 10*(ProfileVelocity{1,label}+ProfileVelocity{2,label})/2.*(ProfileVolume{1,label}+ProfileVolume{2,label})/2;
    plot(tmp,'-','Color',colors(label,:),'linewidth',2);
    PI_Q = [PI_Q (max(tmp)-min(tmp))/mean(tmp)];
end
ylabel(['Q (mm3/s)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
box off



MCA_ProfileVelocity = ProfileVelocity;
MCA_ProfileVolume = ProfileVolume;
MCA_PI_Ve = PI_Ve;
MCA_PI_Vo = PI_Vo;

Result.MCAVe = mean(PI_Ve);
Result.MCAVo =  mean(PI_Vo);


%% save
save([Output_dir '/4Dflow_PI_Result.mat'],'Result');




