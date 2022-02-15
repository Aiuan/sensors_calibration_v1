function roi = helperComputeROI(imageCorners3d, tolerance)
%helperComputeROI computes ROI in lidar coordinate system using
%   checkerboard 3d corners in camera coordinate system
%
% This is an example helper function that is subject to change or removal in
% future releases.

% Copyright 2019-2020 The MathWorks, Inc.


xCamera = reshape(imageCorners3d(:, 1, :), [], 1);
yCamera = reshape(imageCorners3d(:, 2, :), [], 1);
zCamera = reshape(imageCorners3d(:, 3, :), [], 1);

% camera 与 lidar 的坐标系转换关系
xMaxLidar = max(xCamera) + tolerance;
xMinLidar = min(xCamera) - tolerance;

yMaxLidar = max(zCamera) + tolerance;
yMinLidar = min(zCamera) - tolerance;

zMaxLidar = max(-yCamera) + tolerance;
zMinLidar = min(-yCamera) - tolerance;

roi = [xMinLidar, xMaxLidar, yMinLidar, yMaxLidar, zMinLidar, zMaxLidar];
end