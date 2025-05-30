

%% Figure 2a
clc
clear all
close all

% load
load('./data/figure2A_LaminarProfile_CBF.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;


% figure
yData = young.data;
eData = elder.data;
eData = eData([1:3 5:end],:);
tmpe = eData.^0.38;
CBV0e = tmpe./mean(tmpe(:,3:8),2)*0.055;
tmpy = yData.^0.38;
CBV0y = tmpy./mean(tmpy(:,3:8),2)*0.055;

figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
yyaxis left
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
set(gca,'ylim',[0 50],'yTick',[0:10:50],'FontSize',16);
ylabel(['CBF (mL/100g/min)'],'FontSize',16);
title('Laminar profile of CBF','FontSize',16);

yyaxis right
plot([1 2.5 4:9 11],mean(CBV0y),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(CBV0y),std(CBV0y)/sqrt(size(CBV0y,1)),'r.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'FontSize',16);
set(gca,'ylim',[0.02 0.07],'yTick',[0.02:0.01:0.07],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel('CBV0 (mL/mL)','FontSize',16,'linewidth',2);
title('Laminar profile of CBF','FontSize',16);
box on;




%% Figure 2b
clc
clear all
close all

% load
load('./data/figure2B_LaminarProfile_absDeltaCBV.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;

% figure 
yData = young.data;
eData = elder.data;
eData = eData([1:3 5:end],:);

figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
plot([1 2.5 4:9 11],mean(yData),'k-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'k.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'FontSize',16);
set(gca,'ylim',[0 0.015],'yTick',[0:0.005:0.02],'yTickLabels',[0:0.5:2],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['ΔCBV (ml/100ml)'],'FontSize',16);
title('Laminar profile of absolute ΔCBV','FontSize',16);
box on



%% Figure 2c
clc
clear all
close all

% load
load('./data/figure4A_LaminarProfile_PI_and_minusMatrix.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;

% figure 2D
yData = young.data;
eData = elder.data;
eData = eData([1:3 5:end],:);

figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
plot([1 2.5 4:9 11],mean(yData),'k-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'k.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',[0 0.4],'yTick',[0:0.1:0.5],'yTickLabels',[0:0.1:0.5],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['PI-volume'],'FontSize',16);
title('Laminar profile of volumetric pulsatility index','FontSize',16);
box on



%% figure 2d
clc
clear all
close all

% load
load('./data/figure2D_ACA_LaminarProfile_PI_and_minusMatrix.mat');
ACAyoungPI = young;
ACAelderPI = elder;
ACAelderPI.data(4,:) = [];
load('./data/figure2D_MCA_LaminarProfile_PI_and_minusMatrix.mat');
MCAyoungPI = young;
MCAelderPI = elder;
MCAelderPI.data(4,:) = [];
load('./data/figure2D_PCA_LaminarProfile_PI_and_minusMatrix.mat');
PCAyoungPI = young;
PCAelderPI = elder;
PCAelderPI.data(4,:) = [];

% set parameters
LineWidth = 2;
PIyLim = [0 0.6];
PIyTick = [0:0.2:0.6];

% figure
figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
Ad = ACAyoungPI.data;
Md = MCAyoungPI.data;
Pd = PCAyoungPI.data;
plot([1 2.5 4:9 11],mean(Ad),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(Md),'r-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(Pd),'g-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(Ad),std(Ad)/sqrt(size(Ad,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(Md),std(Md)/sqrt(size(Md,1)),'r.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(Pd),std(Pd)/sqrt(size(Pd,1)),'g.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',[0 0.4],'yTick',[0:0.1:0.4],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['PI-volume'],'FontSize',16);
title('PCA pulsatility index','FontSize',16);
box on







