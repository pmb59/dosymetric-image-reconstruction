

function y=erasehot(a)
% ----------------
% Function to delete possible 'hot spots' created artificially 
% by the CCD camera of the 2-D thermoluminescence (TL) reader
% ----------------

b=a;
disp('Preprocessing image...');
[m,n]=size(a);   
for i=2:m-1
    for j=2:n-1
        neighb=mean([a(i-1,j) a(i,j-1) a(i+1,j) a(i,j+1) a(i-1,j-1) a(i+1,j+1) a(i-1,j+1) a(i+1,j-1)]);
        if a(i,j)>3*neighb %criteria for bad pixel values
            b(i,j)=neighb;
            disp(['hot pixel in: (' int2str(i) ',' int2str(j) ')']);
        end
    end
end

y=b;
           
        
    
