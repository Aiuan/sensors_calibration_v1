clear all; close all; clc;

folder_output = "./data/png_undistort_cut";
folder_img = "./data/png";
info_imgs = dir(strcat(folder_img, "/", "*.png"));
load("./LeopardCamera1_oringin.mat");

for i = 1 : length(info_imgs)
    name_img = info_imgs(i).name;
    path_img = strcat(folder_img, "/", name_img);
    
    img = imread(path_img);
    img_undistort = undistortImage(img, cameraParams,'OutputView','valid');
    img_undistort_cut = img_undistort(1:1700, :, :);
    
    path_output = strcat(folder_output, "/", name_img);
    imwrite(img_undistort_cut, path_output);
end