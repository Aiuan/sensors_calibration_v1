clear all; close all; clc;

folder_output = "./data/png";
folder_raw = "./data/LeopardCamera1_selected";
info_raw = dir(strcat(folder_raw, "/", "*.raw"));

for i = 1 : length(info_raw)
    name_raw = info_raw(i).name;
    path_raw = strcat(folder_raw, "/", name_raw);
    img_rgb = raw2rgb(path_raw);    
    
    path_output = strcat(folder_output, "/", num2str(i), ".png");
    imwrite(img_rgb, path_output);    
end