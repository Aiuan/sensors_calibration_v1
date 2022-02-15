% 文件夹中raw转png，保存在指定文件夹
clear all; close all; clc;

folder_output = "F:\senser_calibration\VelodyneLidar_LeopardCamera1_calibration\LeopardCamera1_proc";
folder_input = "F:\senser_calibration\VelodyneLidar_LeopardCamera1_calibration\LeopardCamera1";
info_raws = dir(strcat(folder_input, "\*.raw"));

for i = 1:length(info_raws)
    tic;
    % RAW12转RGB
    rawFilename = info_raws(i).name;
    rawFilepath = strcat(folder_input, "\", rawFilename);
    img_rgb = raw2rgb(rawFilepath);
%     useTime = toc;
%     sprintf("单张RAW12转RGB耗时：%.3f", useTime);    
    % 保存图片
    pngFilename = replace(rawFilename, ".raw", ".png");
    pngFilepath = strcat(folder_output, "\", pngFilename);
    imwrite(img_rgb, pngFilepath);    
    useTime = toc;
    fprintf("%d/%d处理耗时：%.3f s\n", i, length(info_raws), useTime);    
end