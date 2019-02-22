clear all
close all
clc

% This call gets the path of the folder that the script that is running
data_path = pwd;

% Path where the PCA files will be written out
outputPath = strcat(data_path,'\Phase_1');
mkdir(outputPath);

% Fetches file names from myoData
user_list = ls(data_path);

% Removes the '.' and '..' directories from list
user_list = user_list(3:end,:);

% Converts inputList into a cell array of character vectors
user_list = cellstr(user_list);
fork_data_files = cellstr(user_list);

% Finds only the user files
user_list = user_list(contains(user_list,'user'));

% Finds only the .mat files
fork_data_files = fork_data_files(contains(fork_data_files,'mat'));

% Get the column names for data table
col_names = ["Precision_SVM", "Recall_SVM", "F_Score_SVM", "Precision_DT", "Recall_DT", "F_Score_DT",...
"Precision_NN", "Recall_NN", "F_Score_NN"];

% Loop that goes through per user and runs the train_test function
for i = 1 : size(user_list, 1)
    for j = 1 : size(fork_data_files, 1)
    load(strcat(data_path,'\',user_list{i},'\','fork\',fork_data_files{j}));
    end
    
    % Function call to do testing
    [Precision_SVM, Recall_SVM, F_score_SVM, Precision_DT, Recall_DT, F_score_DT,...
    Precision_NN, Recall_NN, F_score_NN] = ...
    Train_Test(Training_Eat_Data,Training_NotEat_Data, Test_Eat_Data, Test_NotEat_Data);
    
    % Store all the data into a matrix
    data = [Precision_SVM, Recall_SVM, F_score_SVM, Precision_DT, Recall_DT, F_score_DT,...
    Precision_NN, Recall_NN, F_score_NN];

    % Combines the data and column names
    user_data_table = [col_names;data];
    
    filename = strcat(user_list{i},'_data.mat');
    % Saves the data to the output path Phase_2
    save(fullfile(outputPath,filename),'user_data_table');
    
end