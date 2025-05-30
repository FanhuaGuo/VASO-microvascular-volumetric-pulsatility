


%% figure 6b 
clc
clear all
close all

% set parameters
x = 1:1000;
ArterialPressure_young = 1./(1+exp(-0.01*(x-600)));
ArterialPressure_older = 0.2+0.8./(1+exp(-0.01*(x-600)));
PulseOrig = sind(x*20*360/numel(x));
PulsePressure_young = PulseOrig.*ArterialPressure_young*0.3+ArterialPressure_young;
PulsePressure_older = PulseOrig.*ArterialPressure_older*0.3+ArterialPressure_older;
rangeY = [ones(1,numel(x)).*ArterialPressure_young*0.3+ArterialPressure_young; -ones(1,numel(x)).*ArterialPressure_young*0.3+ArterialPressure_young];
rangeO = [ones(1,numel(x)).*ArterialPressure_older*0.3+ArterialPressure_older; -ones(1,numel(x)).*ArterialPressure_older*0.3+ArterialPressure_older];

tmpAP = [ArterialPressure_young 2*ArterialPressure_young(end)-ArterialPressure_young(end-1)];
tmpy = tmpAP(2:end)-tmpAP(1:end-1);
voPI_young = 1*ArterialPressure_young/max(ArterialPressure_young) +1*tmpy/max(tmpy);
tmpAP = [ArterialPressure_older 2*ArterialPressure_older(end)-ArterialPressure_older(end-1)];
tmpo = tmpAP(2:end)-tmpAP(1:end-1);
voPI_older = 1*ArterialPressure_older/max(ArterialPressure_older) +1*tmpo/max(tmpo);

ArterialTotalVolume_young = [0.880797*exp((x(1:400)-400).^2/(-2*350^2))  1./(1+exp(-0.01*(-x(401:end)+600)))];
ArterialTotalVolume_older = ArterialTotalVolume_young/1.2;



% figure
figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels'); hold on;
plot(ArterialTotalVolume_young,'b-','linewidth',3);
plot(ArterialTotalVolume_older,'r-','linewidth',3);
set(gca,'xlim',[0 1001],'xTick',[],'XTickLabels',[],'FontSize',16);
set(gca,'ylim',[-0.1 1],'yTick',[],'yTickLabels',[],'FontSize',16);
box on


figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels'); hold on;
plot(PulsePressure_young,'b-','linewidth',3);
plot(PulsePressure_older,'r-','linewidth',3);
plot(rangeY(1,:),'k-','linewidth',1);
plot(rangeY(2,:),'k-','linewidth',1);
plot(rangeO(1,:),'k-','linewidth',1);
plot(rangeO(2,:),'k-','linewidth',1);
set(gca,'xlim',[0 1001],'xTick',[],'XTickLabels',[],'FontSize',16);
set(gca,'ylim',[-0.2 1.5],'yTick',[],'yTickLabels',[],'FontSize',16);
box on


figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels'); hold on;
plot(voPI_young,'b-','linewidth',3);
plot(voPI_older,'r-','linewidth',3);
set(gca,'xlim',[0 1001],'xTick',[],'XTickLabels',[],'FontSize',16);
set(gca,'ylim',[-0.2 2],'yTick',[],'yTickLabels',[],'FontSize',16);
box on


figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels'); hold on;
vePI_young = ArterialPressure_young;
vePI_older = ArterialPressure_older+0.1;
plot(vePI_young,'b-','linewidth',3);
plot(vePI_older,'r-','linewidth',3);
set(gca,'xlim',[0 1001],'xTick',[],'XTickLabels',[],'FontSize',16);
set(gca,'ylim',[-0.2 1.4],'yTick',[],'yTickLabels',[],'FontSize',16);
box on

