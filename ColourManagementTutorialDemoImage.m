clear, clc

image = uint8(zeros(256*2,256*2,3));

image(1:256,1:256,1) = repmat(0:255,256,1);   %top left, first channel
image(1:256,257:256*2,2) = repmat(0:255,256,1); %top middle, second channel
image(257:256*2,1:256,3) = repmat(0:255,256,1); %top right, second channel
image(257:256*2,257:256*2,1) = repmat(0:255,256,1); 
image(257:256*2,257:256*2,2) = repmat(0:255,256,1); 
image(257:256*2,257:256*2,3) = repmat(0:255,256,1); 

imshow(image)

imwrite(image,'demo.tif')