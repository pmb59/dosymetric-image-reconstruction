
function [y,restoredPSF,i,m1,m2,s1,s2]=deconv2d(i,psf,numit,np,nsr,alg)
% ----------------
% Image restoration by different deconvolution algorithms 
% ----------------

switch alg
    case 'lucy',
        disp('Lucy-Richardson method 2D Deconvolution...');
        y=deconvlucy(i,psf,numit);
        restoredPSF=1;
    case 'blind'
        disp('Blind method 2D Deconvolution...');
        [y,restoredPSF]=deconvblind(i,psf,numit);
    case 'reg'
        disp('Regularized filter method 2D Deconvolution...');
        y=deconvreg(i,psf,np);
        restoredPSF=1;
    case 'wnr'
        disp('Wiener Filter method 2D Deconvolution...');
        y=deconvwnr(i,psf,nsr);
        restoredPSF=1;

    otherwise
end

y=abs(y);  %deconvolution can produce negative values

%Input and Output Images Normalization
i=1e8*i/sum(sum(i));
y=1e8*y/sum(sum(y));

m1=mean(mean(i));
m2=mean(mean(y));
s1=std(std(i));
s2=std(std(y));

disp(['...Mean value of Normalized input image: ' num2str(m1)]);
disp(['...Std value of Normalized input image: ' num2str(s1)]);
disp(['...Mean value of Normalized deconvoluted image: ' num2str(m2)]);
disp(['...Std value of Normalized deconvoluted image: ' num2str(s2)]);

y=medfilt2(y,[4 4]);


y=imresize(y,0.3338);  %to 480x640
size(y);
i=imresize(i,1/3);  %to 480x640
size(i);



