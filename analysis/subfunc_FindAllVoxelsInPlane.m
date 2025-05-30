function [ Mask ] = subfunc_FindAllVoxelsInPlane( M , P1 , P2 , P3 )
%  Accroding M/P1/P2/P3 maps, we can compute the plane which is vertical to
% this blood vessel. Then return a logical matrix with mask of voxels in
% this plane. 

%% calculate coordinate of the center point
Coord_center = [];
for i = 1:2
    Coord_center = [Coord_center (max(M(:,i))+min(M(:,i)))/2];
end
tmpROI = (M(:,1)==max(M(:,1))) + (M(:,1)==min(M(:,1))) + (M(:,2)==max(M(:,2))) + (M(:,2)==min(M(:,2)));
tmpROI = tmpROI > 0;
Coord_center = [Coord_center mean(M(tmpROI,3))];

%% calculate the vertical vector (orient of blood flow)
% record the distance of all voxels to center point
tmp = [sqrt((M(:,1)-Coord_center(1)).^2 +(M(:,2)-Coord_center(2)).^2 +(M(:,3)-Coord_center(3)).^2) ...
       mean(M(:,4:end),2)  mean(P1(:,4:end),2)  mean(P2(:,4:end),2)  mean(P3(:,4:end),2)];

% find voxels that are likely to be blood vessels accroding to M value
tmp = tmp(tmp(:,2)>100,:);

% calculate the orient(blood flow) the most close 20% voxels
tmp = sortrows(tmp,1);
vector_vertical = mean(tmp(1:round(size(tmp,1)/5),3:5));

% change phase orient to coord orient
vector_vertical = vector_vertical([2 3 1]);


%% find the voxels which distance less than 0.5 mm
Cc = Coord_center;
Vv = vector_vertical;

% plane eqution: A(x-x0)+B(y-y0)+C(z-z0)=0
% distance eqution: (A(x-x0)+B(y-y0)+C(z-z0))/sqrt(A^2+B^2+C^2)

distance_map = (Vv(1)*(M(:,1)-Cc(1)) +Vv(2)*(M(:,2)-Cc(2)) +Vv(3)*(M(:,3)-Cc(3)))/sqrt(Vv(1)^2+Vv(2)^2+Vv(3)^2);
Mask = abs(distance_map)<=0.5;



end

