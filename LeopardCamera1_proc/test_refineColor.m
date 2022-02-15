clear all; close all; clc;

% path = "./data/test_autoAE.raw";
% path = "./ColorTest/daytime/test_1.raw";
% path = "./RAW2/20211025_1/1635146766.71654.raw";        % 1635145115.09925.raw   1635146766.51228.raw   1635146766.71654.raw
% path = "D:\ZJU\Camera\WhiteBalance\LeopardCamera_rawConvert\RAW\1634807364.59086.raw";
% path = "./RAW2/20211022/1634895664.4416.raw"; % 浙江大学舟山校区——东港，走海天大道，傍晚，晴天; 东港——淘味城，走东西快速路，傍晚，晴天
% path = "./RAW2/20211025_1/1635146766.51228.raw"; % 下午，白天，晴天，海天大道——朱家尖
path = "./data/refineColor/20211025_2/1635152229.90448.raw"; % 下午，傍晚，晴天，朱家尖——海天大道
% path = "./RAW2/20211025_3/1635164418.18078.raw"; % 晚上，黑夜，晴天，舟山校区附近
% path = "./RAW2/20211026_1/1635195167.31188.raw"; % 晚上
% path = "./RAW2/20211026_2/1635201130.62069.raw"; % 下午

img_rgb = raw2rgb(path, 1, 1, 1);

% refineColor1: 适用于傍晚晚上或者白天较暗等光线较弱场景，用了阈值为10的illumwhite，参数调整在第6行,值越小越亮，颜色拉得越多
% refineColor2: 适用于白天光线稍强场景，用了阈值为10的illumwhite和阈值为(9,7)的动态阈值算法，
% illumwhite参数调整在第6行，动态阈值调整在46,47行，第一个参数大了或第二个参数小了会过曝天空发白，过曝能改善天空发红

% refineColor3: 适用于图片中有很大一片天空的过曝场景,用了阈值为10的illumwhite和CCM校正
% 适合亮度很高的场景(如demo的20211025_1中几张图)

% refineColor4: 适用于图片中有很大一片天空的过曝场景,用了阈值为10的illumwhite和阈值为(7,9)的动态阈值算法和CCM校正
% 适合亮度不那么高的场景(如demo的20211025_2中几张图)，

% final_img = refineColor1(img_rgb);
% final_img = refineColor2(img_rgb);
% final_img = refineColor3(img_rgb);
final_img = refineColor4(img_rgb);

figure()
imshow([img_rgb final_img])


