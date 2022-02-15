% 将一个文件夹中能够的图像，去畸变，保存在指定目录中
clear; close all; clc;

image_folder = "./data/LeopardCamera1_proc/";
calibParam_path = "./LeopardCamera1_oringin.mat";
output_folder = "./data/LeopardCamera1_proc_undistortion_valid/";

load(calibParam_path);

if ~exist(output_folder, "dir")
    mkdir(output_folder);
end

image_info = dir(fullfile(image_folder, "*.bmp"));
for i = 1 : length(image_info)
    tic;
    image_path = fullfile(image_info(i).folder, image_info(i).name);
    image = imread(image_path);
    image_undistort = undistortImage(image, cameraParams, "OutputView", "valid");
    
    output_path = strcat(output_folder, image_info(i).name);
    imwrite(image_undistort, output_path);
    time_use = toc;
    fprintf("%s, time_use = %f\n", output_path, time_use);
end
