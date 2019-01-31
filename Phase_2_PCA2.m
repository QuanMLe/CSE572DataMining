clear all
close all
clc

% This call gets the path of the folder that the script that is running
scriptPath = pwd;
% This will work if the Phase I data is in the same directory as the script
dataPathEat = strcat(scriptPath,'\Phase_3_Data\','Eat');
dataPathNotEat = strcat(scriptPath,'\Phase_3_Data\','Not_Eat');
%Path to Myo Data
myoPath = strcat(scriptPath,'\MyoData');
% Path where the PCA files will be written out
outputPath = strcat(scriptPath,'\Phase_3_Data\PCA');
mkdir(outputPath);

forkEatList = ls(dataPathEat);
forkNotEatList = ls(dataPathNotEat);
% Removes the '.' and '..' directories from list
forkEatList = forkEatList(3:end,:);
forkNotEatList = forkNotEatList(3:end,:);

%Converts inputList into a cell array of character vectors
forkEatList = cellstr(forkEatList);
forkNotEatList = cellstr(forkNotEatList);

%Uses a loop to concat all the data
for i = 1 : size(forkEatList, 1)
    load(strcat(dataPathEat,'\',forkEatList{i}));
    load(strcat(dataPathNotEat,'\',forkNotEatList{i}));
end

% minOriMatrix = [forkMinEatData(:,1:4) forkMaxEatData(:,1:4) forkMeanEatData(:,1:4) forkStdevEatData(:,1:4) forkEatFeatureMatrix(:,1:4)];
% [coeff,scores,latent] = pca(minOriMatrix);
% minFeatureSpace = minOriMatrix*coeff;
% maxMatrix = [];
% meanMatrix = [];
% StdevMatrix = [];
% SVDMatrix = [];

% Combines all the features in this order Min, Max, Mean, Stdev, SVD in
% I do this twice for eat and not eat

Combined_Eat_Matrix = [forkMinEatData  forkMaxEatData  forkMeanEatData  forkStdevEatData  forkEatFeatureMatrix];
[coeffEat,scoreEat] = pca(Combined_Eat_Matrix.');
transMatrix = Combined_Eat_Matrix.';
newEatFeatureSpace = transMatrix*coeffEat;
newEatFeatureSpace = newEatFeatureSpace.';

Combined_NotEat_Matrix = [forkMinNotEatData forkMaxNotEatData forkMeanNotEatData forkStdevNotEatData forkNotEatFeatureMatrix];
[coeffNotEat,scoreNotEat] = pca(Combined_NotEat_Matrix.');
transMatrix = Combined_NotEat_Matrix.';
newNotEatFeatureSpace = transMatrix*coeffNotEat;
newNotEatFeatureSpace = newNotEatFeatureSpace.';

% This is for keeping track of the the user number when we write out files
userNums = ls(myoPath);
userNums = userNums(3:end,:);

users = [];

for i = 1 : size(userNums, 1)
    % Adds the users to a string array for later use
    users = [users;convertCharsToStrings(userNums(i,:))];
end

biplot(coeffEat(:,1:2),'Scores',scoreEat(:,1:2),'Varlabels', users);
figure();
biplot(coeffNotEat(:,1:2),'Scores',scoreNotEat(:,1:2),'Varlabels', users);
