clear all; close all; clc;

folder_output = "./data/pcd";
folder_csv = "./data/VelodyneLidar_selected";
info_csvs = dir(strcat(folder_csv, "/", "*.csv"));

for i = 1 : length(info_csvs)
    name_csv = info_csvs(i).name;
    path_csv = strcat(folder_csv, "/", name_csv);
    info_pointcloud = csvread(path_csv, 1, 0);
    xyz = pointCloud(info_pointcloud(:, 9:11));
    path_output = strcat(folder_output, "/", num2str(i), ".pcd");
    pcwrite(xyz,path_output,'Encoding','ascii');
end