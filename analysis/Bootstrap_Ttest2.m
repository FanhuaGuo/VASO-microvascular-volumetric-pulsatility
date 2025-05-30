function [ outputP ] = Bootstrap_Ttest2( inputData1 , inputData2 )
% independent T-test by bootstrap
%%
num_subj1 = size(inputData1,1);
num_subj2 = size(inputData2,1);
NumSample = 10000;
BootStrap = [];
for i = 1:NumSample
    rand_subj1 = unidrnd(num_subj1,num_subj1,1);
    rand_subj2 = unidrnd(num_subj2,num_subj2,1);
    BootStrap = [BootStrap; mean(inputData1(rand_subj1,:))-mean(inputData2(rand_subj2,:))];
end
Mean_Random = mean(BootStrap);

outputP = [];
for i = 1:size(inputData1,2)
    if Mean_Random(i) > 0
        outputP = [outputP 2*sum(BootStrap(:,i)<0)/NumSample];
    else
        outputP = [outputP 2*sum(BootStrap(:,i)>0)/NumSample];
    end
end


end

