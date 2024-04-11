clc;
clear all;
close all;
warning off;

answer = questdlg('Select below box?', ...
	'Selection Menu', ...
	'male','female','female');
% Handle response
switch answer
    case 'male'
        disp([answer ' coming right up.'])
        dessert = 1;
    case 'female'
        disp([answer ' coming right up.'])
        dessert = 2;
   end

answer1 = questdlg('Select ur age', 'Selection Menu','10 to 20','20 to 40','40 to 60','default');
% Handle response
switch answer1
    case '5 to 10'
        disp([answer1 ' coming right up.'])
        dessert1 = 0;
    case '10 to 20'
        disp([answer1 ' coming right up.'])
        dessert1 = 2;
    case '20 to 35'
        disp([answer1 ' coming right up.'])
        dessert1 = 0;
    case '35 to 45'
        disp([answer1 ' coming right up.'])
        dessert1 = 1;
    case '45 to 55'
        disp([answer1 ' coming right up.'])
        dessert1 = 2;
    case '55 and Above'
        disp([answer1 ' coming right up.'])
        dessert1 = 0;
end


answer1 = questdlg('Select ur Sugar Level', 'Selection Menu','70 to 90','90 to 100','100 above','default');
% Handle response
switch answer1
    case '70 to 90'
        disp([answer1 ' coming right up.'])
        dessert1 = 0;
    case '90 to 100'
        disp([answer1 ' coming right up.'])
        dessert1 = 2;
    case '20 to 35'
        disp([answer1 ' coming right up.'])
        dessert1 = 0;
    case '100 above'
        disp([answer1 ' coming right up.'])
        dessert1 = 1;
    case '45 to 55'
        disp([answer1 ' coming right up.'])
        dessert1 = 2;
    case '55 and Above'
        disp([answer1 ' coming right up.'])
        dessert1 = 0;
end


answer1 = questdlg('Select ur Hemoglobin level', 'Selection Menu','10 to 12','14 to 18','below 10','default');
% Handle response
switch answer1
    case '10 to 12'
        disp([answer1 ' coming right up.'])
        ahr = 98;
    case '14 to 18'
        disp([answer1 ' coming right up.'])
         ahr = 97;
    case 'below 10'
        disp([answer1 ' coming right up.'])
          ahr = 97;
    case '100 above'
        disp([answer1 ' coming right up.'])
        ahr = 98;
    case '45 to 55'
        disp([answer1 ' coming right up.'])
         ahr = 98;
    case '55 and Above'
        disp([answer1 ' coming right up.'])
         ahr = 98;
end

% [fname,pname] = uigetfile('*.png;*.jpg;*.pgm;*.bmp;*.gif;*.tif;*.dcm;');
% 
% file = fullfile(pname,fname);

[filename,pathname] = uigetfile({'*.*';'*.bmp';'*.tif';'*.gif';'*.png'},'Pick a image');
input1 = imread([pathname,filename]);


ib=input1;
figure;
imshow(ib);
title('Input Image');
i=input1;
XYZ=i;

%% Preprocessing
Input1=imresize(XYZ,[512 512]);
test = Input1;
[r c p] = size(Input1);
if p == 3
     Input1 = rgb2gray(Input1);
end


%% Image 
Input1 = wiener2(Input1,[3 3]);
% figure,
% imshow(Input1,[]);
% title('Wiener Filter');
Inputl = histeq(Input1);
figure,
imshow(Inputl,[]);
title('Pulse Sequence systhesizeed ');

%% To find the clusters centroid points
[AA1, AA2, AA3, AA4, AA5, AA6] = Kmeanspp(Input1);

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
% figure
% subplot(3,2,1);imshow(AA2,[]);title('2nd Cluster');
% subplot(3,2,2);imshow(AA3,[]);title('3rd Cluster');
% subplot(3,2,3);imshow(AA4,[]);title('4th Cluster');
% subplot(3,2,4);imshow(AA5,[]);title('4th Cluster');
% subplot(3,2,5);imshow(AA6,[]);title('5th Cluster');
impixelinfo;


%% Recalculate using wavelet the positions of the centroids
%% five representative texture distributions have been learned and each pixel in the image is replaced by one of five colors,

waveLet;
%%%%%%
figure,
imshow(uint8(cimg));
impixelinfo;
[inpf1,sprop]=runevaluation(XYZ,cimg);
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
   tkpara1 = sprop(ind(cind,1)).BoundingBox
 
   if((tkpara1(1,1)>100 || tkpara1(1,4)>100 ) &&  (tkpara1(1,1)~=47.5))
       Spe1=10;
     Result=sprintf('\nSegmentation: No Region Detected \n \n Result : No Tumor Found\n \n Note:\n Tumor : Fast Growing \n No Tumor : No Growing');
     h = msgbox(Result) ;
      
   else
   figure('Name','Tumor Recognition'); imshow(Input);
   hold on;
   rectangle('Position',tkpara1,'EdgeColor','r');
   hold off
     
fil=imcrop(Input,tkpara1);
figure,
imshow(fil);
Spe1=1;
% % Extarct the GLCM features and genomic  biomarkers from Clusttered Region
 
GLCM2 = graycomatrix(rgb2gray(fil),'Offset',[2 0;0 2]);
stats = GLCM_Features1(GLCM2,0)
Spel=stats;
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
load SVM_tumor
   Spe1 = svmclassify(svmStruct,Spe1,'showplot',true);
   end
   
 if Spe1==1
    
     Result=sprintf('\n Result : Tumor Found  \n \n Note:\n Tumor : Fast Growing \n No Tumor : No Growing');
Message =sprintf(' Report:\n\n Autocorrelation:%d \n Energy:%d \n Sum entropy:%d \n Contrast:%d \n  \n %s',stats.autoc(1,1),stats.energ(1,1),stats.entro(1,1),stats.contr(1,1),Result);

h = msgbox(Message) ;


 end
if (dessert1 == 0)
    msgbox('Body condition Normal');
    disp('Body condition Normal')
elseif (ahr >= 98) && (dessert1 == 1)
           msgbox('High Risk!');
    disp(' Body condition High Risk')
elseif (ahr >= 98) && (dessert1 == 2)
    msgbox('Very High Risk!!!!');
    disp('Body condition Very High Risk')
 elseif (ahr >= 97) && (dessert1 == 1)
     msgbox('LoW Risk!');
    disp('Body condition LoW Risk')
elseif (ahr >= 97) && (dessert1 == 2)
    msgbox('Body condition High Risk!!');
    disp('Body conditio High Risk')

  else
    msgbox('Normal');
    disp('Normal')
       end
    