clear all 
clc
close all

scriptPath = pwd;
dataPath = strcat(scriptPath,'\Phase_2_Data\SVD');
inputList = ls(dataPath);

outputPath = strcat(scriptPath,'\Phase_2_Data\Graphs\SVD');
phase3DataPathEat = strcat(scriptPath,'\Phase_3_Data\Eat');
phase3DataPathNotEat = strcat(scriptPath,'\Phase_3_Data\Not_Eat');
mkdir(outputPath);
mkdir(phase3DataPathEat);
mkdir(phase3DataPathNotEat);

%Path to Myo Data
myoPath = strcat(scriptPath,'\MyoData');
% Removes the '.' and '..' directories from list
inputList = inputList(3:end,:);

%Converts inputList into a cell array of character vectors
inputList = cellstr(inputList);
%Loads coeffs and content from files
coeffsData = inputList(contains(inputList,'Coeffs'));
contentData = inputList(contains(inputList,'Content'));

% This is for keeping track of the the user number when we write out files
userNums = ls(myoPath);
userNums = userNums(3:end,:);

load(strcat(dataPath,'\',coeffsData{1}));
load(strcat(dataPath,'\',coeffsData{2}));
load(strcat(dataPath,'\',coeffsData{3}));
load(strcat(dataPath,'\',coeffsData{4}));

load(strcat(dataPath,'\',contentData{1}));
load(strcat(dataPath,'\',contentData{2}));
load(strcat(dataPath,'\',contentData{3}));
load(strcat(dataPath,'\',contentData{4}));

columnTitles = ["ori_x","ori_y","ori_z","ori_w","accel_x","accel_y","accel_z","gyro_x","gyro_y","gyro_z","emg_1","emg_2","emg_3","emg_4","emg_5","emg_6","emg_7","emg_8"];
legend(columnTitles);

% plot(Users_Fork_Eat_Coeffs);


forkEatFeatureMatrix = Users_Fork_Eat_Content * Users_Fork_Eat_Coeffs;
forkNotEatFeatureMatrix = Users_Fork_NotEat_Content * Users_Fork_NotEat_Coeffs;
spoonEatFeatureMatrix = Users_Spoon_Eat_Content * Users_Spoon_Eat_Coeffs;
spoonNotEatFeatureMatrix = Users_Spoon_NotEat_Content * Users_Spoon_NotEat_Coeffs;

%Saves the data for later use in Phase III
save(fullfile(phase3DataPathEat, strcat('\Fork_SVD_Eat.mat')),'forkEatFeatureMatrix');
save(fullfile(phase3DataPathNotEat, strcat('\Fork_SVD_NotEat.mat')),'forkNotEatFeatureMatrix');

users = [];

for i = 1 : size(userNums, 1)
    % Adds the users to a string array for later use
    users = [users;convertCharsToStrings(userNums(i,:))];
end

users = categorical(users);
labels = ["Eating Data", "Non-Eating Data"];

for i = 1 : size(forkEatFeatureMatrix, 1)
    ori_z_eat = forkEatFeatureMatrix(:,i);
    ori_z_not_eat = forkNotEatFeatureMatrix(:,i);
    fig = plot(users,ori_z_eat,'r-');
    hold on;
    fig = plot(users,ori_z_not_eat,'b-');
    title(strcat(upper(columnTitles{i}), " SVD"));
    legend(labels);
    legend('Location', 'eastoutside');
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    hold off;
    savepath = strcat(outputPath,"\",columnTitles{i},"_svd.png");
    saveas(fig,savepath,'png'); 
end