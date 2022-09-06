filenames=dir; 
for i=3:size(filenames,1)
files{i-2}=filenames(i).name;
end 
for i=3:size(filenames,1)
   I=imread(files{i});
   try
    if imfinfo(files{i}).Orientation==8
        I=imrotate(I,90);
        imwrite(I,files{i});
        files{i};
    end 
    if imfinfo(files{i}).Orientation==6
        I=imrotate(I,-90);
        imwrite(I,files{i});
        files{i};
    end 
%     imshow(I);
   catch
   end
end