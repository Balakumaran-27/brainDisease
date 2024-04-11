function Combined_featuures=train_seg_features(i)

%% PLANE SEPARATION %%
R=i(:,:,1);
G=i(:,:,2);
B=i(:,:,3);
%% XYZ COLOUR SPACE CONVERSION %%
x = 0.412453*R + 0.357580*G + 0.180423*B;
y = 0.212671*R + 0.715160*G + 0.072169*B;
z = 0.019334*R + 0.119193*G + 0.950227*B;
XYZ(:,:,1)=x;
XYZ(:,:,2)=y;
XYZ(:,:,3)=z;
input_image=i;

%% Preprocessing
Input=imresize(XYZ,[512 512]);
test = Input;
[r c p] = size(Input);
if p == 3
     Input = rgb2gray(Input);
end


%% To find the clusters centroid points
[AA1, AA2, AA3, AA4, AA5, AA6] = Kmeanspp(Input);

%% Assign each object to the group that has the closest centroid %%
se1 = [0 0 0 0 0 0 0;0 0 0 0 0 0 0;0 0 0 0 0 0 0 ;1 1 1 1 1 1 1;0 0 0 0 0 0 0;0 0 0 0 0 0 0;0 0 0 0 0 0 0 ];

AA2 = imclose(AA2,se1);
AA2 = imopen(AA2,se1);

AA3 = imclose(AA3,se1);
AA3 = imopen(AA3,se1);

AA4 = imclose(AA4,se1);
AA4 = imopen(AA4,se1);

AA5 = imclose(AA5,se1);
AA5 = imopen(AA5,se1);

AA6 = imclose(AA6,se1);
AA6 = imopen(AA6,se1);



%% Recalculate the positions of the centroids
count1=0;
for i=1:r;
    for j=1:c;
        if AA2(i,j)>0;
            count1=AA2(i,j);
            count1=count1+1;
        else
        end
    end
end

count2=0;
for i=1:r;
    for j=1:c;
        if AA3(i,j)>0;
            count2=AA3(i,j);
            count2=count2+1;
        else
        end
    end
end

count3=0;
for i=1:r;
    for j=1:c;
        if AA4(i,j)>0;
            count3=AA4(i,j);
            count3=count3+1;
        else
        end
    end
end

Combined_featuures=double([0 1 2 3 4 5 6 7 8 9]);

%% five representative texture distributions have been learned and each pixel in the image is replaced by one of five colors,
cimg(:,:,1) = zeros(r,c);
cimg(:,:,2) = zeros(r,c);
cimg(:,:,3) = zeros(r,c);
for i = 1:r
     for j = 1:c
        if AA5(i,j) > 0
           cimg(i,j,2) = test(i,j,2);
           cimg(i,j,1) = test(i,j,1);

        end
    end
end
for i = 1:r
     for j = 1:c
        if AA6(i,j) > 0
           cimg(i,j,1) = test(i,j,1);
           cimg(i,j,3) = test(i,j,3);

        end
    end
end


[inpf1,sprop]=runevaluation(input_image,cimg);
load seedpoints
 mcof = zeros(size(temfr,2),size(inpf1,2));
Input=imresize(XYZ,[256 256]);
for tm=1:size(temfr,2)
    for im=1:size(inpf1,2)
   
    mcof(tm,im) = corr2(temfr(:,tm),inpf1(:,im));
         
    end
end
GLCM1=2;
[rmcof ind] = sort(mcof,2,'descend');
[mc cind] = max(rmcof(:,1));

   tkpara1 = sprop(ind(cind,1)).BoundingBox;
 
   if(tkpara1(1,1)>100 || tkpara1(1,4)>100)
       
    
   else
   figure('Name','Segmentation'); imshow(Input);
   hold on;
   rectangle('Position',tkpara1,'EdgeColor','r');
   hold off
fil=imcrop(Input,tkpara1);
figure,
imshow(fil);
spel=1;
% % Extarct the GLCM features and genomic  biomarkers from Clusttered Region

    
GLCM2 = graycomatrix(rgb2gray(fil),'Offset',[2 0;0 2]);
stats = GLCM_Features1(GLCM2,0);
% Features computed 
% Autocorrelation: [2]                      (out.autoc)
% Contrast: matlab/[1,2]                    (out.contr)
% Correlation: matlab                       (out.corrm)
% Correlation: [1,2]                        (out.corrp)
% Cluster Prominence: [2]                   (out.cprom)
% Cluster Shade: [2]                        (out.cshad)
% Dissimilarity: [2]                        (out.dissi)
% Energy: matlab / [1,2]                    (out.energ)
% Entropy: [2]                              (out.entro)
% Homogeneity: matlab                       (out.homom)
% Homogeneity: [2]                          (out.homop)
% Maximum probability: [2]                  (out.maxpr)
% Sum of sqaures: Variance [1]              (out.sosvh)
% Sum average [1]                           (out.savgh)
% Sum variance [1]                          (out.svarh)
% Sum entropy [1]                           (out.senth)
% Difference variance [1]                   (out.dvarh)
% Difference entropy [1]                    (out.denth)
% Gray-Level  Non  uniformity         [1]   (out.GLN)
% Informaiton measure of correlation2 [1]   (out.inf2h)
% Inverse difference (INV) is homom [3]     (out.homom)
% Short  Run  Low  Gray-Level  Emphasis     (out.SRLGE) 
% Long  Run  Low  Gray-Level  Emphasis [3]  (out.LRLGE)

% 
   end