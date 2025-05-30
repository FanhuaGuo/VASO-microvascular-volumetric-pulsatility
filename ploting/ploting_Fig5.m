


%% figure 5b
clc
clear all
close all

% load
load('./data/figure5B_velocity_CrossSectionalArea_curve_4Dflow.mat');

% figure;
figure('Color',[1 1 1],'Position',[0 0 800 400],'Units','pixels');
hold on;
yyaxis left
plot(Curve_velocity,'-','Color','b','linewidth',2);
set(gca,'ylim',[0 30],'yTick',[0:10:30],'yTickLabels',[0:10:30],'FontSize',16,'linewidth',2);
ylabel(['velocity (cm/s)'],'FontSize',16);
yyaxis right
plot(Curve_SCA,'-','Color','r','linewidth',2);
set(gca,'ylim',[70 85],'yTick',[70:5:85],'yTickLabels',[70:5:85],'FontSize',16,'linewidth',2);
ylabel(['cross sectional area (mm2)'],'FontSize',16);
xlabel(['cardiac phase'],'FontSize',16);
set(gca,'xlim',[0 13],'FontSize',16,'linewidth',2);



%% figure 5c
clc
clear all
close all

% load
load('./data/figure5C_PI_4Dflow.mat');
DataVe = young.VePI;
DataVo = young.VoPI;
DataVe_else = elder.VePI;
DataVo_else = elder.VoPI;


