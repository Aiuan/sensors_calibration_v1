% 文件夹中raw转png，且进行去畸变操作，保存在指定文件夹
clear all; close all; clc;

folder_output = "F:\20211031_1demo\LeopardCamera1\png_undistort";
folder_input = "F:\senser_calibration\VelodyneLidar_LeopardCamera1_calibration\LeopardCamera1";
intrinsics_path = "./LeopardCamera1_oringin.mat";

info_raws = dir(strcat(folder_input, "\*.raw"));
load(intrinsics_path);

for i = 1:length(info_raws)
    tic;
    % RAW12转RGB
    rawFilename = info_raws(i).name;
    rawFilepath = strcat(folder_input, "\", rawFilename);
    image_rgb = raw2rgb(rawFilepath);
%     useTime = toc;
%     sprintf("单张RAW12转RGB耗时：%.3f", useTime);    
    % 去畸变
    image_undistort = undistortImage(image_rgb, cameraParams, "OutputView", "valid");
    % 保存图片
    pngFilename = replace(rawFilename, ".raw", ".png");
    pngFilepath = strcat(folder_output, "\", pngFilename);
    imwrite(image_undistort, pngFilepath);    
    useTime = toc;
    fprintf("%d/%d处理耗时：%.3f s\n", i, length(info_raws), useTime);    
end