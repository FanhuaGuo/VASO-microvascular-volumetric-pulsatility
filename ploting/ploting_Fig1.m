

%% Figure 1A
clc
clear all
close all

% load
load('./data/figure1A_PulseCardiacPhaseDefinition.mat');

% plot
figure; hold on;
frameY = [0.4 0.4 -0.1 -0.1];
for i = 1:size(Phase_info,1)
    frameX = [Phase_info(i,1) Phase_info(i,2) Phase_info(i,2) Phase_info(i,1)]; % WM
    b = fill(frameX, frameY, colors(Phase_info(i,3),:),'EdgeColor','None');
    alpha(b,0.2);
end
plot(27:196,PulseLine_show(27:196),'k-','linewidth',2);
legend(legend_label,'EdgeColor','w','FontSize',16);
set(gca,'xlim',[27 196],'xTick',[27:50:277],'XTickLabels',[0:0.5:2.5],'FontSize',14,'linewidth',2);
set(gca,'yTick',[0 0.2 0.4],'FontSize',14,'linewidth',2);
% xlabel(['Time (s)'],'FontSize',16);
% ylabel(['PPG signal'],'FontSize',16);
% title('Cardiac phase definition in pulse','FontSize',16);
axis square



%% Figure 1B
clc
clear all
close all

% load
load('./data/figure1B_SchematicDiagram_VASOsignal_trigger.mat');

figure('Color',[1 1 1],'Position',[0 0 1000 400],'Units','pixels');
subplot(2,1,1); hold on;
yyaxis left
plot([1:10],Data_VASO2{9}(1:10),'r-','linewidth',2);
set(gca,'ylim',[900 950],'yTick',[900:25:950],'yTickLabels',[900:25:950],'FontSize',16,'linewidth',2);
ylabel(['VASO signals'],'FontSize',16);
yyaxis right
plot([1.3:1:10.3],Data_BOLD2{9}(1:10),'b-','linewidth',2); 
set(gca,'ylim',[1310 1360],'yTick',[1310:25:1360],'yTickLabels',[1310:25:1360],'FontSize',16,'linewidth',2);
ylabel(['BOLD signals'],'FontSize',16);
set(gca,'xlim',[0.5 10.5],'FontSize',16,'linewidth',2);


subplot(2,1,2); hold on;
plot([618:4022],PhaseLine(618:4022),'k-','linewidth',2);
plot([Trigger_VASO(1:10) Trigger_VASO(1:10)]'/10,[zeros(10,1) 10*ones(10,1)]','r-','linewidth',2);
plot([Trigger_BOLD(1:10) Trigger_BOLD(1:10)]'/10,[zeros(10,1) 10*ones(10,1)]','b-','linewidth',2);
set(gca,'xlim',[618+155 4022-155],'xTick',Trigger_VASO(1:10)/10,'xTickLabels',[1:10],'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 10],'yTick',[0:5:10],'yTickLabels',[0:5:10],'FontSize',16,'linewidth',2);
    
    
%% Figure 1C
clc
clear all
close all

% load
load('./data/figure1C_LaminarProfileCBFandCBV0.mat');

% set parameters
NumLayers = 6;

% plot
figure; 
subplot(121); hold on;
plot([1 2.5 4:4+NumLayers-1  4+NumLayers+0.5],LP_CBF,'k-','linewidth',2);
set(gca,'xlim',[0 NumLayers+5.5],'xTick',[1 2.5 NumLayers+4.5],'XTickLabels',{'WMd','WMs','pia'},'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 40],'yTick',[0 20 40],'FontSize',16,'linewidth',2);
xlabel(['Relative Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['CBF (mL/100g/min)'],'FontSize',16);
title('Laminar CBF','FontSize',16);
axis square
box on

tmpCBF = LP_CBF.^0.38;
CBV0 = 0.055*tmpCBF/mean(tmpCBF(3:end-1));
subplot(122); hold on;
plot([1 2.5 4:4+NumLayers-1  4+NumLayers+0.5],CBV0,'k-','linewidth',2);
set(gca,'xlim',[0 NumLayers+5.5],'xTick',[1 2.5 NumLayers+4.5],'XTickLabels',{'WMd','WMs','pia'},'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 0.08],'yTick',[0 0.04 0.08],'yTickLabels',[0 4 8],'FontSize',16,'linewidth',2);
xlabel(['Relative Depth (Deep <--> Superficial)'],'FontSize',16);
ylabel(['CBVrest (%)'],'FontSize',16);
title('Laminar CBVrest','FontSize',16);
axis square
box on


%% Figure 1D
clc
clear all
close all

% load
load('./data/figure1D_CardioPhaseProfile_DifferentDepth.mat');

% plot
figure; hold on;
for i = 1:6+3
    plot(LP_TS(i,:)/mean(LP_TS(i,:)),'-','Color',colors(i,:),'linewidth',2);
end
set(gca,'xlim',[0.5 10+0.5],'xTick',[1:10],'FontSize',16,'linewidth',2);
set(gca,'ylim',[0.99 1.01],'yTick',[0.99 1 1.01],'FontSize',16,'linewidth',2);
xlabel(['Cardio-Phase'],'FontSize',16);
ylabel(['Normalized VASO signal'],'FontSize',16);
title('Cardio-phase profile of normalized VASO signal','FontSize',16);
legend(legend_label,'EdgeColor','w','FontSize',16);
axis square




