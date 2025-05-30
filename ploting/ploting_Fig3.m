


%% Figure 3b
clc
clear all
close all

% load
load('./data/figure3B_compare_6subjs_PImaps.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;
Threshold = [0 0.2];


% figure
temp = 100;
color1 = [[1/temp:1/temp:1]' [1/temp:1/temp:1]' ones(temp,1)];
temp = 100;
color2 = [ones(temp,1) [1:-1/temp:1/temp]' [1:-1/temp:1/temp]'];
color_gradient = [color1; 1 1 1; color2];

figure('Color',[1 1 1],'Position',[0 0 600 600],'Units','pixels');
hold on;
imagesc(MSE_matrix,Threshold);
colormap(color_gradient);
colorbar
set(gca,'xLim',[0.5 size(MSE_matrix,1)+0.5],'xTick',[]);
set(gca,'yLim',[0.5 size(MSE_matrix,1)+0.5],'yTick',[]);
set(gca, 'Box', 'on',...
         'linewidth', 2,...
         'XGrid', 'on', 'YGrid', 'on', 'ZGrid', 'off',...
         'TickDir', 'in', 'TickLength', [.1 .1],...
         'XMinorTick', 'off', 'YMinorTick', 'off', 'ZMinorTick', 'off',...
         'XColor', [.1 .1 .1], 'YColor', [.1 .1 .1]);
axis square;



%% Figure 3c
clc
clear all
close all

% load
load('./data/figure3B_compare_6subjs_PImaps.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;
Threshold = [0 0.2];


% figure
figure('Color',[1 1 1],'Position',[0 0 600 600],'Units','pixels');
hold on;
swarmchart([2*ones(numel(Data2),1)],[Data2],50,'blue','XJitterWidth',0.5);
swarmchart([1*ones(numel(Data1),1)],[Data1],50,'red','XJitterWidth',0.5);
set(gca,'ylim',[0 0.25],'yTick',[0 0.25],'FontSize',16,'linewidth',2);
set(gca,'xlim',[0.5 2.5],'xTick',[],'FontSize',16,'linewidth',2);
ylabel(['MSE'],'FontSize',16);
title('MSE value between 2 PI maps','FontSize',16);
legend({'different person','same person'},'EdgeColor','w','FontSize',16);



%% figure 3d
clc
clear all
close all

% load
load('./data/figure3D_ReliabilityTest.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;

% figure
figure('Color',[1 1 1],'Position',[0 0 700 1000],'Units','pixels');
for i = 1:3
    for j = 1:2
        subplot(3,2,i*2-2+j); hold on;
        plot([1 2.5 4:9 11],fig3A(i,j).LP,'k-','linewidth',LineWidth);
        plot([1 2.5 4:9 11],fig3A(i,j).BootMean,'r-','linewidth',LineWidth);
        frameX = [1 2.5 4:9 11 flip([1 2.5 4:9 11])];
        frameY = [fig3A(i,j).ConIH flip(fig3A(i,j).ConIL)];
        b = fill(frameX, frameY, [1,0.5,0.5],'EdgeColor','None');
        alpha(b,0.2);
        set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'xTickLabelRotation',45,'FontSize',16,'linewidth',LineWidth,'FontName','Arial','FontWeight','bold');
        set(gca,'ylim',[0 0.02],'yTick',[0:0.01:0.02],'yTickLabels',[0:0.01:0.02]*100,'FontSize',16,'linewidth',LineWidth,'FontName','Arial','FontWeight','bold');
        xlabel(['relative cortical depth'],'FontSize',16,'FontName','Arial','FontWeight','bold');
        ylabel(['ΔVASO (%)'],'FontSize',16,'FontName','Arial','FontWeight','bold');
        box on
    end
end



%% figure 3e
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
plot([1 2.5 4:9 11],mean(yData),'k-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'k.','linewidth',LineWidth);
plot([0 12],[1 1],'k:','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'FontSize',16);
set(gca,'ylim',[0 6],'yTick',[0:2:6],'yTickLabels',[0:2:6],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['Reliability index'],'FontSize',16);
title('Laminar profile of reliability index','FontSize',16);
box on




%% figure 3f
clc
clear all
close all

% load
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
LineWidth = 2;
RIyLim = [0 6];
RIyTick = [0:2:6];


% figure
figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels'); 
hold on;
Ad = ACAyoungRI;
Md = MCAyoungRI;
Pd = PCAyoungRI;
plot([1 2.5 4:9 11],mean(Ad),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(Md),'r-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(Pd),'g-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(Ad),std(Ad)/sqrt(size(Ad,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(Md),std(Md)/sqrt(size(Md,1)),'r.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(Pd),std(Pd)/sqrt(size(Pd,1)),'g.','linewidth',LineWidth);
plot([0 12],[1 1],'k:','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',RIyLim,'yTick',RIyTick,'yTickLabels',RIyTick,'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['Reliability index'],'FontSize',16);
title('PCA pulsatility index','FontSize',16);
box on





%% Fig 3g and 3h
clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

% load
load('./data/figure3GH_simulation.mat');
% logisticModel = @(b, t) b(1) ./ (1 + exp(-b(2) * (t - b(3))));
logisticModel = @(beta,x) beta(1)+beta(2)*x.^2./(beta(3)^2+x.^2);
LinearModel = @(beta,x) beta(1)+beta(2)*x;
NumRows = 1;
NumColumns = 6;
just1image = 1;
if just1image
    figure('Color',[1 1 1],'Position',[0 0 2000 400],'Units','pixels');
end

% draw tSNR
data = Result.vartSNR;
if just1image
    subplot(NumRows,NumColumns,1); hold on;
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
yyaxis left
beta0 = [0.25, -0.05, 1.5];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,2) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,2), 'bo', 'LineWidth', 2);
plot(t_fit, y_fit, 'b-', 'LineWidth', 2);
set(gca,'ylim',[0.15 0.25],'yTick',[0.15:0.05:0.25],'FontSize',16,'linewidth',2);
ylabel('Pulsatility index','FontSize',16,'linewidth',2);

yyaxis right
beta0 = [0, 7, 2];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,3) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,3), 'ro', 'LineWidth', 2);
plot(t_fit, y_fit, 'r-', 'LineWidth', 2);
set(gca,'xlim',[0 15],'xTick',[0:5:15],'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 10],'yTick',[0:5:10],'FontSize',16,'linewidth',2);
xlabel('tSNR','FontSize',16,'linewidth',2);
ylabel('Reliability index','FontSize',16,'linewidth',2);
title('variation: tSNR','FontSize',16,'linewidth',2);
box on;
axis square


% draw Volume
data = Result.varVolume([1 2:2:11 12:20],:);
if just1image
    subplot(NumRows,NumColumns,2); hold on;
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
yyaxis left
beta0 = [0.7, -0.5, 50];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,2) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,2), 'bo', 'LineWidth', 2);
plot(t_fit, y_fit, 'b-', 'LineWidth', 2);
set(gca,'ylim',[0.1 0.7],'yTick',[0.1:0.3:0.7],'FontSize',16,'linewidth',2);
ylabel('Pulsatility index','FontSize',16,'linewidth',2);

