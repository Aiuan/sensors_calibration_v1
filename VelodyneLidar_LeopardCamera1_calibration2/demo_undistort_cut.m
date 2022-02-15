clear; close all; clc;

% 自测坐标系 转换至 像素坐标系
image_folder = "./data/demo/png";
pcd_folder = "./data/demo/pcd";
transformMatrix_path = "./VelodyneLidar_LeopardCamera1_TF_undistort_cut.mat";
intrinsicsMatrix_path = "./LeopardCamera1_undistort_cut.mat";
WAITKEY_ON = 1;
SHOW_DISTANCE_X_MIN = 5;
SHOW_DISTANCE_X_MAX = 300;

images_info = dir(fullfile(image_folder, "*.png"));
pcds_info = dir(fullfile(pcd_folder, "*.pcd"));
num_samples = min(length(images_info), length(pcds_info));

theta = 90;
mycoordinate_to_officialcoordinate_transformMatrix = [cos(pi/180*theta), -sin(pi/180*theta), 0, 0; sin(pi/180*theta), cos(pi/180*theta), 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];

load(transformMatrix_path, "newTform");
transformMatrix = newTform.T' * mycoordinate_to_officialcoordinate_transformMatrix;
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
    intensity = pcd.Intensity;
    mask = (xyz(:, 1) > SHOW_DISTANCE_X_MIN);
    xyz = xyz(mask, :);
    intensity = intensity(mask, :);
    mask = (xyz(:, 1) < SHOW_DISTANCE_X_MAX);
    xyz = xyz(mask, :);
    intensity = intensity(mask, :);
    
    xyz1 = [xyz'; ones(1, size(xyz,1))];
    UVZ = intrinsicsMatrix * transformMatrix * xyz1;
    uv1 = UVZ ./ UVZ(3, :);
    uv = uv1(1:2, :)';
    
    figure(1);
    imshow(image);
    hold on;
    scatter3(uv(:, 1), uv(:, 2), xyz(:, 1), 2, xyz(:, 1), "filled");
    colormap("jet");
    
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