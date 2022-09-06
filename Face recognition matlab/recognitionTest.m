% only upright test images in directory
testFolder='C:\Users\Owner\Documents\Life\ECE\AI\final project\newtest\'; %%%%% your test directory
files=dir(testFolder);

clear filenames
for i=3:size(files,1),
    filenames{i-2,1}=files(i).name;
end

load deepnet_resnet18_allfilesV4.mat   %%%%% load your network here

wrongImages={}; w=1;
correct=0;
tic;
for i=1:size(filenames,1)
    I=imread(strcat(testFolder,(filenames{i})));
    c=recogniseDeep(I,trainedNetwork_2);  %%%%% use your network variable here
    
    correctId=strsplit(filenames{i},'-');
    correctId=str2double(correctId{1});
    
    if (c==correctId), 
        correct=correct+1; 
    else
        wrongImages{w,1}=filenames{i}; 
        wrongImages{w,2}=c; 
        w=w+1;
    end
    
    accuracy=100*(correct/i);
    sprintf('Recognition rate = %f%% after %u images',accuracy,i)
    
end

sprintf('Average recognition time = %f seconds',toc/i)
wrongImages=wrongImages';


    