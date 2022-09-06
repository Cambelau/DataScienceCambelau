function [crop] = registration(face)
try
GI=rgb2gray(face);
threshold=graythresh(GI);
bw=~imbinarize(GI,threshold);

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



ycbcr = rgb2ycbcr(face);

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


L = bwlabel(result);
B = regionprops(L,'area');
Se = [B.Area];
Sm = max(Se);

B1 = bwareaopen(result,Sm);

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

ko=[left,top,right-left,bot];
crop = imcrop(face,ko);
catch 
end
end
