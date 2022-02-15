clear all;close all;clc;

%% standard demo
standard = load("LeopardCamera1_standard.mat");
I = imread("./data/17.bmp");
figure();
subplot(1,3,1);
imshow(I);
[J1, newOrigin1] = undistortImage(I,standard.cameraParams, "OutputView", "valid");
subplot(1,3,2);
imshow(J1);

% 对比standard和fisheye virtual
fisheye = load("LeopardCamera1_fisheye_virtual.mat");
[J2, newOrigin2] = undistortImage(I,fisheye.camIntrinsics1);
subplot(1,3,3);
imshow(J2);

%% fisheye demo

fisheye = load("LeopardCamera1_fisheye.mat");
I = imread("./data/17.bmp");
figure();
imshow(I);
[J1,camIntrinsics1] = undistortFisheyeImage(I, fisheye.cameraParams.Intrinsics, "OutputView", "same");
figure();
imshow(J1);
[J2,camIntrinsics2] = undistortFisheyeImage(I, fisheye.cameraParams.Intrinsics, "OutputView", "valid");
figure();
imshow(J2);
[J3,camIntrinsics3] = undistortFisheyeImage(I, fisheye.cameraParams.Intrinsics, "OutputView", "full");
figure();
imshow(J3);
