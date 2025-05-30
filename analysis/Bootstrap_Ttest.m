function [ outputP ] = Bootstrap_Ttest( inputData )
% paired T-test by bootstrap
%%
num_subj = size(inputData,1);
NumSample = 10000;
BootStrap = [];
for i = 1:NumSample
    rand_subj = unidrnd(num_subj,num_subj,1);
    BootStrap = [BootStrap; mean(inputData(rand_subj,:))];
end
Mean_Random = mean(BootStrap);

outputP = [];
for i = 1:size(inputData,2)
    if Mean_Random(i) > 0
        outputP = [outputP 2*sum(BootStrap(:,i)<0)/NumSample];
    else
        outputP = [outputP 2*sum(BootStrap(:,i)>0)/NumSample];
    end
end


end

