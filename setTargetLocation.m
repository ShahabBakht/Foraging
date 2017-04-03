function [x,y] = setTargetLocation(IMGname)

IMG = rgb2gray(imread(IMGname));
IMGresize = imresize(IMG,1);

figure; imagesc(IMGresize);colormap(gray);axis image;hold on
[x,y] = ginput(1);

[X1,X2] = meshgrid(1:size(IMGresize,2),1:size(IMGresize,1));
F = mvnpdf([X1(:) X2(:)],[x,y],[60,0;0,60]);
F = reshape(F,length(1:size(IMGresize,1)),length(1:size(IMGresize,2)));
contour(1:size(IMGresize,2),1:size(IMGresize,1),F);%,[.0001 .001 .01 .05:.1:.95 .99 .999 .9999]);
set(gca,'Ydir','reverse');

end