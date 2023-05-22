% read the image
img = imread('rocky.JPG');

% convert the image into the gray scale image 
gray_scale = rgb2gray(img);
subplot(4,2,1)
imshow(gray_scale)

% create a filter with the sigma = 1
filter = fspecial('gaussian', [5 5], 1);

% apply the filter on the image
blurred = imfilter(gray_scale, filter, 'replicate');

different = gray_scale - blurred;
subplot(4,2,2)
imshow(different);

% doing the same thing for sigma = 1 up to sigma = 6
for sigma = 1:6
    filter = fspecial('gaussian', [5,5], sigma);
    blurred = imfilter(gray_scale, filter, 'replicate');
    different = gray_scale - blurred;
    subplot(4,2,sigma + 2)
    imshow(different)
end