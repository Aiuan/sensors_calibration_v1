% 验证去畸变过程

clear; close all; clc;

load("./LeopardCamera1.mat");

image_path = "./data/LeopardCamera1_proc/7.bmp";

image = imread(image_path);
figure();
imshow(image);

[image_undistort_same, newOrigin_same] = undistortImage(image, cameraParams, "OutputView", "same");
figure();
imshow(image_undistort_same);
[image_undistort_valid, newOrigin_valid] = undistortImage(image, cameraParams, "OutputView", "valid");
figure();
imshow(image_undistort_valid);
rectangle('Position',[334, 71, 2880, 1860],'EdgeColor','b','LineWidth',2);
[image_undistort_full, newOrigin_full] = undistortImage(image, cameraParams, "OutputView", "full");
figure();
imshow(image_undistort_full);
rectangle('Position',[447, 284, 2880, 1860],'EdgeColor','b','LineWidth',2);
rectangle('Position',[114, 214, 3517, 2004],'EdgeColor','r','LineWidth',2);
%% undistort by myself
clear; close all; clc;

load("./LeopardCamera1_oringin.mat");

image_path = "./data/LeopardCamera1_proc/7.bmp";

image = imread(image_path);
figure();
imshow(image);

intrinsicMatrix = cameraParams.IntrinsicMatrix';
radiaDistortion = cameraParams.Intrinsics.RadialDistortion;

fx = intrinsicMatrix(1, 1);
fy = intrinsicMatrix(2, 2);
u0 = intrinsicMatrix(1, 3);
v0 = intrinsicMatrix(2, 3);
k1 = radiaDistortion(1);
k2 = radiaDistortion(2);


% [u, v] = meshgrid(1: size(image, 2), 1: size(image, 1));
% x = (u - u0) / fx;
% y = (v - v0) / fy;
% r = x.^2 + y.^2;
% x_ = x .* (1 + k1*r + k2*r.^2);
% y_ = y .* (1 + k1*r + k2*r.^2);
% 
% x__ = x_ * fx + u0;
% y__ = y_ * fy + v0;

for u = 1:size(image, 2)
    for v = 1:size(image, 1)
        x = (u - u0) / fx;
        y = (v - v0) / fy;
        
        r = x^2 + y^2;
        x_ = x * (1 + k1*r + k2*r.^2);
        y_ = y * (1 + k1*r + k2*r.^2);
        
        x__ = x_ * fx + u0;
        y__ = y_ * fy + v0;
        
        h = y__;
        w = x__;        
        if (h > 1 && h <= size(image, 1) && w > 1 && w <= size(image, 2))
            image_undistort(v, u, 1:3)=(floor(w+1)-w).*(floor(h+1)-h).*image(floor(h),floor(w), :)+...
                (floor(w+1)-w).*(h-floor(h)).*image(floor(h+1),floor(w), :)+...
                (w-floor(w)).*(floor(h+1)-h).*image(floor(h),floor(w+1), :)+...
                (w-floor(w)).*(h-floor(h)).*image(floor(h+1),floor(w+1), :);
        end
    end
end
figure();
imshow(image_undistort);


