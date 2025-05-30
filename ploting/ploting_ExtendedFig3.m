


%% Figure S3ab
clc
clear all
close all

% load
load('./data/figure4A_LaminarProfile_PI_and_minusMatrix.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;
yData = young.data;
eData = elder.data;
eData = eData([1:3 5:end],:);

% calc
Data = yData;
Data_else = eData;
yPI_minus_maps = ones(size(Data,2));
for i = 1:size(Data,2)
    for j = 1:size(Data,2)
        yPI_minus_maps(i,j) = mean(Data(:,i)-Data(:,j));
    end
end
ePI_minus_maps = ones(size(Data,2));
for i = 1:size(Data_else,2)
    for j = 1:size(Data_else,2)
        ePI_minus_maps(i,j) = mean(Data_else(:,i)-Data_else(:,j));
    end
end


% colorbar
Threshold = [0 0.1];
temp = 500;
color1 = [[1/temp:1/temp:1]' [1/temp:1/temp:1]' ones(temp,1)];
color2 = [ones(temp,1) [1:-1/temp:1/temp]' [1:-1/temp:1/temp]'];
color_gradient = [color1; 1 1 1; color2];


% draw Fig 
figure('Color',[1 1 1],'Position',[0 0 800 400],'Units','pixels');

Matrix_draw = yPI_minus_maps;
for i = 1:9
    for j = 1:9
        if i<=j Matrix_draw(i,j) = mean(Threshold); end
    end
end
Matrix_draw = Matrix_draw(end:-1:1,:);
subplot(1,2,1); hold on;
imagesc(Matrix_draw,Threshold);
colormap(color_gradient);
colorbar
set(gca,'xLim',[0.5 9+0.5],'xTick',[]);
set(gca,'yLim',[0.5 9+0.5],'yTick',[]);
set(gca, 'Box', 'off',...
         'linewidth', 2,...
         'XGrid', 'on', 'YGrid', 'on', 'ZGrid', 'off',...
         'TickDir', 'in', 'TickLength', [.1 .1],...
         'XMinorTick', 'off', 'YMinorTick', 'off', 'ZMinorTick', 'off',...
         'XColor', [.1 .1 .1], 'YColor', [.1 .1 .1]);
axis square;

Matrix_draw = ePI_minus_maps;
for i = 1:9
    for j = 1:9
        if i<=j Matrix_draw(i,j) = mean(Threshold); end
    end
end
Matrix_draw = Matrix_draw(end:-1:1,:);
subplot(1,2,2); hold on;
imagesc(Matrix_draw,Threshold);
colormap(color_gradient);
colorbar
set(gca,'xLim',[0.5 9+0.5],'xTick',[]);
set(gca,'yLim',[0.5 9+0.5],'yTick',[]);
set(gca, 'Box', 'off',...
         'linewidth', 2,...
         'XGrid', 'on', 'YGrid', 'on', 'ZGrid', 'off',...
         'TickDir', 'in', 'TickLength', [.1 .1],...
         'XMinorTick', 'off', 'YMinorTick', 'off', 'ZMinorTick', 'off',...
         'XColor', [.1 .1 .1], 'YColor', [.1 .1 .1]);
axis square;





%% Figure S3c
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

figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'FontSize',16);
set(gca,'ylim',[0 50],'yTick',[0:10:50],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['CBF (mL/100g/min)'],'FontSize',16);
title('Laminar profile of CBF','FontSize',16);
box on



%% Figure S3d
clc
clear all
close all

% load
load('./data/figure2A_LaminarProfile_CBF.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;


% figure S3D
yCBF = young.data;
eCBF = elder.data;
eCBF = eCBF([1:3 5:end],:);
tmp = yCBF.^0.38;
yCBV0 = 0.055*tmp./mean(tmp(:,3:end-1),2);
tmp = eCBF.^0.38;
eCBV0 = 0.055*tmp./mean(tmp(:,3:end-1),2);
% P_Ttest2Vo_Boot = Bootstrap_Ttest2(yCBV0,eCBV0)';

figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
plot([1 2.5 4:9 11],mean(yCBV0),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eCBV0),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yCBV0),std(yCBV0)/sqrt(size(yCBV0,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eCBV0),std(eCBV0)/sqrt(size(eCBV0,1)),'r.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'FontSize',16);
set(gca,'ylim',[0.02 0.07],'yTick',[0.02:0.01:0.07],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['CBV0 (mL/mL)'],'FontSize',16);
title('Laminar profile of CBV0','FontSize',16);
box on



%% Figure S3e
clc
clear all
close all

% load
load('./data/figure2B_LaminarProfile_absDeltaCBV.mat');
yCBV = young.data;
eCBV = elder.data;
eCBV = eCBV([1:3 5:end],:);
load('./data/figure2A_LaminarProfile_CBF.mat');

% set parameters
NumLayers = 6;
LineWidth = 2;

% figure 
yCBF = young.data;
eCBF = elder.data;
eCBF = eCBF([1:3 5:end],:);
tmp = yCBF.^0.38;
yCBV0 = 0.055*tmp./mean(tmp(:,3:end-1),2);
tmp = eCBF.^0.38;
eCBV0 = 0.055*tmp./mean(tmp(:,3:end-1),2);

yVASO = yCBV./(1-yCBV0);
eVASO = eCBV./(1-eCBV0);

figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
plot([1 2.5 4:9 11],mean(yVASO),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eVASO),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yVASO),std(yVASO)/sqrt(size(yVASO,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eVASO),std(eVASO)/sqrt(size(eVASO,1)),'r.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'xTickLabels',{'WMd','WMs','1.0','0','pia'},'FontSize',16);
set(gca,'ylim',[0 0.015],'yTick',[0:0.005:0.015],'yTickLabels',[0:0.005:0.015]*100,'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['ΔVASO (%)'],'FontSize',16);
title('Laminar profile of ΔVASO','FontSize',16);
box on




%% Figure S3f
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
plot([1 2.5 4:9 11],mean(yData),'b-','linewidth',LineWidth);
plot([1 2.5 4:9 11],mean(eData),'r-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'b.','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(eData),std(eData)/sqrt(size(eData,1)),'r.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'FontSize',16);
set(gca,'ylim',[0 0.015],'yTick',[0:0.005:0.02],'yTickLabels',[0:0.5:2],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['ΔCBV (ml/100ml)'],'FontSize',16);
title('Laminar profile of absolute ΔCBV','FontSize',16);
box on



