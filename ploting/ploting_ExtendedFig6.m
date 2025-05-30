


%% Fig S6bc
clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

% load
load('./data/figure3GH_simulation.mat');
% logisticModel = @(b, t) b(1) ./ (1 + exp(-b(2) * (t - b(3))));
logisticModel = @(beta,x) beta(1)+beta(2)*x.^2./(beta(3)^2+x.^2);
LinearModel = @(beta,x) beta(1)+beta(2)*x;
NumRows = 2;
NumColumns = 2;
just1image = 1;
if just1image
    figure('Color',[1 1 1],'Position',[0 0 2000 400],'Units','pixels');
end

% plot
data = Result.varPI03;
if just1image
    subplot(NumRows,NumColumns,1); hold on;
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
title('set CBV0 = 3%','FontSize',16,'linewidth',2);
box on;
axis square


data = Result.varPI04;
if just1image
    subplot(NumRows,NumColumns,2); hold on;
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
beta0 = [-8, 0, 16];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,3) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,3), 'ro', 'LineWidth', 2);
plot(t_fit, y_fit, 'r-', 'LineWidth', 2);
set(gca,'xlim',[0 0.3],'xTick',[0:0.1:0.3],'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 10],'yTick',[0:5:10],'FontSize',16,'linewidth',2);
xlabel('Pulsatility index','FontSize',16,'linewidth',2);
ylabel('Reliability index','FontSize',16,'linewidth',2);
title('set CBV0 = 4%','FontSize',16,'linewidth',2);
box on;
axis square


data = Result.varPI05;
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
beta0 = [0, 10, 0.05];
beta = lsqcurvefit(logisticModel, beta0, data(:,1), data(:,3) ,[],[]);
t_fit = linspace(min(data(:,1)), max(data(:,1)), 100);
y_fit = logisticModel(beta, t_fit);
plot(data(:,1), data(:,3), 'ro', 'LineWidth', 2);
plot(t_fit, y_fit, 'r-', 'LineWidth', 2);
set(gca,'xlim',[0 0.3],'xTick',[0:0.1:0.3],'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 10],'yTick',[0:5:10],'FontSize',16,'linewidth',2);
xlabel('Pulsatility index','FontSize',16,'linewidth',2);
ylabel('Reliability index','FontSize',16,'linewidth',2);
title('set CBV0 = 5%','FontSize',16,'linewidth',2);
box on;
axis square



data = Result.varPI06;
if just1image
    subplot(NumRows,NumColumns,4); hold on;
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
title('set CBV0 = 6%','FontSize',16,'linewidth',2);
box on;
axis square



%% Fig S6d
clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

% load
load('./data/figureS6d_CountVoxelsNumber_ACAMCAPCA.mat');


% figure
figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
MeanCount = mean(Count);
SteCount = std(Count)/sqrt(size(Count,1));
med_mean = MeanCount([1 5 9; 2 6 10; 3 7 11; 4 8 12]);
med_ste = SteCount([1 5 9; 2 6 10; 3 7 11; 4 8 12]);
h = bar(med_mean);
set(h,'BarWidth',1);
set(h,'LineWidth',2);
set(h(1),'facecolor',[183 218 1]/255);
set(h(2),'facecolor',[243 128 65]/255);
set(h(3),'facecolor',[85 233 241]/255);
ngroups = size(med_mean,1);
nbars = size(med_mean,2);
groupwidth = min(0.8,nbars/(nbars+1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (i-0.5)*groupwidth/nbars;
    errorbar(x,med_mean(:,i),med_ste(:,i),'k.','linewidth',3,'CapSize',0);
end
legend({'ACA','MCA','PCA'},'EdgeColor','w','FontSize',16);
set(gca,'xlim',[0.5 4.5],'xTick',[1:4],'XTickLabels',{'deep WM','superficial WM','GM','CSF'},'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 400000],'yTick',[0:200000:400000],'yTickLabels',[0:200000:400000]*0.05^3,'FontSize',16,'linewidth',2);
ylabel('tissue volume (mL)','FontSize',16,'linewidth',2);
box off;






%% Fig S6e
clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

% load
load('./data/figureS6E_tSNR_ACAMCAPCA.mat');


%figure
figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
MeanCount = mean(Count);
SteCount = std(Count)/sqrt(size(Count,1));
med_mean = MeanCount([1 5 9; 2 6 10; 3 7 11; 4 8 12]);
med_ste = SteCount([1 5 9; 2 6 10; 3 7 11; 4 8 12]);
h = bar(med_mean);
set(h,'BarWidth',1);
set(h,'LineWidth',2);
set(h(1),'facecolor',[183 218 1]/255);
set(h(2),'facecolor',[243 128 65]/255);
set(h(3),'facecolor',[85 233 241]/255);
ngroups = size(med_mean,1);
nbars = size(med_mean,2);
groupwidth = min(0.8,nbars/(nbars+1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (i-0.5)*groupwidth/nbars;
    errorbar(x,med_mean(:,i),med_ste(:,i),'k.','linewidth',3,'CapSize',0);
end
legend({'ACA','MCA','PCA'},'EdgeColor','w','FontSize',16);
set(gca,'xlim',[0.5 4.5],'xTick',[1:4],'XTickLabels',{'deep WM','superficial WM','GM','CSF'},'FontSize',16,'linewidth',2);
set(gca,'ylim',[0 20],'yTick',[0:5:20],'FontSize',16,'linewidth',2);
ylabel('Number of voxels','FontSize',16,'linewidth',2);
box off;




