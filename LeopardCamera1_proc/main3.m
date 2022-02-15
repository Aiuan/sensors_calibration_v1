% 文件夹中png进行去畸变操作，保存在指定文件夹
clear all; close all; clc;

folder_output = "F:\20211031_1demo\LeopardCamera1\png_undistort";
folder_input = "F:\20211031_1demo\LeopardCamera1\png";
intrinsics_path = "./LeopardCamera1_oringin.mat";

info_pngs = dir(strcat(folder_input, "\*.png"));
load(intrinsics_path);

parfor i = 1:length(info_pngs)
    tic;
    % RAW12转RGB
    pngFilename = info_pngs(i).name;
    pngFilepath = strcat(folder_input, "\", pngFilename);
    image_rgb = imread(pngFilepath);
%     useTime = toc;
%     sprintf("单张RAW12转RGB耗时：%.3f", useTime);    
    % 去畸变
    image_undistort = undistortImage(image_rgb, cameraParams, "OutputView", "valid");
    % 裁剪车前盖
    image_undistort_cut = image_undistort(1:1700, :, :);
    % 保存图片
    outputFilepath = strcat(folder_output, "\", pngFilename);
    imwrite(image_undistort_cut, outputFilepath);    
    useTime = toc;
    fprintf("%d/%d处理耗时：%.3f s\n", i, length(info_pngs), useTime);    
end