% Create a hybrid image (Peyman Shobeiri)

img1 = imread("fish.bmp");
img2 = imread("submarine.bmp");

% Converting the images to grayscale 
img1_gray = rgb2gray(img1);
img2_gray = rgb2gray(img2);

% Apply a low pass filter 
low_filter = fspecial('gaussian', [15,15], 5);
low_pass = imfilter(img2_gray,low_filter);

% Apply a hight pass filter
high_filter = fspecial('gaussian', [15,15], 5);
high_pass = img1_gray - imfilter(img1_gray, high_filter);

% Create a hybrid image
hybrid_image = low_pass + high_pass;

% Show the result 
imshow(hybrid_image)