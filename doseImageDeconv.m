

function [img,y]=doseImageDeconv(Dia,dist,imgloc,alg,optSelected,nluc);
% ----------------
% MatLab algorithm developed for resolution enhancement and limiting 
% factors suppression of the 2D thermoluminiscent (TLD) reader at IFJ PAN
% ----------------
% PARAMETERS
%Dia=diameter of the foil grain in um.  
%dist=distance between the lens of the camera and the detector in mm.
%imgloc=input image file produced by the TL reader
%alg=selected deconvlution algorithm ('lucy','blind','reg','wnr')
%optSelected=operation mode selected (1 for standard 5cmx5cm detector size; 2 sets up 1cmx1cm operation)
%nluc = number of iterations
% ----------------

img=load(imgloc);

% Erase hot pixels and assign neighborhood Mean
input=erasehot(img); 


% Get the CCD Point Spread Function (PSF) according to our model
psf=readerpsf(Dia,dist,optSelected);  


% Execute deconvolution 

np=0.2;  %additive noise power
nsr=0.1; %noise-to-signal power ratio
input=imresize(input,3);
psf=imresize(psf,0.4); %size(psf)
% If psf is big, resolution in the hole makes better BUT change the
% distribution of intensity values in the whole image
% If psf is small,Resolution improvement is poor

input=edgetaper(input,psf);  
   %The EDGETAPER function reduces the ringing effect in image deblurring
    %methods that use the discrete Fourier transform, such as DECONWNR,
    %DECONVREG, and DECONVLUCY.

[y,restoredPSF,im,m1,m2,s1,s2]=deconv2d(input,psf,nluc,np,nsr,alg);



