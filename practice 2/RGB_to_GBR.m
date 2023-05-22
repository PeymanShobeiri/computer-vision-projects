% read the image
img = imread('rocky.JPG');

% split the channels of the image
red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);

% using cat commant in order to merge this channels
new_img = cat(3, green, blue, red);

imshow(new_img);

% در این کد ابتدا یک تصویر را از ورودی میخوانیم سپس کانال های رنگی ان را با
%دستور فوق جدا میکنیم و در نهایت با دستور کت این کانال ها را به صورت دلخواه
%کنار هم ادغام میکنیم     