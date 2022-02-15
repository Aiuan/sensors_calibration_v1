clear; close all; clc;

image_folder = "./data/LeopardCamera1_proc/";
calibParam_path = "./LeopardCamera1.mat";
output_folder = "./data/LeopardCamera1_proc_undistortion_valid/";

load(calibParam_path);

if ~exist(output_folder, "dir")
    mkdir(output_folder);
end

image_info = getImageListIncludeNotFound(image_folder);
for i = 1 : length(image_info)
    tic;
    image_path = image_info(i).path;
    image = imread(image_path);
    image_undistort = undistortImage(image, cameraParams, "OutputView", "valid");
    output_path = strcat(output_folder, image_info(i).name);
    imwrite(image_undistort, output_path);
    time_use = toc;
    fprintf("%s, time_use = %f\n", output_path, time_use);
end
