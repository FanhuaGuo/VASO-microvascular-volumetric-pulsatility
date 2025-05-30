


%% figure S5ab
clc
clear all
close all

% load
load('./data/figureS5ab_ReliabilityTest.mat');
NameRegion = 'whole';
NumRows = 4;
NumColumns = 6;
NumLayers = 6;
LineWidth = 2;
positions = [0 0; 0 0; 0 0;...
             1 3; 2 3; 0 0;
             0 0; 0 0; 1 4;...
             3 3; 4 1; 4 2;...
             1 5; 1 6; 2 4;...
             2 5; 2 6; 3 4;...
             3 5; 3 6; 4 4;...
             4 5; 4 6];

% figure
figure('Color',[1 1 1],'Position',[0 0 1600 1000],'Units','pixels');
for which_subj = [4 5 9:23]
    Result = Result1(which_subj);
    
    subplot(NumRows,NumColumns,positions(which_subj,1)*NumColumns-NumColumns+positions(which_subj,2)); hold on;
    plot([1 2.5 4:9 11],Result.LP,'k-','linewidth',LineWidth);
    if max(Result.LP)<0.015
        VASOlim = [0 0.02];
    else
        VASOlim = [0 0.03];
    end
    plot([1 2.5 4:9 11],Result.BootMean,'r-','linewidth',LineWidth);
    frameX = [1 2.5 4:9 11 flip([1 2.5 4:9 11])];
    frameY = [Result.ConIH flip(Result.ConIL)];
    b = fill(frameX, frameY, [1,0.5,0.5],'EdgeColor','None');
    alpha(b,0.4);
    set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'xTickLabelRotation',45,'FontSize',16,'linewidth',LineWidth,'FontName','Arial','FontWeight','bold');
    set(gca,'ylim',VASOlim,'yTick',[0:0.01:0.03],'yTickLabels',[0:0.01:0.03]*100,'FontSize',16,'linewidth',LineWidth,'FontName','Arial','FontWeight','bold');
    ylabel(['ΔVASO (%)'],'FontSize',16,'FontName','Arial','FontWeight','bold');
    if which_subj<10
        SubjName = ['S0' num2str(which_subj)];
    else
        SubjName = ['S' num2str(which_subj)];
    end
    title(SubjName,'FontSize',16);
    box on
end


% for S01 S02 and S04
for which_subj = [1 2 3]
    positions(1) = which_subj;
    for wsession = 1:2
        positions(2) = wsession;
        switch wsession
            case 1
                Result = Result1(which_subj);
            case 2
                Result = Result2(which_subj);
        end
        subplot(NumRows,NumColumns,positions(1)*NumColumns-NumColumns+positions(2)); hold on;
        plot([1 2.5 4:9 11],Result.LP,'k-','linewidth',LineWidth);
        if max(Result.LP)<0.015
            VASOlim = [0 0.02];
        else
            VASOlim = [0 0.03];
        end
        plot([1 2.5 4:9 11],Result.BootMean,'r-','linewidth',LineWidth);
        frameX = [1 2.5 4:9 11 flip([1 2.5 4:9 11])];
        frameY = [Result.ConIH flip(Result.ConIL)];
        b = fill(frameX, frameY, [1,0.5,0.5],'EdgeColor','None');
        alpha(b,0.4);
        set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','pia'},'xTickLabelRotation',45,'FontSize',16,'linewidth',LineWidth,'FontName','Arial','FontWeight','bold');
        set(gca,'ylim',VASOlim,'yTick',[0:0.01:0.03],'yTickLabels',[0:0.01:0.03]*100,'FontSize',16,'linewidth',LineWidth,'FontName','Arial','FontWeight','bold');
        ylabel(['ΔVASO (%)'],'FontSize',16,'FontName','Arial','FontWeight','bold');
        if which_subj<10
            SubjName = ['S0' num2str(which_subj)];
        else
            SubjName = ['S' num2str(which_subj)];
        end
        title([SubjName ' session' num2str(wsession)],'FontSize',16);
        box on
    end
end




%% figure S5c
clc
clear all
close all
set(0,'defaultfigurecolor',[1 1 1]);% set figure background color

% set parameters
NumLayers = 6;
LineWidth = 2;
load('./data/figureS5C_tSNR.mat');

% figure
yData = Count;
figure('Color',[1 1 1],'Position',[0 0 600 400],'Units','pixels');
hold on;
plot([1 2.5 4:9 11],mean(yData),'k-','linewidth',LineWidth);
errorbar([1 2.5 4:9 11],mean(yData),std(yData)/sqrt(size(yData,1)),'k.','linewidth',LineWidth);
set(gca,'xlim',[0 12],'xTick',[1 2.5 3.5 9.5 11],'XTickLabels',{'WMd','WMs','1.0','0','CSF'},'FontSize',16);
set(gca,'ylim',[10 18],'yTick',[10:4:20],'FontSize',16);
xlabel(['relative cortical depth'],'FontSize',16);
ylabel(['tSNR'],'FontSize',16);
title('Laminar profile of tSNR','FontSize',16);
box on

