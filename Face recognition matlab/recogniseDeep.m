function [c] = recogniseDeep(I,trainedNetwork)
% Recognise the student in image I from the 2021 Spring Y3 ING class
% input : I (upright RGB image)
% output : c (integer student id)

% your code ...
I= registration(I);
% example
I=imresize(I,[224 224]); %%%%% update to your network input size
[YPred] = classify(trainedNetwork,I);
c=str2double(string(YPred));

end
