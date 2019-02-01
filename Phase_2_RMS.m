clear all
close all
clc

% This call gets the path of the folder that the script that is running
scriptPath = pwd;
% This will work if the Phase I data is in the same directory as the script
dataPath = strcat(scriptPath,'\Phase_1_Data');
%Path to Myo Data
myoPath = strcat(scriptPath,'\MyoData');
% Path where the RMS files will be written out
outputPath = strcat(scriptPath,'\Phase_2_Data\RMS');
mkdir(outputPath);

inputList = ls(dataPath);
% Removes the '.' and '..' directories from list
inputList = inputList(3:end,:);

%Converts inputList into a cell array of character vectors
inputList = cellstr(inputList);

% This is for keeping track of the the user number when we write out files
userNums = ls(myoPath);
userNums = userNums(3:end,:);


%Loop that runs through the files and gets the RMS
for i = 1 : size(userNums, 1)
    % Gets file names for fork eating data
    userData = inputList(contains(inputList,userNums(i,:))); 
    userForkEat = userData(contains(userData,'Fork_Eat'));
    % Loads variables from .mat files
    load(strcat(dataPath,'\',userForkEat{1}));
    load(strcat(dataPath,'\',userForkEat{2}));
    
    % I do padding in the IMU because EMG has more elements
    diffRow = abs(length(IMU_Fork_Eat)-length(EMG_Fork_Eat));
    if (length(IMU_Fork_Eat) > length(EMG_Fork_Eat))
        padding = zeros(diffRow,size(EMG_Fork_Eat,2));
        EMG_Fork_Eat = [EMG_Fork_Eat;padding];
    else
        padding = zeros(diffRow,size(IMU_Fork_Eat,2));
        IMU_Fork_Eat = [IMU_Fork_Eat;padding];
    end
 
    % Does RMS calculations, I then do the sum function to flatten the matrix
    % so the diagonal values are saved in a smaller format.
    
    Fork_Eat_Data = [IMU_Fork_Eat EMG_Fork_Eat];
    Fork_Eat_Data = normalize(Fork_Eat_Data);
    Fork_Eat_Data = rms(Fork_Eat_Data);
    % Saves the data to the path
    save(fullfile(outputPath, strcat(userNums(i,:),'_','Fork_Eat.mat')),'Fork_Eat_Data');
    
    % Gets file names for fork non-eating data
    userForkNotEat = userData(contains(userData,'Fork_NotEat'));
    % Loads variables from .mat files
    load(strcat(dataPath,'\',userForkNotEat{1}));
    load(strcat(dataPath,'\',userForkNotEat{2}));
    
    % I do padding in the IMU because EMG has more elements
    diffRow = abs(length(IMU_Fork_NotEat)-length(EMG_Fork_NotEat));
    if (length(IMU_Fork_NotEat) > length(EMG_Fork_NotEat))
        padding = zeros(diffRow,size(EMG_Fork_NotEat,2));
        EMG_Fork_NotEat = [EMG_Fork_NotEat;padding];
    else
        padding = zeros(diffRow,size(IMU_Fork_NotEat,2));
        IMU_Fork_NotEat = [IMU_Fork_NotEat;padding];
    end
    
    % Does RMS calculations
    Fork_NotEat_Data = [IMU_Fork_NotEat EMG_Fork_NotEat];
    Fork_NotEat_Data = normalize(Fork_NotEat_Data);
    Fork_NotEat_Data = rms(Fork_NotEat_Data);
    % Saves the data to the path
    save(fullfile(outputPath, strcat(userNums(i,:),'_','Fork_NotEat.mat')),'Fork_NotEat_Data');

    % Gets file names for spoon eating data
    userSpoonEat = userData(contains(userData,'Spoon_Eat'));
    % Loads variables from .mat files
    load(strcat(dataPath,'\',userSpoonEat{1}));
    load(strcat(dataPath,'\',userSpoonEat{2}));
    
    % I do padding in the IMU because EMG has more elements
    diffRow = abs(length(IMU_Spoon_Eat)-length(EMG_Spoon_Eat));
    if (length(IMU_Spoon_Eat) > length(EMG_Spoon_Eat))
        padding = zeros(diffRow,size(EMG_Spoon_Eat,2));
        EMG_Spoon_Eat = [EMG_Spoon_Eat;padding];
    else
        padding = zeros(diffRow,size(IMU_Spoon_Eat,2));
        IMU_Spoon_Eat = [IMU_Spoon_Eat;padding];
    end
    
    % Does RMS calculations
    Spoon_Eat_Data = [IMU_Spoon_Eat EMG_Spoon_Eat];
    Spoon_Eat_Data = normalize(Spoon_Eat_Data);
    Spoon_Eat_Data  = rms(Spoon_Eat_Data);
    % Saves the data to the path
    save(fullfile(outputPath, strcat(userNums(i,:),'_','Spoon_Eat.mat')),'Spoon_Eat_Data');

    % Gets file names for spoon non-eating data
    userSpoonNotEat = userData(contains(userData,'Spoon_NotEat'));
    % Loads variables from .mat files
    load(strcat(dataPath,'\',userSpoonNotEat{1}));
    load(strcat(dataPath,'\',userSpoonNotEat{2}));
    
    % I do padding in the IMU because EMG has more elements
    diffRow = abs(length(IMU_Spoon_NotEat)-length(EMG_Spoon_NotEat));
    if (length(IMU_Spoon_NotEat) > length(EMG_Spoon_NotEat))
        padding = zeros(diffRow,size(EMG_Spoon_NotEat,2));
        EMG_Spoon_NotEat = [EMG_Spoon_NotEat;padding];
    else
        padding = zeros(diffRow,size(IMU_Spoon_NotEat,2));
        IMU_Spoon_NotEat = [IMU_Spoon_NotEat;padding];
    end
    
    % Does RMS calculations
    Spoon_NotEat_Data = [IMU_Spoon_NotEat EMG_Spoon_NotEat];
    Spoon_NotEat_Data = normalize(Spoon_NotEat_Data);
    Spoon_NotEat_Data = rms(Spoon_NotEat_Data);
    
    % Saves the data to the path
    save(fullfile(outputPath, strcat(userNums(i,:),'_','Spoon_NotEat.mat')),'Spoon_NotEat_Data');

end
disp('RMS has been calculated');