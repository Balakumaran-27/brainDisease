function [inpf1,sprop]=runevaluation(inp,clustter_image) 
inp = imresize(inp,[256,256]);
dinp = inp;

%%%%Band reduction using principal component analysis

if size(inp,3)>1
    
    Ri = reshape(inp,[],3);
    Ri = double(Ri);
    [V D] = eig(cov(Ri));
    [Md Id] = max(diag(D));
    Si = reshape(Ri*V(:,Id),[size(inp,1),size(inp,2)]);
    
    inp = ((Si - min(min(Si))).*255)./(max(max(Si))-min(min(Si)));
    

end
rinp = reshape(inp,[],1);
hinp = hist(rinp,0:255);
hinp = reshape(hinp,[],1);

ind = [0:255];
index = reshape(ind,[],1);
w_g1 = [];
var = [];

%%%%%back ground process 
for i =0:255
    
 w_g  =   sum(hinp(1:i)) / sum(hinp);

 con =  sum(hinp(1:i)) .* index(1:i);
 
 ent  =  sum(con);
 
 mean = ent / sum(hinp(1:i));
 
 if (isnan(mean) == 1)
     mean = 0;
 end

 var1 = (index(1:i) - mean).^2;
 var2 = sum(var1 .* index(1:i) );
 var3=var2/sum(hinp(1:i));
clustter_image=(clustter_image).*(clustter_image);
     if(isnan(var3)==1)
         var3=0;
     end
     
     w_g1 =[w_g1 w_g];
     var = [var var3];
end
    
%%%%%%%foreground process

w_g2 = [];
var123 = [];

for i =0:255
    
 w_g  =   sum(hinp(i+1:255)) / sum(hinp);

 con =  sum(hinp(i+1:255)) .* index(i+1:255);
 
 ent  =  sum(con);
 
 mean = ent / sum(hinp(i+1:255));
 
 if (isnan(mean) == 1)
     mean = 0;
 end

 var1 = (index(i+1:255) - mean).^2;
 var2 = sum ((var1).*index(i+1:255)) ;
 var3=var2/sum(hinp(i+1:255));

     if(isnan(var3)==1)

         var3=0;

     end
     w_g2 =[w_g2 w_g];
     var123 = [var123 var3];
end

for i = 1:256
    
    tarb(i) = (w_g1(i) * var(i)) + (w_g2(i) * var123(i));

end

[gmin th_ind] =min(tarb);

ot_th = th_ind - round(th_ind/3);

for i=1:1:size(inp,1) 
    for j=1:size(inp,2) 
        
        if inp(i,j) > ot_th
            
            bg_obj(i,j)=1; 
        else 
            
            bg_obj(i,j)=0; 
        end 
        
    end 
end 

tar_obj = imcomplement(bg_obj);

wcor = length(find(tar_obj==1));
bcor = length(find(tar_obj==0));

if bcor<wcor
   tar_obj = imcomplement(tar_obj); 
end

%%%%%%Template Matching and target tracking
se = strel('line',2,90);
tar_obj = imdilate(tar_obj,se);

ftar_obj = imfill(tar_obj,'holes');

tarout = bwareaopen(ftar_obj,50);

dtarout = imfill(tarout,'holes');
 
[bwout1 cnt] = bwlabel(dtarout,8);

sprop = regionprops(bwout1,'all');
   
for ki = 1:cnt
       
    tpara = sprop(ki).BoundingBox;
    sfeat(1) = sprop(ki).Area; sfeat(2) = sprop(ki).Orientation;
    sfeat(3) = sprop(ki).Eccentricity; sfeat(4)= sprop(ki).EquivDiameter;
    sfeat(5) = sprop(ki).Perimeter; sfeat(6)= tpara(3); sfeat(7)= tpara(4);
    
    inpf1(:,ki) = sfeat';
    
end


end