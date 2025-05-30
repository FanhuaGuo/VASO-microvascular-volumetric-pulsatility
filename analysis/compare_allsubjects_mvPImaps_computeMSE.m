clc
clear all
close all

%% load data and set some parameters
dataPath = '/Users/guofanhua/Desktop/gfh/work/experiment/VASO_pulsatility2023/SUMA/GroupPImaps/MSEdata';
fnames = [dir([dataPath '/MSE_*.1D'])];
subjs = {'S01','S02','S03','S04','S05','S06','S07','S08','S09','S10','S11','S12','S13','S14','S15','S16','S17','S18','S19','S20','S21','S22','S23','S24','S25','S26','S27','S28'};
which_subj = [1 2 4 6 8:11 13:16 18:28];
GroupAge = [0 0 0 0 0 ...
            0 0 0 0 0 ...
            0 0 1 0 0 ...
            0 0 1 1 1 ...
            1 1 1 1 1 ...
            1 1 1];

%% disposal data
Matrix_s1s1 = zeros(numel(subjs));
Matrix_s2s1 = zeros(numel(subjs));
Matrix_s2s2 = zeros(numel(subjs));

for i = 1:numel(fnames)
    tmpData = load([fnames(i).folder '/' fnames(i).name]);
    tmpsubj1 = str2num(fnames(i).name(6:7));
    tmpsubj2 = str2num(fnames(i).name(12:13));
    tmpsession1 = str2num(fnames(i).name(9));
    tmpsession2 = str2num(fnames(i).name(15));
    if tmpsession1 == 1 && tmpsession2 == 1
        Matrix_s1s1(tmpsubj1,tmpsubj2) = tmpData;
    end
    if tmpsession1 == 2 && tmpsession2 == 1
        Matrix_s2s1(tmpsubj1,tmpsubj2) = tmpData;
    end
    if tmpsession1 == 2 && tmpsession2 == 2
        Matrix_s2s2(tmpsubj1,tmpsubj2) = tmpData;
    end
end

set0 = [20];
for i = set0
    Matrix_s1s1(i,:) = 0;
    Matrix_s1s1(:,i) = 0;
    Matrix_s2s1(i,:) = 0;
    Matrix_s2s1(:,i) = 0;
end


group_same = [Matrix_s2s1(1,1); Matrix_s2s1(2,2); Matrix_s2s1(4,4); Matrix_s2s1(9,9); Matrix_s2s1(10,10); Matrix_s2s1(11,11)];
group_diff_yy = [];
group_diff_ye = [];
group_diff_ee = [];
xuan1 = zeros(numel(subjs));
xuan2 = zeros(numel(subjs));
xuan3 = zeros(numel(subjs));
for i = 1:size(Matrix_s1s1,1)
    for j = 1:size(Matrix_s1s1,1)
        tmp = GroupAge(i)+GroupAge(j);
        if i < j && Matrix_s1s1(i,j)>0
            xuan1(i,j) = 1;
            switch tmp
                case 0
                    group_diff_yy = [group_diff_yy; Matrix_s1s1(i,j)];
                case 1
                    group_diff_ye = [group_diff_ye; Matrix_s1s1(i,j)];
                case 2
                    group_diff_ee = [group_diff_ee; Matrix_s1s1(i,j)];
            end
        end
        if i ~= j && Matrix_s2s1(i,j)>0
            xuan2(i,j) = 1;
            switch tmp
                case 0
                    group_diff_yy = [group_diff_yy; Matrix_s2s1(i,j)];
                case 1
                    group_diff_ye = [group_diff_ye; Matrix_s2s1(i,j)];
                case 2
                    group_diff_ee = [group_diff_ee; Matrix_s2s1(i,j)];
            end
        end
        if i < j && Matrix_s2s2(i,j)>0
            xuan3(i,j) = 1;
            switch tmp
                case 0
                    group_diff_yy = [group_diff_yy; Matrix_s2s2(i,j)];
                case 1
                    group_diff_ye = [group_diff_ye; Matrix_s2s2(i,j)];
                case 2
                    group_diff_ee = [group_diff_ee; Matrix_s2s2(i,j)];
            end
        end
    end
end








