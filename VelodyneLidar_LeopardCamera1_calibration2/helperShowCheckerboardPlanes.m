function helperShowCheckerboardPlanes(ptCloudFileNames, indices)
%helperShowCheckerboardPlanes To visualize lidar features.
%
% This is an example helper function that is subject to change or removal in
% future releases.

% Copyright 2019-2020 The MathWorks, Inc.

figureH = figure();
panel = uipanel('Parent',figureH,'Title','Lidar Features');
ax = axes('Parent',panel,'Color',[0,0,0],'Position',[0 0 1 1],'NextPlot','add');
axis(ax,'equal');
zoom on;
scatterH = scatter3(ax, nan, nan, nan, 7, '.');
view(ax,3);
campos([-117.6074  -48.5841   53.3789]);

numFrames = numel(ptCloudFileNames);
for i = 1:numFrames
    ptCloud = pcread(ptCloudFileNames{i});
    xyzPts = ptCloud.Location;
    % check if the point cloud is organized
    if ~ismatrix(xyzPts)
        x = reshape(xyzPts(:, :, 1), [], 1);
        y = reshape(xyzPts(:, :, 2), [], 1);
        z = reshape(xyzPts(:, :, 3), [], 1);
        xyzPts = [x, y, z];
    else
        x = xyzPts(:, 1);
        y = xyzPts(:, 2);
        z = xyzPts(:, 3);
    end
    
    % Fill magenta color to the input
    ptCloud = pointCloud(xyzPts);
    color = uint8([255*ones(size(ptCloud.Location, 1), 1),...
        zeros(size(ptCloud.Location, 1), 1), 255*ones(size(ptCloud.Location, 1), 1)]);
    
    x = ptCloud.Location(:, 1);
    y = ptCloud.Location(:, 2);
    z = ptCloud.Location(:, 3);
    r = color(:, 1);
    g = color(:, 2);
    b = color(:, 3);
    ptCloud.Color = color;
    
    plane = select(ptCloud, indices{i});
    r(indices{i}) = zeros(plane.Count, 1);
    g(indices{i}) = 255*ones(plane.Count, 1);
    b(indices{i}) = zeros(plane.Count, 1);
    
    planeSize = plane.Count;
    planeColor = uint8([zeros(planeSize, 1),...
        255*ones(planeSize, 1), zeros(planeSize, 1)]);
    plane.Color = planeColor;
    
    % update point cloud
    set(scatterH,'XData',x,'YData',y,'ZData',z, 'CData', [r,g,b]);
    pause(1);
end
end