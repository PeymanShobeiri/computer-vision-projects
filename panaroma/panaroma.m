clear all;
close;
close all;

%% Initialization
images = imageDatastore('.');

% read the first image and capture its sizes
[M, N, ~] = size(readimage(images,1));

% read and resize the images in order to have a better performance
Array = cell(1, 6);
for i = 1:6
    Array{i} = readimage(images,i);
    Array{i} = imresize(Array{i}, [M, N]);
end

% Display images
montage(images.Files)

%% Detect features
% in this project i used Harris features detector but it did not do well so
% i change it ...
% detectHarrisFeatures
grayscale_image = im2gray(readimage(images,1));
points = detectSURFFeatures(grayscale_image);
[features, points] = extractFeatures(grayscale_image,points);

% number of images 
image_Num = numel(images.Files);
tforms(image_Num) = affine2d(eye(3));

% variable for image sizes
imageSize = zeros(image_Num, 2);

%% Match features

% since we find the first image features, we iterate over remaining ones
for i = 2:image_Num
    % save the info for i-1's image
    pointsPrevious = points;
    featuresPrevious = features;

    grayImage = im2gray(readimage(images, i));

    imageSize(i, :) = size(grayImage);

    points = detectSURFFeatures(grayImage);
    [features, points] = extractFeatures(grayImage, points);

    indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);

    matchedPoints = points(indexPairs(:, 1), :);
    matchedPointsPrev = pointsPrevious(indexPairs(:, 2), :);
    
    % Estimate the transformation between Array(n) and Array(n-1).
    tforms(i) = estimateGeometricTransform2D(matchedPoints, matchedPointsPrev, 'affine', 'Confidence', 99.9, 'MaxNumTrials', 2000);

    tforms(i).T = tforms(i - 1).T * tforms(i).T;
end

%% Evaluation of RANSAC

% output limits for each transformation.
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
end
avgXLim = mean(xlim, 2);
[~,idx] = sort(avgXLim);
centerIdx = floor((numel(tforms)+1)/2);
centerImageIdx = idx(centerIdx);
Tinv = invert(tforms(centerImageIdx));
for i = 1:numel(tforms)    
    tforms(i).T = Tinv.T * tforms(i).T;
end
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

maxImageSize = max(imageSize);

% min and max for the output limits. 
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height for our panaroma
width  = round(xMax - xMin);
height = round(yMax - yMin);

% the frame for our panaroma
panorama = zeros([height width 3], 'like', readimage(images,1));
blender = vision.AlphaBlender('Operation', 'Binary mask', 'MaskSource', 'Input port');  

xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

%% creating the panaroma image
for i= 1:image_Num

    warpedImage = imwarp(readimage(images,i), tforms(i), 'OutputView', panoramaView);

    mask = imwarp(true(size(readimage(images,i), 1), size(readimage(images,i), 2)), tforms(i), 'OutputView', panoramaView);

    panorama = step(blender, panorama, warpedImage, mask);
end

%% display the panaroma image
figure
imshow(panorama)














