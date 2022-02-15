% 文件夹中raw转png，且进行去畸变、裁剪操作，保存在指定文件夹
clear all; close all; clc;

folder_output = "F:\senser_calibration\code\LeopardCamera1_proc\data\refineColor\20211026_2_png";
folder_input = "F:\senser_calibration\code\LeopardCamera1_proc\data\refineColor\20211026_2";
intrinsics_path = "./LeopardCamera1_oringin.mat";

info_raws = dir(strcat(folder_input, "\*.raw"));
load(intrinsics_path);

if ~exist(folder_output)
    fprintf("创建输出文件夹：%s\n", folder_output);
    mkdir(folder_output);
end

tic;
parfor i = 1:length(info_raws)    
    % RAW12转RGB
    rawFilename = info_raws(i).name;
    rawFilepath = strcat(folder_input, "\", rawFilename);
    image_rgb = raw2rgb(rawFilepath);
%     useTime = toc;
%     sprintf("单张RAW12转RGB耗时：%.3f", useTime);    
    % 去畸变
    image_undistort = undistortImage(image_rgb, cameraParams, "OutputView", "valid");
    image_undistort_cut = image_undistort(1:1700, :, :);
    % 保存图片
    pngFilename = replace(rawFilename, ".raw", ".png");
    pngFilepath = strcat(folder_output, "\", pngFilename);
    imwrite(image_undistort_cut, pngFilepath);    
    fprintf("%d/%d\n", i, length(info_raws));   
end
useTime = toc;
fprintf("处理耗时：%.3f s\n", useTime);   