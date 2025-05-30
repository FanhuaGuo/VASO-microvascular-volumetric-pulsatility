


%% figure S9a
clc
clear all
close all

% load
load('/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/Draft/figure/PlotCode/figureS8_LaminarProfile_PI_and_minusMatrix_CBV0p04.mat','young','elder');

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



%% figure S9b
clc
clear all
close all

% load
load('./data/figure4A_LaminarProfile_PI_and_minusMatrix.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;

% figure
yData = young.data;
eData = elder.data;
eData = eData([1:3 5:end],:);
heData = eData([3 5 7 8 11],:);
neData = eData([1 2 4 6 9 10],:);


figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
plot([1 2],[mean(yData(:,1)) mean(yData(:,1))],'b-','LineWidth',3)
plot([3 4],[mean(neData(:,1)) mean(neData(:,1))],'g-','LineWidth',3)
plot([5 6],[mean(heData(:,1)) mean(heData(:,1))],'r-','LineWidth',3)
errorbar([1.5 3.5 5.5],[mean(yData(:,1)) mean(neData(:,1)) mean(heData(:,1))],...
    [std(yData(:,1))/sqrt(size(yData,1)) std(neData(:,1))/sqrt(size(neData,1)) std(heData(:,1))/sqrt(size(heData,1))],...
    'k.','LineWidth',2,'CapSize',0);
swarmchart([1.5*ones(size(yData,1),1)],[yData(:,1)],100,'blue','XJitterWidth',0.5);
swarmchart([3.5*ones(size(neData,1),1)],[neData(:,1)],100,'green','XJitterWidth',0.5);
swarmchart([5.5*ones(size(heData,1),1)],[heData(:,1)],100,'red','XJitterWidth',0.5);
title('compare deep WM mvPI between young/normal older/hypertension older','FontSize',16);
set(gca,'xlim',[0 7],'xTick',[1.5 3.5 5.5],'XTickLabels',{'young','normal older','hypertension older'},'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 0.2],'yTick',[0:0.1:0.4],'yTickLabels',[0:0.1:0.4],'FontSize',14,'linewidth',2);
ylabel('mvPI in deep WM','FontSize',14);
box off;


