filenames=dir; 
for i=3:1247
files{i-2}=filenames(i).name;
end 

%%
close all;
clc;
for cmp=1:1245

face = imread(files{cmp});

try
    if imfinfo(files{cmp}).Orientation==8
        face=imrotate(face,90);
    end 
    if imfinfo(files{cmp}).Orientation==6
        face=imrotate(face,-90);
    end 
    catch
end

GI=rgb2gray(face);
threshold=graythresh(GI);
bw=~imbinarize(GI,threshold);

%%%%%%%%
bw2=imfill(bw,'holes');
bw3 = bwareaopen(bw2,1000);

[r, c] = find(bw3);
row1 = min(r);
row2 = max(r);
col1 = min(c);
col2 = max(c);

rect =[col1 row1 col2 row2];
face = imcrop(face,rect);

face = imgaussfilt(face);
[H,W,~] = size(face);

%figure;
%imshow(face);

ycbcr = rgb2ycbcr(face);

%figure;
%imshow(ycbcr);

cb = [80 140];
cr = [140 175];
result = zeros(H,W);


for i = 1:H
    for j = 1:W
        if (ycbcr(i,j,2) >= cb(1) && ycbcr(i,j,2) <= cb(2))
            if (ycbcr(i,j,3) >= cr(1) && ycbcr(i,j,3) <= cr(2))
                result(i,j) = 1;
            end
        end
    end
end

%figure;
%imshow(result);

%sr=strel('disk',6);
%result = imclose(result,sr);

%figure;
%imshow(result);

L = bwlabel(result);
B = regionprops(L,'area');
Se = [B.Area];
Sm = max(Se);

B1 = bwareaopen(result,Sm);

%figure;
%imshow(B1);

top = H; bot = H; left = W; right = W;

for i = 1:H
    if any(B1(i,:))
        top=i;
        break
    end
end
for i = top:H
    if B1(i,:) == 0
        bot=i;
        break
    end
end
for j = 1:W
    if any(B1(:,j))
        left=j;
        break
    end
end
for j = left:W
    if B1(:,j)==0
        right=j;
        break
    end
end

% figure;
% imshow(face);
% subplot(1,2,1), imshow(face)

hold on
h1=line([left right],[top top]);
h2=line([left right],[bot bot]);
h3=line([left left],[top bot]);
h4=line([right right],[top bot]);
h=[h1 h2 h3 h4];

ko=[left,top,right-left,bot];
FI = imcrop(face,ko);

imwrite(FI,files{cmp});


%subplot(1,2,2), imshow(FI)
%set(h,'Color',[1 0 0],'LineWidth',2);
end

%% 4 organiser photo dossier
filenames=dir
for i=3:size(filenames,1),
    folder=strsplit(filenames(i).name,'-');
    folder=folder{1};
    mkdir(string(folder));
    movefile(string(filenames(i).name),strcat(string(folder),'/'));
end