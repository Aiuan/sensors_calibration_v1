% 测试rgb图像去畸变、调色、裁剪
clear all; close all; clc;

path = "./data/2.png";
intrinsics_path = "./LeopardCamera1_oringin.mat";
load(intrinsics_path);

image = imread(path);
% 去畸变
image_undistort = undistortImage(image, cameraParams, "OutputView", "valid");



% 裁剪
figure();
imshow(image_undistort);
rectangle("Position", [1, 1, 3517-1, 1700-1], "EdgeColor", "r", "LineWidth", 2);
image_undistort_cutReshape = image_undistort(1:1700, :, :);
figure();
imshow(image_undistort_cutReshape);




