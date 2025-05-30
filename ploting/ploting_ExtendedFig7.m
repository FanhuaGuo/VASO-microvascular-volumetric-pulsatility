


%% figure S7
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

load('./data/figure3F_ACA_RI.mat');
ACAyoungRI = young;
ACAelderRI = elder([1:3 5:end],:);
load('./data/figure3F_MCA_RI.mat');
MCAyoungRI = young;
MCAelderRI = elder([1:3 5:end],:);
load('./data/figure3F_PCA_RI.mat');
PCAyoungRI = young;
PCAelderRI = elder([1:3 5:end],:);


% set parameters
just1image = 0;
LineWidth = 2;
PIyLim = [0 0.6];
PIyTick = [0:0.2:0.6];
RIyLim = [0 6];
RIyTick = [0:2:6];

% ACA
if just1image
    figure; subplot(3,2,1);
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
hold on;
yData = ACAyoungPI.data;
eData = ACAelderPI.data;
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',PIyLim,'yTick',PIyTick,'yTickLabels',PIyTick,'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['PI-volume'],'FontSize',16);
title('ACA pulsatility index','FontSize',16);
box on

if just1image
    subplot(3,2,2);
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
hold on;
yData = ACAyoungRI;
eData = ACAelderRI;
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
plot([0 12],[1 1],'k:','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',RIyLim,'yTick',RIyTick,'yTickLabels',RIyTick,'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['Reliability index'],'FontSize',16);
title('ACA reliability index','FontSize',16);
box on


% MCA
if just1image
    subplot(3,2,3);
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
hold on;
yData = MCAyoungPI.data;
eData = MCAelderPI.data;
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',PIyLim,'yTick',PIyTick,'yTickLabels',PIyTick,'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['PI-volume'],'FontSize',16);
title('MCA pulsatility index','FontSize',16);
box on

if just1image
    subplot(3,2,4);
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
hold on;
yData = MCAyoungRI;
eData = MCAelderRI;
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
plot([0 12],[1 1],'k:','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',RIyLim,'yTick',RIyTick,'yTickLabels',RIyTick,'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['Reliability index'],'FontSize',16);
title('MCA reliability index','FontSize',16);
box on


% PCA
if just1image
    subplot(3,2,5);
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
hold on;
yData = PCAyoungPI.data;
eData = PCAelderPI.data;
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',PIyLim,'yTick',PIyTick,'yTickLabels',PIyTick,'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['PI-volume'],'FontSize',16);
title('PCA pulsatility index','FontSize',16);
box on

if just1image
    subplot(3,2,6);
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
hold on;
yData = PCAyoungRI;
eData = PCAelderRI;
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
plot([0 12],[1 1],'k:','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',RIyLim,'yTick',RIyTick,'yTickLabels',RIyTick,'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['Reliability index'],'FontSize',16);
title('PCA reliability index','FontSize',16);
box on

