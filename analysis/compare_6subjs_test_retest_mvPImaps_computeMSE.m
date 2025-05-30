clc
clear all
close all

%% load data and set some parameters
Data_Ori = load('/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/SUMA/GroupPImaps/compare_6subjs_PImaps.1D');


%% calc
Data = Data_Ori(:,4:end);
MSE_matrix = zeros(6,6);
Data1 = [];
Data2 = [];
for i = 1:12
    for j = 1:12
        tmpData = Data(:,i)-Data(:,j);
        tmp = sum(tmpData.^2)/numel(tmpData);
        MSE_matrix(i,j) = tmp;
        if i<j
            if (j-i == 1) && ((i == 1)||(i == 3)||(i == 5)||(i == 7)||(i == 9)||(i == 11))
                Data1 = [Data1; tmp];
            else
                Data2 = [Data2; tmp];
            end
        end
    end
end

save('/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/Draft/figure/PlotCode/figure3B_compare_6subjs_PImaps.mat','Data1','Data2','MSE_matrix');



