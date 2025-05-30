


%% figure S8b
clc
clear all
close all

% load
load('./data/figure5C_PI_4Dflow.mat');

DataVe = young.VePI;
DataVo = young.VoPI;
DataVe_else = elder.VePI;
DataVo_else = elder.VoPI;

figure('Color',[1 1 1],'Position',[0 0 1200 600],'Units','pixels');     

% draw ICA
subplot(2,4,1); hold on;
plot([0.5 1],[mean(DataVe(:,1)) mean(DataVe(:,1))],'b-','LineWidth',2)
plot([2.5 3],[mean(DataVe(:,2)) mean(DataVe(:,2))],'b-','LineWidth',2)
plot([1 1.5],[mean(DataVe_else(:,1)) mean(DataVe_else(:,1))],'r-','LineWidth',2)
plot([3 3.5],[mean(DataVe_else(:,2)) mean(DataVe_else(:,2))],'r-','LineWidth',2)
errorbar([0.75 2.75],[mean(DataVe(:,1)) mean(DataVe(:,2))],[std(DataVe(:,1)) std(DataVe(:,2))]/sqrt(size(DataVe,1)),'k.','LineWidth',2,'CapSize',0);
errorbar([1.25 3.25],[mean(DataVe_else(:,1)) mean(DataVe_else(:,2))],[std(DataVe_else(:,1)) std(DataVe_else(:,2))]/sqrt(size(DataVe_else,1)),'k.','LineWidth',2,'CapSize',0);
swarmchart([0.75*ones(size(DataVe,1),1)],[DataVe(:,1)],50,'blue','XJitterWidth',0.5);
swarmchart([2.75*ones(size(DataVe,1),1)],[DataVe(:,2)],50,'blue','XJitterWidth',0.5);
swarmchart([1.25*ones(size(DataVe_else,1),1)],[DataVe_else(:,1)],50,'red','XJitterWidth',0.5);
swarmchart([3.25*ones(size(DataVe_else,1),1)],[DataVe_else(:,2)],50,'red','XJitterWidth',0.5);
title('ICA PI-velocity','FontSize',16);
set(gca,'xlim',[0 4],'xTick',[1 3],'XTickLabels',{'ICA1','ICA2'},'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 1.5],'yTick',[0:0.5:1.5],'yTickLabels',[0:0.5:1.5],'FontSize',14,'linewidth',2);
ylabel('vePI','FontSize',14);
axis square
box off;

subplot(2,4,5); hold on;
plot([0.5 1],[mean(DataVo(:,1)) mean(DataVo(:,1))],'b-','LineWidth',2)
plot([2.5 3],[mean(DataVo(:,2)) mean(DataVo(:,2))],'b-','LineWidth',2)
plot([1 1.5],[mean(DataVo_else(:,1)) mean(DataVo_else(:,1))],'r-','LineWidth',2)
plot([3 3.5],[mean(DataVo_else(:,2)) mean(DataVo_else(:,2))],'r-','LineWidth',2)
errorbar([0.75 2.75],[mean(DataVo(:,1)) mean(DataVo(:,2))],[std(DataVo(:,1)) std(DataVo(:,2))]/sqrt(size(DataVo,1)),'k.','LineWidth',2,'CapSize',0);
errorbar([1.25 3.25],[mean(DataVo_else(:,1)) mean(DataVo_else(:,2))],[std(DataVo_else(:,1)) std(DataVo_else(:,2))]/sqrt(size(DataVo_else,1)),'k.','LineWidth',2,'CapSize',0);
swarmchart([0.75*ones(size(DataVo,1),1)],[DataVo(:,1)],50,'blue','XJitterWidth',0.5);
swarmchart([2.75*ones(size(DataVo,1),1)],[DataVo(:,2)],50,'blue','XJitterWidth',0.5);
swarmchart([1.25*ones(size(DataVo_else,1),1)],[DataVo_else(:,1)],50,'red','XJitterWidth',0.5);
swarmchart([3.25*ones(size(DataVo_else,1),1)],[DataVo_else(:,2)],50,'red','XJitterWidth',0.5);
title('ICA PI-volume','FontSize',16);
set(gca,'xlim',[0 4],'xTick',[1 3],'XTickLabels',{'ICA1','ICA2'},'FontSize',14,'linewidth',2);
% set(gca,'ylim',[0 0.4],'yTick',[0:0.1:0.4],'yTickLabels',[0:0.1:0.4],'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 0.6],'yTick',[0:0.2:0.6],'FontSize',14,'linewidth',2);
ylabel('voPI','FontSize',14);
axis square
box off;


% draw ACA
subplot(2,4,2); hold on;
plot([0.5 1.5],[mean(DataVe(:,3)) mean(DataVe(:,3))],'b-','LineWidth',2)
plot([1.5 2.5],[mean(DataVe_else(:,3)) mean(DataVe_else(:,3))],'r-','LineWidth',2)
errorbar([1],[mean(DataVe(:,3))],[std(DataVe(:,3))]/sqrt(size(DataVe,1)),'k.','LineWidth',2,'CapSize',0);
errorbar([2],[mean(DataVe_else(:,3))],[std(DataVe_else(:,3))]/sqrt(size(DataVe_else,1)),'k.','LineWidth',2,'CapSize',0);
swarmchart([1*ones(size(DataVe,1),1)],[DataVe(:,3)],80,'blue','XJitterWidth',0.5);
swarmchart([2*ones(size(DataVe_else,1),1)],[DataVe_else(:,3)],80,'red','XJitterWidth',0.5);
title('ACA PI-velocity','FontSize',16);
set(gca,'xlim',[0 3],'xTick',[1.5],'XTickLabels',{'ACA'},'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 1.5],'yTick',[0:0.5:1.5],'yTickLabels',[0:0.5:1.5],'FontSize',14,'linewidth',2);
ylabel('PI-velocity','FontSize',14);
axis square
box off;

subplot(2,4,6); hold on;
plot([0.5 1.5],[mean(DataVo(:,3)) mean(DataVo(:,3))],'b-','LineWidth',2)
plot([1.5 2.5],[mean(DataVo_else(:,3)) mean(DataVo_else(:,3))],'r-','LineWidth',2)
errorbar([1],[mean(DataVo(:,3))],[std(DataVo(:,3))]/sqrt(size(DataVo,1)),'k.','LineWidth',2,'CapSize',0);
errorbar([2],[mean(DataVo_else(:,3))],[std(DataVo_else(:,3))]/sqrt(size(DataVo_else,1)),'k.','LineWidth',2,'CapSize',0);
swarmchart([1*ones(size(DataVo,1),1)],[DataVo(:,3)],80,'blue','XJitterWidth',0.5);
swarmchart([2*ones(size(DataVo_else,1),1)],[DataVo_else(:,3)],80,'red','XJitterWidth',0.5);
title('ACA PI-volume','FontSize',16);
set(gca,'xlim',[0 3],'xTick',[1.5],'XTickLabels',{'ACA'},'FontSize',14,'linewidth',2);
% set(gca,'ylim',[0 0.4],'yTick',[0:0.1:0.4],'yTickLabels',[0:0.1:0.4],'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 0.6],'yTick',[0:0.2:0.6],'FontSize',14,'linewidth',2);
ylabel('PI-volume','FontSize',14);
axis square
box off;

% draw MCA
subplot(2,4,3); hold on;
plot([0.5 1],[mean(DataVe(:,4)) mean(DataVe(:,4))],'b-','LineWidth',2)
plot([2.5 3],[mean(DataVe(:,5)) mean(DataVe(:,5))],'b-','LineWidth',2)
plot([4.5 5],[mean(DataVe(:,6)) mean(DataVe(:,6))],'b-','LineWidth',2)
plot([1 1.5],[mean(DataVe_else(:,4)) mean(DataVe_else(:,4))],'r-','LineWidth',2)
plot([3 3.5],[mean(DataVe_else(:,5)) mean(DataVe_else(:,5))],'r-','LineWidth',2)
plot([5 5.5],[mean(DataVe_else(:,6)) mean(DataVe_else(:,6))],'r-','LineWidth',2)
% plot([1 3 5],[mean(DataVe_else(:,4),1) mean(DataVe_else(:,5),1) mean(DataVe_else(:,6),1)],'mo','LineWidth',2)
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
axis square
box off;

subplot(2,4,7); hold on;
plot([0.5 1],[mean(DataVo(:,4)) mean(DataVo(:,4))],'b-','LineWidth',2)
plot([2.5 3],[mean(DataVo(:,5)) mean(DataVo(:,5))],'b-','LineWidth',2)
plot([4.5 5],[mean(DataVo(:,6)) mean(DataVo(:,6))],'b-','LineWidth',2)
plot([1 1.5],[mean(DataVo_else(:,4)) mean(DataVo_else(:,4))],'r-','LineWidth',2)
plot([3 3.5],[mean(DataVo_else(:,5)) mean(DataVo_else(:,5))],'r-','LineWidth',2)
plot([5 5.5],[mean(DataVo_else(:,6)) mean(DataVo_else(:,6))],'r-','LineWidth',2)
% plot([1 3 5],[mean(DataVo_else(:,4),1) mean(DataVo_else(:,5),1) mean(DataVo_else(:,6),1)],'mo','LineWidth',2)
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
% set(gca,'ylim',[0 0.4],'yTick',[0:0.1:0.4],'yTickLabels',[0:0.1:0.4],'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 0.6],'yTick',[0:0.2:0.6],'FontSize',14,'linewidth',2);
ylabel('PI-volume','FontSize',14);
axis square
box off;

% draw PCA
subplot(2,4,4); hold on;
plot([0.5 1],[mean(DataVe(:,7)) mean(DataVe(:,7))],'b-','LineWidth',2)
plot([2.5 3],[mean(DataVe(:,8)) mean(DataVe(:,8))],'b-','LineWidth',2)
plot([1 1.5],[mean(DataVe_else(:,7)) mean(DataVe_else(:,7))],'r-','LineWidth',2)
plot([3 3.5],[mean(DataVe_else(:,8)) mean(DataVe_else(:,8))],'r-','LineWidth',2)
errorbar([0.75 2.75],[mean(DataVe(:,7)) mean(DataVe(:,8))],[std(DataVe(:,7)) std(DataVe(:,8))]/sqrt(size(DataVe,1)),'k.','LineWidth',2,'CapSize',0);
errorbar([1.25 3.25],[mean(DataVe_else(:,7)) mean(DataVe_else(:,8))],[std(DataVe_else(:,7)) std(DataVe_else(:,8))]/sqrt(size(DataVe_else,1)),'k.','LineWidth',2,'CapSize',0);
swarmchart([0.75*ones(size(DataVe,1),1)],[DataVe(:,7)],50,'blue','XJitterWidth',0.5);
swarmchart([2.75*ones(size(DataVe,1),1)],[DataVe(:,8)],50,'blue','XJitterWidth',0.5);
swarmchart([1.25*ones(size(DataVe_else,1),1)],[DataVe_else(:,7)],50,'red','XJitterWidth',0.5);
swarmchart([3.25*ones(size(DataVe_else,1),1)],[DataVe_else(:,8)],50,'red','XJitterWidth',0.5);
title('PCA PI-velocity','FontSize',16);
set(gca,'xlim',[0 4],'xTick',[1 3],'XTickLabels',{'PCA1','PCA2'},'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 1.5],'yTick',[0:0.5:1.5],'yTickLabels',[0:0.5:1.5],'FontSize',14,'linewidth',2);
ylabel('PI-velocity','FontSize',14);
axis square
box off;

subplot(2,4,8); hold on;
plot([0.5 1],[mean(DataVo(:,7)) mean(DataVo(:,7))],'b-','LineWidth',2)
plot([2.5 3],[mean(DataVo(:,8)) mean(DataVo(:,8))],'b-','LineWidth',2)
plot([1 1.5],[mean(DataVo_else(:,7)) mean(DataVo_else(:,7))],'r-','LineWidth',2)
plot([3 3.5],[mean(DataVo_else(:,8)) mean(DataVo_else(:,8))],'r-','LineWidth',2)
errorbar([0.75 2.75],[mean(DataVo(:,7)) mean(DataVo(:,8))],[std(DataVo(:,7)) std(DataVo(:,8))]/sqrt(size(DataVo,1)),'k.','LineWidth',2,'CapSize',0);
errorbar([1.25 3.25],[mean(DataVo_else(:,7)) mean(DataVo_else(:,8))],[std(DataVo_else(:,7)) std(DataVo_else(:,8))]/sqrt(size(DataVo_else,1)),'k.','LineWidth',2,'CapSize',0);
swarmchart([0.75*ones(size(DataVo,1),1)],[DataVo(:,7)],50,'blue','XJitterWidth',0.5);
swarmchart([2.75*ones(size(DataVo,1),1)],[DataVo(:,8)],50,'blue','XJitterWidth',0.5);
swarmchart([1.25*ones(size(DataVo_else,1),1)],[DataVo_else(:,7)],50,'red','XJitterWidth',0.5);
swarmchart([3.25*ones(size(DataVo_else,1),1)],[DataVo_else(:,8)],50,'red','XJitterWidth',0.5);
title('PCA PI-volume','FontSize',16);
set(gca,'xlim',[0 4],'xTick',[1 3],'XTickLabels',{'PCA1','PCA2'},'FontSize',14,'linewidth',2);
set(gca,'ylim',[0 0.6],'yTick',[0:0.2:0.6],'FontSize',14,'linewidth',2);
% set(gca,'ylim',[0 0.4],'yTick',[0:0.1:0.4],'yTickLabels',[0:0.1:0.4],'FontSize',14,'linewidth',2);
ylabel('PI-volume','FontSize',14);
axis square
box off;


