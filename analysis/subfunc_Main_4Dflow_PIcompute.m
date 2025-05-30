function [ ProfileVelocity , ProfileVolume , PI_Ve , PI_Vo ] = subfunc_Main_4Dflow_PIcompute( Input_dir , hemi , NameRegion , label , Proportion_pick , Threshold_MagneticVariation , Threshold_BloodVelocity , Threshold_velocity )
% compute the vePI and voPI for 4D-flow 

%% read data and calculate the mask of plane
switch NameRegion
    case 'ACA'
        V_P1 = load([Input_dir '/4DflowP1' hemi '.' NameRegion '.1D']);
        V_P2 = load([Input_dir '/4DflowP2' hemi '.' NameRegion '.1D']);
        V_P3 = load([Input_dir '/4DflowP3' hemi '.' NameRegion '.1D']);
        M = load([Input_dir '/4DflowM' hemi '.' NameRegion '.1D']);
    otherwise
        V_P1 = load([Input_dir '/4DflowP1' hemi '.' NameRegion num2str(label) '.1D']);
        V_P2 = load([Input_dir '/4DflowP2' hemi '.' NameRegion num2str(label) '.1D']);
        V_P3 = load([Input_dir '/4DflowP3' hemi '.' NameRegion num2str(label) '.1D']);
        M = load([Input_dir '/4DflowM' hemi '.' NameRegion num2str(label) '.1D']);
end
Mask = subfunc_FindAllVoxelsInPlane(M,V_P1,V_P2,V_P3);

% calculate the volume of a single voxel
size_voxel = [];
for i = 1:3
    tmp = abs(M(1,i)-M(2:end,i));
    tmp(tmp<0.1) = [];
    size_voxel = [size_voxel min(tmp)];
end
volume_voxel = size_voxel(1)*size_voxel(2)*size_voxel(3);

%% calculate the vessel weight volume of each voxel
Wv = [];
for i = 1:size(M,2)-3
    tmpM = M(:,i+3);
    tmpM = sort(tmpM);
    Mv = mean(tmpM(end-ceil(Proportion_pick*numel(tmpM))+1:end));
    Mt = mean(tmpM(1:ceil(Proportion_pick*numel(tmpM))));
    Wv = [Wv (M(:,i+3)-Mt)/(Mv-Mt)];
end

% initial select vessel
tmpM = max(M(:,4:end)')'-min(M(:,4:end)')';
Wv(tmpM<Threshold_MagneticVariation,:) = 0;

V = sqrt(V_P1(:,4:end).^2 +V_P2(:,4:end).^2 +V_P3(:,4:end).^2);
Wv(V<Threshold_BloodVelocity) = 0;

%% calculate the volume profile and velocity profile
Wv = Wv(Mask,:);
Velocity = V(Mask,:);
tmp = mean(Wv,2);
ProfileVelocity = mean(Velocity(tmp>Threshold_velocity,:));
ProfileVolume = sum(Wv)*volume_voxel/1;
PI_Ve = (max(ProfileVelocity)-min(ProfileVelocity))/mean(ProfileVelocity);
PI_Vo = (max(ProfileVolume)-min(ProfileVolume))/mean(ProfileVolume);

end

