function haar_wt(image_name,delta)
% Check number of inputs.
if nargin > 2
    error('harr_wt:TooManyInputs', ...
        'requires at most 1 optional inputs');
end

%Set the default value of 'delta' to 0.01
if (nargin==1)
    delta=0.01;
end

if (delta>1 || delta<0)
    error('harr_wt: Delta must be a value between 0 and 1');
end


%H1, H2, H3 are the transformation matrices for Haar wavelet Transform
H1=[0.5 0 0 0 0.5 0 0 0;0.5 0 0 0 -0.5 0 0 0;0 0.5 0 0 0 0.5 0 0 ;0 0.5 0 0 0 -0.5 0 0 ;0 0 0.5 0 0 0 0.5 0;0 0 0.5 0 0 0 -0.5 0;0 0 0 0.5 0 0 0 0.5;0 0 0 0.5 0 0 0 -0.5;];
H2=[0.5 0 0.5 0 0 0 0 0;0.5 0 -0.5 0 0 0 0 0;0 0.5 0 0.5 0 0 0 0;0 0.5 0 -0.5 0 0 0 0;0 0 0 0 1 0 0 0;0 0 0 0 0 1 0 0;0 0 0 0 0 0 1 0;0 0 0 0 0 0 0 1;];
H3=[0.5 0.5 0 0 0 0 0 0;0.5 -0.5 0 0 0 0 0 0;0 0 1 0 0 0 0 0;0 0 0 1 0 0 0 0;0 0 0 0 1 0 0 0;0 0 0 0 0 1 0 0;0 0 0 0 0 0 1 0;0 0 0 0 0 0 0 1;];

%Normalize each column of H1,H2,H3 to a length 1(This results in orthonormal columns of each matrix)
H1=normc(H1);
H2=normc(H2);
H3=normc(H3);

H=H1*H2*H3; %Resultant transformation matrix
x=double(imread(image_name));
len=length(size(x));

if len~=2
    error('harr_wt: Input image must be a grey image, use "haar_wt_rgb" function to compress RGB Images');
end

y=zeros(size(x));
[r,c]=size(x);
%Above 8x8 transformation matrix(H) is multiplied by each 8x8 block in the image

for i=0:8:r-8
    for j=0:8:c-8
        p=i+1;
        q=j+1;
        y(p:p+7,q:q+7)=(H')*x(p:p+7,q:q+7)*H;
    end
end


figure;
imshow(x/255);


%Larger the value 'delta', compression ratio will be larger
%delta=0.01;

n1=nnz(y);                          % Number of non-zero elements in 'y'

z=y;
m=max(max(y));
y=y/m;
y(abs(y)<delta)=0;                  % Values within +delta and -delta in 'y' are replaced by zeros(This is the command that result in compression)
y=y*m;
n2=nnz(y);                          % Number of non-zero elements in updated 'y'

%Inverse DWT of the image

for i=0:8:r-8
    for j=0:8:c-8
        p=i+1;
        q=j+1;
        z(p:p+7,q:q+7)=H*y(p:p+7,q:q+7)*H';
    end
end

figure;
imshow(z/255);                          

