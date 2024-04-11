function [AA1, AA2, AA3, AA4, AA5, AA6] = Kmeanspp(Input)

[r c] = size(Input);
Length  = r*c; 
wd1=r;
wd2=c;
% Choose one center uniformly from among the data points
Dataset = reshape(Input,[Length,1]);
    
Clusters=6; %k CLUSTERS
Cluster1=zeros(Length,1);
Cluster2=zeros(Length,1);
Cluster3=zeros(Length,1);
Cluster4=zeros(Length,1);
Cluster5=zeros(Length,1);
Cluster6=zeros(Length,1);

miniv = min(min(Input));      
maxiv = max(max(Input));
range = maxiv - miniv;
stepv = range/Clusters;
incrval = stepv;
for i = 1:Clusters
    K(i).centroid = incrval;
    incrval = incrval + stepv;
end

%BEGIN LOOP

update1=0;
update2=0;
update3=0;
update4=0;
update5=0;
update6=0;


mean1=2;
mean2=2;
mean3=2;
mean4=2;
mean5=2;
mean6=2;

while  ((mean1 ~= update1) && (mean2 ~= update2) && (mean3 ~= update3) && (mean4 ~= update4) && (mean5 ~= update5) && (mean6 ~= update6) )

mean1=K(1).centroid;
mean2=K(2).centroid;
mean3=K(3).centroid;
mean4=K(4).centroid;
mean5=K(5).centroid;
mean6=K(6).centroid;

%% For each data point x, compute D(x), the distance between x and the nearest center that has already been chosen

for i=1:Length
    for j = 1:Clusters
        temp = Dataset(i);
        difference(j) = abs(temp-K(j).centroid);

    end
    [y,ind]=min(difference);
    
	if ind==1
        Cluster1(i)   =temp;
	end
    if ind==2
        Cluster2(i)   =temp;
    end
    if ind==3
        Cluster3(i)   =temp;
    end
    if ind==4
        Cluster4(i)   =temp;
    end
     if ind==5
        Cluster5(i)   =temp;
     end
     if ind==6
        Cluster6(i)   =temp;
     end
end

%UPDATE CENTROIDS
cout1=0;
cout2=0;
cout3=0;
cout4=0;
cout5=0;
cout6=0;

for i=1:Length
    Load1=Cluster1(i);
    Load2=Cluster2(i);
    Load3=Cluster3(i);
    Load4=Cluster4(i);
    Load5=Cluster5(i);
    Load6=Cluster6(i);
    
    if Load1 ~= 0
        cout1=cout1+1;
    end
    
    if Load2 ~= 0
        cout2=cout2+1;
    end
    
    if Load3 ~= 0
        cout3=cout3+1;
    end
    
    if Load4 ~= 0
        cout4=cout4+1;
    end
    
     if Load5 ~= 0
        cout5=cout5+1;
     end
    
     if Load6 ~= 0
        cout6=cout6+1;
    end
   
end

Mean_Cluster(1)=sum(Cluster1)/cout1;
Mean_Cluster(2)=sum(Cluster2)/cout2;
Mean_Cluster(3)=sum(Cluster3)/cout3;
Mean_Cluster(4)=sum(Cluster4)/cout4;
Mean_Cluster(5)=sum(Cluster5)/cout5;
Mean_Cluster(6)=sum(Cluster6)/cout6;


for i = 1:Clusters
    K(i).centroid = Mean_Cluster(i);

end

update1=K(1).centroid;
update2=K(2).centroid;
update3=K(3).centroid;
update4=K(4).centroid;
update5=K(5).centroid;
update6=K(6).centroid;


end

AA1=reshape(Cluster1,[wd1 wd2]);
AA2=reshape(Cluster2,[wd1 wd2]);
AA3=reshape(Cluster3,[wd1 wd2]);
AA4=reshape(Cluster4,[wd1 wd2]);
AA5=reshape(Cluster5,[wd1 wd2]);
AA6=reshape(Cluster6,[wd1 wd2]);
return;