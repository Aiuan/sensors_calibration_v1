%% 误差直方图
clear; close all; clc;
load ./runs_undistort_cut/allpoints;
load('./runs_undistort_cut/Hx.mat', 'Hx');
data_xyz=readmatrix("./data/TIRadar_points.xlsx", "Range", [1 1]);

error = [];
error_ignore = [];
for i=1:length(data)    
    xyz=data(i,1:3)';
    if sum(isnan(xyz)) ~= 0
        error(i) = -1;
        error_ignore(i) = 0;
        continue;
    end    
    xyz1=[xyz;ones(1,size(xyz,2))];
    uv1=Hx*xyz1*(diag(1./([0,0,1]*Hx*xyz1)));
    uv=uv1(1:2, :);
    uv = round(uv);
    if data_xyz(i,4) == 1
        error(i)=norm(uv - data(i,4:5)');
        error_ignore(i) = 0;
    else
        error(i) = 0;
        error_ignore(i) =norm(uv - data(i,4:5)');
    end
    
end
sum(error)
bar(error);
hold on;
bar(error_ignore);
grid on;
xlabel('groupId');
ylabel('(u, v) L2 error');
% ylim([0,50]);

%% 可视化检查
clear all; close all; clc;
SAVE_ON = 0;
WAITKEY_ON = 1-SAVE_ON;
load ./runs_undistort_cut/allpoints
load('./runs_undistort_cut/Hx.mat', 'Hx');
Pic_path='./data/LeopardCamera1_undistort_cut/';
save_results_folder = './data/results';

if ~exist(save_results_folder, "dir") && SAVE_ON
    mkdir(save_results_folder);
end

image_list = getImageListIncludeNotFound(Pic_path);
figure();
for i=1:length(image_list)
    xyz=data(i,1:3)';
    if sum(isnan(xyz)) ~= 0
        continue;
    end
    I=size(xyz,2);
    xyz=[xyz;ones(1,I)];
    xc=Hx*xyz*(diag(1./([0,0,1]*Hx*xyz)));
    xc=floor(xc);
    xc(3,:)=[];
    error(i)=norm(xc - data(i,4:5)');    
    image = imread(image_list(i).path);
    imshow(image);
    hold on;
    scatter(data(i,4), data(i,5), 'filled', 'g');
    scatter(xc(1), xc(2), 'filled', 'r');    
    hold off;
    title([image_list(i).name, '    Error = ',num2str(error(i)), '    GT = (', num2str(data(i,4)), ',', num2str(data(i,4)), ')    Transfer = (', num2str(xc(1)), ',', num2str(xc(2)), ')']); 
    if SAVE_ON
        saveas(gcf, [save_results_folder, '/match', num2str(i), '.png']);
    end 
    if WAITKEY_ON == 1
        %按键下一帧         
        key = waitforbuttonpress;
        while(key==0)
            key = waitforbuttonpress;
        end
    end   
end
