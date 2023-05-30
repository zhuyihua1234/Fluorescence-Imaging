% This program calculates the average intensity inside a 400um box of a RGB image
% Intensity Index of each of the R,G,B channels is displayed at the end
% Instruction: Move current folder to the folder containing your RGB image
% Change the image file name on line 7
% Author: Yihua Zhu

img = imread('dino13_green.tif');

[R,G,B] = imsplit(img);

%Draw ROI in imfreehand and get ROI info
fontSize = 16;
imshow(img, []);
axis on;
title('Original Fluorescence Image', 'FontSize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Ask user to draw Square.
message = sprintf('Drag the box to the Lesion ROI.\nDo not change the size of the box');
uiwait(msgbox(message));
h = imrect(gca,[10 10 82 82]);
position = wait(h);

% Create a binary image ("mask") from the ROI object.
binaryImage = h.createMask();

% Display Red Channel image
subplot(2, 3, 1);
imshow(R, []);
axis on;
drawnow;
title('Red Channel', 'FontSize', fontSize);

% Display Green Channel image
subplot(2, 3, 2);
imshow(G, []);
axis on;
drawnow;
title('Green Channel', 'FontSize', fontSize);

% Display Blue Channel image
subplot(2, 3, 3);
imshow(B, []);
axis on;
drawnow;
title('Blue Channel', 'FontSize', fontSize);

% Label the binary image to RED and compute the centroid and center of mass.
labeledImage = bwlabel(binaryImage);
measurements_R = regionprops(binaryImage, R, ...
    'Area', 'Centroid', 'WeightedCentroid', 'Perimeter');
area_trans = measurements_R.Area
centroid_trans = measurements_R.Centroid
centerOfMass_trans = measurements_R.WeightedCentroid
perimeter_trans = measurements_R.Perimeter

% Label the binary image to GREEN and compute the controid and center of mass.
measurements_G = regionprops(binaryImage, G, ...
    'Area', 'Centroid', 'WeightedCentroid', 'Perimeter');
area_ref = measurements_G.Area
centroid_ref = measurements_G.Centroid
centerOfMass_ref = measurements_G.WeightedCentroid
perimeter_ref = measurements_G.Perimeter

% Label the binary image to BLUE image and compute the controid and center of mass.
measurements_B = regionprops(binaryImage, B, ...
    'Area', 'Centroid', 'WeightedCentroid', 'Perimeter');
area_add = measurements_B.Area
centroid_add = measurements_B.Centroid
centerOfMass_add = measurements_B.WeightedCentroid
perimeter_add = measurements_B.Perimeter

% Calculate the area, in pixels, that they drew.
numberOfPixels1 = sum(binaryImage(:))
% Another way to calculate it that takes fractional pixels into account.
numberOfPixels2 = bwarea(binaryImage)

% Get coordinates of the boundary of the freehand drawn region.
structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
x = xy(:, 2); % Columns.
y = xy(:, 1); % Rows.
subplot(2, 3, 1); % Plot over original Transillumination image.
hold on; 
plot(x, y, 'LineWidth', 2);
drawnow; % Force it to draw immediately.
subplot(2, 3, 2); % Plot over original Reflectance image.
hold on; 
plot(x, y, 'LineWidth', 2);
drawnow; % Force it to draw immediately.
subplot(2, 3, 3); % Plot over original Reflectance image.
hold on; 
plot(x, y, 'LineWidth', 2);
drawnow; % Force it to draw immediately.


% Mask the images outside the mask, and display it.
% Will keep only the part of the image that's inside the mask, zero outside mask.
blackMaskedImage_R = R;
blackMaskedImage_R(~binaryImage) = 0;
subplot(2, 3, 4);
imshow(blackMaskedImage_R);
axis on;
title('Masked Red Image', 'FontSize', fontSize);

blackMaskedImage_G = G;
blackMaskedImage_G(~binaryImage) = 0;
subplot(2, 3, 5);
imshow(blackMaskedImage_G);
axis on;
title('Masked Green Image', 'FontSize', fontSize);

blackMaskedImage_B = B;
blackMaskedImage_B(~binaryImage) = 0;
subplot(2, 3, 6);
imshow(blackMaskedImage_B);
axis on;
title('Masked Blue Image', 'FontSize', fontSize);

% Calculate the means
meanGL_R = mean(blackMaskedImage_R(binaryImage));
sdGL_R = std(double(blackMaskedImage_R(binaryImage)));
meanGL_G = mean(blackMaskedImage_G(binaryImage));
sdGL_G = std(double(blackMaskedImage_G(binaryImage)));
meanGL_B = mean(blackMaskedImage_B(binaryImage));
sdGL_B = std(double(blackMaskedImage_B(binaryImage)));

% Report results.
message = sprintf('RED ROI mean = %.3f\nRED ROI Standard Deviation = %.3f\nNumber of pixels = %d\nGREEN ROI mean = %.3f\nGREEN ROI Standard Deviation = %.3f\nBLUE ROI mean = %.3f\nBLUE Mode Standard Deviation = %.3f', meanGL_R, sdGL_R, numberOfPixels1, meanGL_G, sdGL_G, meanGL_B, sdGL_B);
msgbox(message);
