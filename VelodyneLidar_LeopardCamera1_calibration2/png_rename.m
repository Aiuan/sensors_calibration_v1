clear all; close all; clc;

folder_output = "./data/png";
folder_img = "./data/LeopardCamera1_selected_recolor";
info_imgs = dir(strcat(folder_img, "/", "*.png"));

for i = 1 : length(info_imgs)
    name_img = info_imgs(i).name;
    path_img = strcat(folder_img, "/", name_img);    
    path_output = strcat(folder_output, "/", num2str(i), ".png");
    copyfile(path_img, path_output);
end