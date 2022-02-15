clear; close all; clc;

% 官方坐标系 转换至 像素坐标系 
image_folder = "./data/png_undistortion";
pcd_folder = "./data/pcd";
transformMatrix_path = "./VelodyneLidar_LeopardCamera1_TF_undistort.mat";
intrinsicsMatrix_path = "./LeopardCamera1_undistort.mat";
WAITKEY_ON = 1;

images_info = dir(fullfile(image_folder, "*.png"));
pcds_info = dir(fullfile(pcd_folder, "*.pcd"));
num_samples = min(length(images_info), length(pcds_info));

load(transformMatrix_path, "newTform");
transformMatrix = newTform.T';
transformMatrix = transformMatrix(1:3, :);

load(intrinsicsMatrix_path, "cameraParams");
intrinsicsMatrix = cameraParams.IntrinsicMatrix;
intrinsicsMatrix = intrinsicsMatrix';

for i = 1:num_samples
    image_path = getImagePathById(i, image_folder);
    pcd_path = getPcdPathById(i, pcd_folder);
    
    image = imread(image_path); % 输入图像已经去过畸变，因此不用再去畸变
    pcd = pcread(pcd_path);
    
    xyz = pcd.Location;
    xyz1 = [xyz'; ones(1, size(xyz,1))];
    UVZ = intrinsicsMatrix * transformMatrix * xyz1;
    uv1 = UVZ ./ UVZ(3, :);
    uv = uv1(1:2, :)';
    
    figure(1);
    imshow(image);
    hold on;
    scatter(uv(:, 1), uv(:, 2), 2, "r", "filled");
    
    if WAITKEY_ON == 1
        %按键下一帧         
        key = waitforbuttonpress;
        while(key==0)
            key = waitforbuttonpress;
        end
    end   
    
end

function image_path = getImagePathById(i, image_folder)
    temp = dir(fullfile(image_folder, strcat(num2str(i), ".png")));
    image_path = fullfile(temp.folder, temp.name);
end

function pcd_path = getPcdPathById(i, pcd_folder)
    temp = dir(fullfile(pcd_folder, strcat(num2str(i), ".pcd")));
    pcd_path = fullfile(temp.folder, temp.name);
end