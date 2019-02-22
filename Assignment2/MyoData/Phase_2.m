clear all
close all
clc

% This call gets the path of the folder that the script that is running
data_path = pwd;

% Path where the PCA files will be written out
outputPath = strcat(data_path,'\Phase_2');
mkdir(outputPath);

% Fetches file names from myoData
fork_data_files = ls(data_path);
% Removes the '.' and '..' directories from list
fork_data_files = fork_data_files(3:end,:);

% Converts fork data list into a cell array of character vectors
fork_data_files = cellstr(fork_data_files);

% Finds only the .mat files
fork_data_files = fork_data_files(contains(fork_data_files,'mat'));

% Loop that loads in the data files
for i = 1 : size(fork_data_files, 1)
    load(strcat(data_path,'\',fork_data_files{i}));
end

% Function call to do testing
[Precision_SVM, Recall_SVM, F_score_SVM, Precision_DT, Recall_DT, F_score_DT,...
Precision_NN, Recall_NN, F_score_NN] = ...
Train_Test(Training_Eat_Data,Training_NotEat_Data, Test_Eat_Data, Test_NotEat_Data);

% Store all the data into a matrix
data = [Precision_SVM, Recall_SVM, F_score_SVM, Precision_DT, Recall_DT, F_score_DT,...
Precision_NN, Recall_NN, F_score_NN];

% Get the column names for data table
col_names = ["Precision_SVM", "Recall_SVM", "F_Score_SVM", "Precision_DT", "Recall_DT", "F_Score_DT",...
"Precision_NN", "Recall_NN", "F_Score_NN"];

% Combines the data and column names
overall_data_table = [col_names;data];

% Saves the data to the output path Phase_2
save(fullfile(outputPath,'overall_data_table.mat'),'overall_data_table');
