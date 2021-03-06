clear all
close all
clc

% This call gets the path of the folder that the script that is running
script_path = pwd;
data_path = strcat(script_path,'\Phase_2');

% Path where the PCA files will be written out
outputPath = strcat(data_path,'\Graphs');
mkdir(outputPath);

% Loads data from Phase 2
load(strcat(data_path,'\','overall_data_table.mat'));


x = {'Precision\_SVM', 'Recall\_SVM', 'F\_Score\_SVM', 'Precision\_DT', 'Recall\_DT', 'F\_Score\_DT',...
'Precision\_NN', 'Recall\_NN', 'F\_Score\_NN'};
x = categorical(x);
y = str2double(overall_data_table(2,:));

% Plots bar graph and saves
hold on;
fig = bar(x,y);
title("Overall Data for Machine Learning");
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold off;
savepath = strcat(outputPath,"\Overall_Bar_Graph.png");
saveas(fig,savepath,'png');

% Plots scatter graph

fig = scatter(x,y,'filled');
hold on;
title("Overall Data for Machine Learning");
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold off;
savepath = strcat(outputPath,"\Overall_Scatter.png");
saveas(fig,savepath,'png'); 