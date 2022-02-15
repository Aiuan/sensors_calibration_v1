clear all; close all; clc;

folder_output = "./data/png_undistortion";
folder_img = "./data/png";
info_imgs = dir(strcat(folder_img, "/", "*.png"));
load("./LeopardCamera1.mat");

for i = 1 : length(info_imgs)
    name_img = info_imgs(i).name;
    path_img = strcat(folder_img, "/", name_img);
    
    img = imread(path_img);
    img_undistort = undistortImage(img, cameraParams,'OutputView','valid');
    
    path_output = strcat(folder_output, "/", name_img);
    imwrite(img_undistort, path_output);
end