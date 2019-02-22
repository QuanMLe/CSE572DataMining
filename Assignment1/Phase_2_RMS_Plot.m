clear all
close all
clc

% This call gets the path of the folder that the script that is running
scriptPath = pwd;
% This will work if the Phase I data is in the same directory as the script
dataPath = strcat(scriptPath,'\Phase_2_Data\RMS');
%Path to Myo Data
myoPath = strcat(scriptPath,'\MyoData');
% Path where the graph files will be written out
outputPath = strcat(scriptPath,'\Phase_2_Data\Graphs\RMS');
phase3DataPathEat = strcat(scriptPath,'\Phase_3_Data\Eat');
phase3DataPathNotEat = strcat(scriptPath,'\Phase_3_Data\Not_Eat');
mkdir(outputPath);
mkdir(phase3DataPathEat);
mkdir(phase3DataPathNotEat);

% Gets the data from the rms folder of phase II
inputList = ls(dataPath);
% Removes the '.' and '..' directories from list
inputList = inputList(3:end,:);

%Converts inputList into a cell array of character vectors
inputList = cellstr(inputList);

% This is for keeping track of the the user number when we write out files
userNums = ls(myoPath);
userNums = userNums(3:end,:);

% Initialize matrices to receive data within the loop
users = [];
forkRMSEatData = [];
forkRMSNotEatData = [];

%----- Inside Loop -------%



%----- Inside Loop -------%

% Loop to gather all the data from various users
for i = 1 : size(userNums, 1)
    userData = inputList(contains(inputList,userNums(i,:))); 
    userForkEat = userData(contains(userData,'Fork_Eat'));
    load(strcat(dataPath,'\',userForkEat{1}));
    forkRMSEatData = [forkRMSEatData;Fork_Eat_Data];

    userForkEat = userData(contains(userData,'Fork_NotEat'));
    load(strcat(dataPath,'\',userForkEat{1}));
    forkRMSNotEatData = [forkRMSNotEatData;Fork_NotEat_Data];
    
    % Adds the users to a string array for later use
    users = [users;convertCharsToStrings(userNums(i,:))];
end
%Saves the data for later use in Phase III
save(fullfile(phase3DataPathEat, strcat('\Fork_RMS_Eat.mat')),'forkRMSEatData');
save(fullfile(phase3DataPathNotEat, strcat('\Fork_RMS_NotEat.mat')),'forkRMSNotEatData');

columnTitles = ["ori_x","ori_y","ori_z","ori_w","accel_x","accel_y","accel_z","gyro_x","gyro_y","gyro_z","emg_1","emg_2","emg_3","emg_4","emg_5","emg_6","emg_7","emg_8"];
users = categorical(users);
labels = ["Eating Data", "Non-Eating Data"];



for i = 1 : size(forkRMSEatData, 1)
    ori_z_eat = forkRMSEatData(:,i);
    ori_z_not_eat = forkRMSNotEatData(:,i);
    fig = plot(users,ori_z_eat,'r-');
    hold on;
    fig = plot(users,ori_z_not_eat,'b-');
    title(strcat(upper(columnTitles{i}), " RMS"));
    legend(labels);
    legend('Location', 'eastoutside');
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    hold off;
    savepath = strcat(outputPath,"\",columnTitles{i},"_rms.png");
    saveas(fig,savepath,'png'); 
end

% Fork rms eating data 
% T = array2table(forkRMSEatData,'VariableNames',columnTitles);
% T = [array2table(users) T];
% %Writes out data for graphs to be made in csv
% writetable(T,strcat(outputPath,'\Fork_Eat_RMS_Data.csv'))

% % Fork rms not eating data
% T = array2table(forkRMSNotEatData,'VariableNames',columnTitles);
% T = [array2table(users) T];
% % Writes out data for graphs to be made in csv
% writetable(T,strcat(outputPath,'\Fork_NotEat_RMS_Data.csv'))


% Saves figure for orientation data on every user

% x_axis = categorical(users);
% y_axis = forkRMSEatData(1:30,1:4);
% orientationGraph = bar(x_axis,y_axis);
% filename = strcat(outputPath,'\ForkEatOrientationGraph.png');
% savefig(strcat(outputPath,'\ForkEatOrientationGraph.fig'));
% 
% % Saves figure for acceleration data on every user
% x_axis = categorical(users);
% y_axis = forkRMSEatData(1:30,5:7);
% accelerationGraph = bar(x_axis,y_axis);
% savefig(strcat(outputPath,'\ForkEatAccelerationGraph.fig'));
% 
% % Saves figure for gyro data on every user
% x_axis = categorical(users);
% y_axis = forkRMSEatData(1:30,8:10);
% gyroGraph = bar(x_axis,y_axis);
% savefig(strcat(outputPath,'\ForkEatGyroGraph.fig'));
% 
% % Saves figure for gyro data on every user
% x_axis = categorical(users);
% y_axis = forkRMSEatData(1:30,11:18);
% emgGraph = bar(x_axis,y_axis);
% savefig(strcat(outputPath,'\ForkEatEMGGraph.fig'));
% fprintf("Graphs were created");


