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

Combined_Eat_Matrix = [forkMinEatData  forkMaxEatData  forkMeanEatData  forkStdevEatData  forkEatFFT];
[coeffEat,scoreEat,latentEat] = pca(Combined_Eat_Matrix,'Economy',false);
newEatFeatureSpace = Combined_Eat_Matrix*coeffEat;

top_5_coeff_eat = coeffEat(:,1:5);
save(fullfile(outputPath,'top_5_coeff_eat.mat'),'top_5_coeff_eat');
save(fullfile(outputPath,'latentEat.mat'),'latentEat');
save(fullfile(outputPath,'coeffEat.mat'),'coeffEat');

Combined_NotEat_Matrix = [forkMinNotEatData forkMaxNotEatData forkMeanNotEatData forkStdevNotEatData forkNotEatFFT];
[coeffNotEat,scoreNotEat,latentNotEat] = pca(Combined_NotEat_Matrix,'Economy',false);
newNotEatFeatureSpace = Combined_NotEat_Matrix*coeffNotEat;

top_5_coeff_not_eat = coeffNotEat(:,1:5);
save(fullfile(outputPath,'top_5_coeff_not_eat.mat'),'top_5_coeff_not_eat');
save(fullfile(outputPath,'latentNotEat.mat'),'latentNotEat');
save(fullfile(outputPath,'coeffNotEat.mat'),'coeffNotEat');

% This is for keeping track of the the user number when we write out files
userNums = ls(myoPath);
userNums = userNums(3:end,:);

columnTitles1 = ["ori-x-min","ori-y-min","ori-z-min","ori-w-min","accel-x-min","accel-y-min","accel-z-min","gyro-x-min","gyro-y-min","gyro-z-min","emg-1-min","emg-2-min","emg-3-min","emg-4-min","emg-5-min","emg-6-min","emg-7-min","emg-8-min"
];
columnTitles2 = ["ori-x-max","ori-y-max","ori-z-max","ori-w-max","accel-x-max","accel-y-max","accel-z-max","gyro-x-max","gyro-y-max","gyro-z-max","emg-1-max","emg-2-max","emg-3-max","emg-4-max","emg-5-max","emg-6-max","emg-7-max","emg-8-max"];
columnTitles3 = ["ori-x-mean","ori-y-mean","ori-z-mean","ori-w-mean","accel-x-mean","accel-y-mean","accel-z-mean","gyro-x-mean","gyro-y-mean","gyro-z-mean","emg-1-mean","emg-2-mean","emg-3-mean","emg-4-mean","emg-5-mean","emg-6-mean","emg-7-mean","emg-8-mean"];
columnTitles4 = ["ori-x-stdev","ori-y-stdev","ori-z-stdev","ori-w-stdev","accel-x-stdev","accel-y-stdev","accel-z-stdev","gyro-x-stdev","gyro-y-stdev","gyro-z-stdev","emg-1-stdev","emg-2-stdev","emg-3-stdev","emg-4-stdev","emg-5-stdev","emg-6-stdev","emg-7-stdev","emg-8-stdev"];
columnTitles5 = ["ori-x-fft","ori-y-fft","ori-z-fft","ori-w-fft","accel-x-fft","accel-y-fft","accel-z-fft","gyro-x-fft","gyro-y-fft","gyro-z-fft","emg-1-fft","emg-2-fft","emg-3-fft","emg-4-fft","emg-5-fft","emg-6-fft","emg-7-fft","emg-8-fft"];
columnTitles = [columnTitles1 columnTitles2 columnTitles3 columnTitles4 columnTitles5];

figure1 = biplot(coeffEat(:,1:3),'Scores',scoreEat(:,1:3),'Varlabels', columnTitles);
figure();
figure2 = biplot(coeffNotEat(:,1:3),'Scores',scoreNotEat(:,1:3),'Varlabels', columnTitles);
