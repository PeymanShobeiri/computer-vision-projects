img = imread('pout.tif');

double_img = im2double(img);

img_log = log(double_img);

subplot(1,2,1)
imshow(img)
subplot(1,2,2)
imshow(img_log, [])

% با اعمال تابع لگاریتم بر روی تصویر مقادیر پیکسل های تصویر تغییر میکند که باعث افزایش کیفیت می شود. به عبارت دیگر با اعمال این تابع بخش های تیره تر پر رنگ تر میشوند و بخش های روشن تصویر کمرنگ تر می شوند. این کار باعث می شود بخش های مهم تصویر با کیفیت و وضوح بیشتری دیده شود. 