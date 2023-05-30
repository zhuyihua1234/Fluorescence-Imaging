RGB_img = imread('dino13_green.tif');

[R,G,B] = imsplit(RGB_img);

figure
subplot(1,3,1)
imshow(R)
title('Red Channel')

subplot(1,3,2)
imshow(G)
title('Green Channel')

subplot(1,3,3)
imshow(B)
title('Blue Channel')