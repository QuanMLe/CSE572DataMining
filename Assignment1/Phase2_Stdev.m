clear all
close all
clc

% This call gets the path of the folder that the script that is running
scriptPath = pwd;
% This will work if the Phase I data is in the same directory as the script
dataPath = strcat(scriptPath,'\Phase_1_Data');
%Path to Myo Data
myoPath = strcat(scriptPath,'\MyoData');
% Path where the Standard_Deviation files will be written out
outputPath = strcat(scriptPath,'\Phase_2_Data\Stdev');
mkdir(outputPath);

inputList = ls(dataPath);
% Removes the '.' and '..' directories from list
inputList = inputList(3:end,:);

%Converts inputList into a cell array of character vectors
inputList = cellstr(inputList);

% This is for keeping track of the the user number when we write out files
userNums = ls(myoPath);
userNums = userNums(3:end,:);

% Loop that runs through the files and gets the Standard_Deviation
% The loop is based on the 'User<number>' folders in Myo Data
for i = 1 : size(userNums, 1)
    % Gets file names for fork eating data
    userData = inputList(contains(inputList,userNums(i,:))); 
    userForkEat = userData(contains(userData,'Fork_Eat'));
    % Loads variables from .mat files
    load(strcat(dataPath,'\',userForkEat{1}));
    load(strcat(dataPath,'\',userForkEat{2}));
    % Does Standard_Deviation calculations
    forkEatStandard_DeviationEMG = std(EMG_Fork_Eat);
    forkEatStandard_DeviationIMU = std(IMU_Fork_Eat);
    Fork_Eat_Data = [forkEatStandard_DeviationIMU,forkEatStandard_DeviationEMG];
    Fork_Eat_Data = normalize(Fork_Eat_Data);
    % Saves the data to the path
    save(fullfile(outputPath, strcat(userNums(i,:),'_','Fork_Eat.mat')),'Fork_Eat_Data');

    % Gets file names for fork non-eating data
    userForkNotEat = userData(contains(userData,'Fork_NotEat'));
    % Loads variables from .mat files
    load(strcat(dataPath,'\',userForkNotEat{1}));
    load(strcat(dataPath,'\',userForkNotEat{2}));
    % Does Standard_Deviation calculations
    forkNotEatStandard_DeviationEMG = std(EMG_Fork_NotEat);
    forkNotEatStandard_DeviationIMU = std(IMU_Fork_NotEat);
    Fork_NotEat_Data = [forkNotEatStandard_DeviationIMU,forkNotEatStandard_DeviationEMG];
    Fork_NotEat_Data = normalize(Fork_NotEat_Data);
    % Saves the data to the path
    save(fullfile(outputPath, strcat(userNums(i,:),'_','Fork_NotEat.mat')),'Fork_NotEat_Data');

    % Gets file names for spoon eating data
    userSpoonEat = userData(contains(userData,'Spoon_Eat'));
    % Loads variables from .mat files
    load(strcat(dataPath,'\',userSpoonEat{1}));
    load(strcat(dataPath,'\',userSpoonEat{2}));
    % Does Standard_Deviation calculations
    userSpoonEatEMG = std(EMG_Spoon_Eat);
    userSpoonEatIMU = std(IMU_Spoon_Eat);
    Spoon_Eat_Data = [userSpoonEatIMU,userSpoonEatEMG];
    Spoon_Eat_Data = normalize(Spoon_Eat_Data);
    % Saves the data to the path
    save(fullfile(outputPath, strcat(userNums(i,:),'_','Spoon_Eat.mat')),'Spoon_Eat_Data');

    % Gets file names for spoon non-eating data
    userSpoonNotEat = userData(contains(userData,'Spoon_NotEat'));
    % Loads variables from .mat files
    load(strcat(dataPath,'\',userSpoonNotEat{1}));
    load(strcat(dataPath,'\',userSpoonNotEat{2}));
    % Does Standard_Deviation calculations
    userSpoonNotEatEMG = std(EMG_Spoon_NotEat);
    userSpoonNotEatIMU = std(IMU_Spoon_NotEat);
    Spoon_NotEat_Data = [userSpoonNotEatIMU,userSpoonNotEatEMG];
    Spoon_NotEat_Data = normalize(Spoon_NotEat_Data);
    % Saves the data to the path
    save(fullfile(outputPath, strcat(userNums(i,:),'_','Spoon_NotEat.mat')),'Spoon_NotEat_Data');
    
end
display('Standard_Deviation has been calculated');