


%% Figure 4a
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
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'FontSize',16);
set(gca,'ylim',[0 0.4],'yTick',[0:0.1:0.5],'yTickLabels',[0:0.1:0.5],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['PI-volume'],'FontSize',16);
title('Laminar profile of volumetric pulsatility index','FontSize',16);
box on



%% figure 4b
clc
clear all
close all

% load
load('./data/figure4B_RI.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;

% figure
yData = young;
eData = elder([1:3 5:end],:);
figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
plot([0 12],[1 1],'k:','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',[0 6],'yTick',[0:2:6],'yTickLabels',[0:2:6],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['Reliability index'],'FontSize',16);
title('Laminar profile of reliability index','FontSize',16);
box on




%% figure 4c
% I draw it by Hiplot ("https://hiplot.cn/")
% data is in "./data/figure4C_MSE_4groups.csv"






