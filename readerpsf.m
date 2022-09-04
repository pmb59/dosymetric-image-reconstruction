

function psf=readerpsf(Dia,dist,optSelected);
% ----------------
%This function creates a model for the CCD Point Spread Function (PSF)
% ----------------
%Dia=diameter of the grain in um. 
%dist=distance between the lens of the camera and the detector in mm. (It will define pixel size in Step 3)
%optSelected=operation mode selected (1 for standard 5cmx5cm detector size; 2 sets up 1cmx1cm operation)

disp('Calculating PSF...');
Depth=150; %mean depth of the grain in detector 150um
n1=1.5;    %teflon refractive index
n2=1;      %air refractive index
IR=asin(n2/n1); %the angle of total reflection
Od=0.0005; %teflon optical absorbtion coefficient 
Ref=0.5;   %reflection coeff from the surface of the heater

width=1500; 	    
x = -width:10:width; 
y = -width:10:width;
[X,Y]=meshgrid(x,y);

i=-4; 
b=zeros(abs(i)*2+1,length(x)-1,length(y)-1);


%Step 1&2
while(i<5)
    j=-width;
    k=-width;
    D=Depth+i*12; %depth of each given layer of the grain

   shifter=width/10+1; %the value that shifts in the matrix depending on the matrix size   
    while(j<width) 
        while(k<width)
            Direct_path=(D^2+j^2+k^2).^0.5; %straight path from the grain to the surface
            Indirect_path=(2*2*Depth-D)./cos(atan((j^2+k^2).^0.5./(2*2*Depth-D))); %path of the ray reflected from the reader
            a(((j/10)+shifter),((k/10)+shifter))=(Direct_path.^-2).*(exp(-Od*Direct_path))+Ref*(Indirect_path.^-2).*(exp(-Od*Indirect_path));; %convolution kernel for each layer of the grain   
            k=k+10;
        end
        k=-width;
        j=j+10;
    end  
   
    a2((i+5),:,:)=a;

    %CIRCLE b
        for ib=-149:150
            for jb=-149:150
                if i==0
                    if ib^2+jb^2<=25
                        b((i+5),ib+150,jb+150)=1;
                    end
                else
                    if ib^2+jb^2<=25/abs(i)
                        b((i+5),ib+150,jb+150)=1;
                    end
                    
                end
            end
        end

    f1=fftshift(fft2(squeeze(a2((i+5),:,:))));
    f2=fftshift(fft2(squeeze(b((i+5),:,:))));
    m=f1.*f2;
    co=ifftshift(ifft2(m));  
    c(i+5,:,:)=co;

    i=i+1;
end



c(10,:,:)=sum(c(1:9,:,:)); %sum of all convolutioned layers (Total sum of convolution of each layer of the grain)
c(10,:,:)=squeeze(c(10,:,:))./sum(sum(squeeze(c(10,:,:)))); %normalization

g=squeeze(c(10,:,:)); %Grain PSF matrix in tens of um's

%(3) CCD Pixel Convolution. 
%Parameter 'dist' must modify pixel width
    width2=50; %tens of um's
    d=zeros(1,2*width2,2*width2);  %matrix for pixel
if optSelected==1
    Base_distance=98;  %distance in mm we have measured. The input dist parameter will also be in mm
    Base_field=75;     %the diameter of the heater we have measured (as an example of the object of the know size)
    Base_pixel_number=416; %the diameter of the heater in pixels under conditions of Base_distance and base_field
else
%MULTICOLIMATOR
     Base_distance=98; %distance in mm we have measured. The input dist parameter will also be in mm
     Base_field=75/5; %the diameter of the heater we have measured (as an example of the object of the know size)
     Base_pixel_number=83; %the diameter of the heater in pixels under conditions of Base_distance and base_field
%PROTON BEAM
%    Base_distance=250; %distance in mm we have measured. The input dist parameter will also be in mm
%    Base_field=75; %the diameter of the heater we have measured (as an example of the object of the know size)
%    Base_pixel_number=1024; %the diameter of the heater in pixels under conditions of Base_distance and base_field

end

p=fix((dist/Base_distance)*(Base_field/Base_pixel_number)*100); %the pixel size in tens of um's in given distance
d(2,fix(width2-p/2):fix(width2+p/2),fix(width2-p/2):fix(width2+p/2))=1; %pixel of the camera in tens of um's

w=conv2(abs(g),squeeze(d(2,:,:))); %convolution kernel in tens of um's
w=w./(max(max(w))); %normalization
%CCD Point Spread Function
psf=abs(w);


