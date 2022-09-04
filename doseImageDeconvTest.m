
clear all;
close all;

%Example 1
[imagereader,deconvolutedNormalized] = doseImageDeconv(90,100,'D-9.TXT' ,'lucy',2,15);

figure;
subplot(1,2,1);
imagesc(imagereader); title('input image'); 
subplot(1,2,2);
imagesc(deconvolutedNormalized); title('output image'); 

%Example 2
%[imagereader,deconvolutedNormalized] = doseImageDeconv(90,100,'DP-16-1.TXT' ,'reg',1,10);

%figure;
%subplot(1,2,1);
%imagesc(imagereader); title('input image'); 
%subplot(1,2,2);
%imagesc(deconvolutedNormalized); title('output image'); 
%colormap(hot);