% figure
figure('Color',[1 1 1],'Position',[0 0 400 600],'Units','pixels');
subplot(2,1,1); hold on;
plot([0.5 1],[mean(DataVe(:,4)) mean(DataVe(:,4))],'b-','LineWidth',2)
plot([2.5 3],[mean(DataVe(:,5)) mean(DataVe(:,5))],'b-','LineWidth',2)
plot([4.5 5],[mean(DataVe(:,6)) mean(DataVe(:,6))],'b-','LineWidth',2)
plot([1 1.5],[mean(DataVe_else(:,4)) mean(DataVe_else(:,4))],'r-','LineWidth',2)
plot([3 3.5],[mean(DataVe_else(:,5)) mean(DataVe_else(:,5))],'r-','LineWidth',2)
plot([5 5.5],[mean(DataVe_else(:,6)) mean(DataVe_else(:,6))],'r-','LineWidth',2)
errorbar([0.75 2.75 4.75],[mean(DataVe(:,4)) mean(DataVe(:,5)) mean(DataVe(:,6))],[std(DataVe(:,4)) std(DataVe(:,5)) std(DataVe(:,6))]/sqrt(size(DataVe,1)),'k.','LineWidth',2,'CapSize',0);
errorbar([1.25 3.25 5.25],[mean(DataVe_else(:,4)) mean(DataVe_else(:,5)) mean(DataVe_else(:,6))],[std(DataVe_else(:,4)) std(DataVe_else(:,5)) std(DataVe_else(:,6))]/sqrt(size(DataVe_else,1)),'k.','LineWidth',2,'CapSize',0);
swarmchart([0.75*ones(size(DataVe,1),1)],[DataVe(:,4)],50,'blue','XJitterWidth',0.3);
swarmchart([2.75*ones(size(DataVe,1),1)],[DataVe(:,5)],50,'blue','XJitterWidth',0.3);
swarmchart([4.75*ones(size(DataVe,1),1)],[DataVe(:,6)],50,'blue','XJitterWidth',0.3);
swarmchart([1.25*ones(size(DataVe_else,1),1)],[DataVe_else(:,4)],50,'red','XJitterWidth',0.3);
swarmchart([3.25*ones(size(DataVe_else,1),1)],[DataVe_else(:,5)],50,'red','XJitterWidth',0.3);
swarmchart([5.25*ones(size(DataVe_else,1),1)],[DataVe_else(:,6)],50,'red','XJitterWidth',0.3);
title('MCA PI-velocity','FontSize',16);
set(gca,'xlim',[0 6],'xTick',[1 3 5],'XTickLabels',{'MCA1','MCA2','MCA3'},'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 1.5],'yTick',[0:0.5:1.5],'yTickLabels',[0:0.5:1.5],'FontSize',14,'linewidth',2);
ylabel('PI-velocity','FontSize',14);
box off;

subplot(2,1,2); hold on;
plot([0.5 1],[mean(DataVo(:,4)) mean(DataVo(:,4))],'b-','LineWidth',2)
plot([2.5 3],[mean(DataVo(:,5)) mean(DataVo(:,5))],'b-','LineWidth',2)
plot([4.5 5],[mean(DataVo(:,6)) mean(DataVo(:,6))],'b-','LineWidth',2)
plot([1 1.5],[mean(DataVo_else(:,4)) mean(DataVo_else(:,4))],'r-','LineWidth',2)
plot([3 3.5],[mean(DataVo_else(:,5)) mean(DataVo_else(:,5))],'r-','LineWidth',2)
plot([5 5.5],[mean(DataVo_else(:,6)) mean(DataVo_else(:,6))],'r-','LineWidth',2)
errorbar([0.75 2.75 4.75],[mean(DataVo(:,4)) mean(DataVo(:,5)) mean(DataVo(:,6))],[std(DataVo(:,4)) std(DataVo(:,5)) std(DataVo(:,6))]/sqrt(size(DataVo,1)),'k.','LineWidth',2,'CapSize',0);
errorbar([1.25 3.25 5.25],[mean(DataVo_else(:,4)) mean(DataVo_else(:,5)) mean(DataVo_else(:,6))],[std(DataVo_else(:,4)) std(DataVo_else(:,5)) std(DataVo_else(:,6))]/sqrt(size(DataVo_else,1)),'k.','LineWidth',2,'CapSize',0);
swarmchart([0.75*ones(size(DataVo,1),1)],[DataVo(:,4)],50,'blue','XJitterWidth',0.3);
swarmchart([2.75*ones(size(DataVo,1),1)],[DataVo(:,5)],50,'blue','XJitterWidth',0.3);
swarmchart([4.75*ones(size(DataVo,1),1)],[DataVo(:,6)],50,'blue','XJitterWidth',0.3);
swarmchart([1.25*ones(size(DataVo_else,1),1)],[DataVo_else(:,4)],50,'red','XJitterWidth',0.3);
swarmchart([3.25*ones(size(DataVo_else,1),1)],[DataVo_else(:,5)],50,'red','XJitterWidth',0.3);
swarmchart([5.25*ones(size(DataVo_else,1),1)],[DataVo_else(:,6)],50,'red','XJitterWidth',0.3);
title('MCA PI-volume','FontSize',16);
set(gca,'xlim',[0 6],'xTick',[1 3 5],'XTickLabels',{'MCA1','MCA2','MCA3'},'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 0.6],'yTick',[0:0.2:0.6],'FontSize',14,'linewidth',2);
ylabel('PI-volume','FontSize',14);
box off;



%% figure 5d
% I draw it by Hiplot ("https://hiplot.cn/")
% data is in "./data/figure5D_correlation.csv"


%% figure 5e
clc
clear all
close all

% load
load('./data/figure5C_PI_4Dflow.mat');
% load('figure5C_PI_4Dflow.mat');
yDataVo = young.VoPI(:,6:-1:4);
eDataVo = elder.VoPI(:,6:-1:4);

load('./data/figure2D_MCA_LaminarProfile_PI_and_minusMatrix.mat');
yData = young.data;
eData = elder.data;
eData = eData([1:3 5:end],:);

% set parameters
NumLayers = 6;
LineWidth = 2;
Threshold = [-0.1 0.1];

% figure 2D
% figure('Color',[1 1 1],'Position',[0 0 800 400],'Units','pixels');
figure('Color',[1 1 1],'Position',[0 0 1000 400],'Units','pixels');
hold on;
plot([1 2.5 4:9 11 13:15],[mean(yData) mean(yDataVo)],'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11 13:15],[mean(eData) mean(eDataVo)],'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11 13:15],[mean(yData) mean(yDataVo)],[std(yData)/sqrt(size(yData,1)) std(yDataVo)/sqrt(size(yDataVo,1))],'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11 13:15],[mean(eData) mean(eDataVo)],[std(eData)/sqrt(size(eData,1)) std(eDataVo)/sqrt(size(eDataVo,1))],'r.','linewidth',LineWidth);
set(gca,'xlim',[0 16],'xTick',[1 2.5 3.5 9.5 11 13:15],'XTickLabels',{'WMd','WMs','1.0','0','CSF','M3','M2','M1'},'FontSize',16);
set(gca,'ylim',[0 0.4],'yTick',[0:0.1:0.5],'yTickLabels',[0:0.1:0.5],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['PI-volume'],'FontSize',16);
title('Laminar profile of volumetric pulsatility index','FontSize',16);
box on