yyaxis right
beta0 = [0, 7, 2];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,3) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,3), 'ro', 'LineWidth', 2);
plot(t_fit, y_fit, 'r-', 'LineWidth', 2);
set(gca,'xlim',[0 10000],'xTick',[0:5000:10000],'XTickLabels',[0:5000:10000]/1000,'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 10],'yTick',[0:5:10],'FontSize',16,'linewidth',2);
xlabel('Tissue volume (mL)','FontSize',16,'linewidth',2);
ylabel('Reliability index','FontSize',16,'linewidth',2);
title('variation: tissue volume','FontSize',16,'linewidth',2);
box on;
axis square


% draw PI
data = Result.varPI;
if just1image
    subplot(NumRows,NumColumns,3); hold on;
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
yyaxis left
beta0 = [0 0];
beta = lsqcurvefit(LinearModel, beta0, data(:,1), data(:,2) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = LinearModel(beta, t_fit);
plot(data(:,1), data(:,2), 'bo', 'LineWidth', 2);
plot(t_fit, y_fit, 'b-', 'LineWidth', 2);
set(gca,'ylim',[0 0.4],'yTick',[0:0.2:0.4],'FontSize',16,'linewidth',2);
ylabel('Pulsatility index','FontSize',16,'linewidth',2);

yyaxis right
beta0 = [0, 7, 2];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,3) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,3), 'ro', 'LineWidth', 2);
plot(t_fit, y_fit, 'r-', 'LineWidth', 2);
set(gca,'xlim',[0 0.3],'xTick',[0:0.1:0.3],'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 10],'yTick',[0:5:10],'FontSize',16,'linewidth',2);
xlabel('Pulsatility index','FontSize',16,'linewidth',2);
ylabel('Reliability index','FontSize',16,'linewidth',2);
title('variation: pulsatility index','FontSize',16,'linewidth',2);
box on;
axis square


% draw CBV0
data = Result.varCBV0;
if just1image
    subplot(NumRows,NumColumns,4); hold on;
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
yyaxis left
beta0 = [0.35, -0.15, 0.0075];
beta = lsqcurvefit(logisticModel, beta0, data(2:end,1), data(2:end,2) ,[],[]);
t_fit = linspace(min(data(2:end,1)), max(data(2:end,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(2:end,1), data(2:end,2), 'bo', 'LineWidth', 2);
plot(t_fit, y_fit, 'b-', 'LineWidth', 2);
set(gca,'ylim',[0.15 0.35],'yTick',[0.15:0.05:0.35],'FontSize',16,'linewidth',2);
ylabel('Pulsatility index','FontSize',16,'linewidth',2);

yyaxis right
beta0 = [0, 7, 2];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,3) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,3), 'ro', 'LineWidth', 2);
plot(t_fit, y_fit, 'r-', 'LineWidth', 2);
set(gca,'xlim',[0 0.06],'xTick',[0:0.02:0.06],'XTickLabels',[0:0.02:0.06]*100,'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 10],'yTick',[0:5:10],'FontSize',16,'linewidth',2);
xlabel('CBV0 (%)','FontSize',16,'linewidth',2);
ylabel('Reliability index','FontSize',16,'linewidth',2);
title('variation: CBV0','FontSize',16,'linewidth',2);
box on;
axis square


% draw Breathe
data = Result.varBreatheEffect;
if just1image
    subplot(NumRows,NumColumns,5); hold on;
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
yyaxis left
beta0 = [0 0];
beta = lsqcurvefit(LinearModel, beta0, data(:,1), data(:,2) ,[],[]);
[tmpC,tmpP] = corr(data(:,1), data(:,2));
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = LinearModel(beta, t_fit);
plot(data(:,1), data(:,2), 'bo', 'LineWidth', 2);
plot(t_fit, y_fit, 'b-', 'LineWidth', 2);
set(gca,'ylim',[0.15 0.25],'yTick',[0.15:0.05:0.25],'FontSize',16,'linewidth',2);
ylabel('Pulsatility index','FontSize',16,'linewidth',2);

yyaxis right
beta0 = [0, 7, 2];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,3) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,3), 'ro', 'LineWidth', 2);
plot(t_fit, y_fit, 'r-', 'LineWidth', 2);
set(gca,'xlim',[0 2],'xTick',[0:1:2],'XTickLabels',[0:1:2]*20,'FontSize',16,'linewidth',2);
set(gca,'ylim',[3 13],'yTick',[3:5:13],'FontSize',16,'linewidth',2);
xlabel('Breathe effect (%)','FontSize',16,'linewidth',2);
ylabel('Reliability index','FontSize',16,'linewidth',2);
title('variation: breathe effect','FontSize',16,'linewidth',2);
box on;
axis square



% draw Breathe
data = Result.BreatheEffectNoiseBaseline;
if just1image
    subplot(NumRows,NumColumns,6); hold on;
else
    figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
end
beta0 = [0, 7, 2];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,2) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,2), 'ro', 'LineWidth', 2);
plot(t_fit, y_fit, 'r-', 'LineWidth', 2);
beta0 = [0, 7, 2];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,3) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,3), 'bo', 'LineWidth', 2);
plot(t_fit, y_fit, 'b-', 'LineWidth', 2);
set(gca,'xlim',[0 2],'xTick',[0:1:2],'XTickLabels',[0:1:2]*20,'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 0.01],'yTick',[0:0.005:0.01],'yTickLabels',[0:0.005:0.01]*100,'FontSize',16,'linewidth',2);
xlabel('Breathe effect (%)','FontSize',16,'linewidth',2);
ylabel('ΔVASO (%)','FontSize',16,'linewidth',2);
title('variation: breathe effect','FontSize',16,'linewidth',2);
box on;
axis square






