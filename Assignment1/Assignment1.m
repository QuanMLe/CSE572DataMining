clear all
close all
clc


% Write down the path of the MyoData folder
PathMyo = 'C:\Users\mkarami\Desktop\CSE572\MyoData';
% Write down the path of the groundTruth folder
PathGT = 'C:\Users\mkarami\Desktop\CSE572\groundTruth';

FinalPath = 'C:\Users\mkarami\Desktop\CSE572\Result';
list = ls(PathGT);

for i = 3 : size(list, 1)    % for each folder we have in MyoData, ...
    % ls() function will list the folder content
    % Fork Path
    path_fork = PathGT + "\" + list(i, :) + "\" + "fork";
    % list the content of fork folder
    folder_list = ls(path_fork);
    
    StartPoint_EndPoint_Fork = dlmread(path_fork + "\" + strtrim(folder_list(3, :)));
    
    % Spoon Path
    path_spoon = PathGT + "\" + list(i, :) + "\" + "spoon";
    folder_list = ls(path_spoon);
    StartPoint_EndPoint_Spoon = dlmread(path_spoon + "\" + strtrim(folder_list(3, :)));
    
    list = ls(PathMyo);
    % Fork Path
    path_fork = PathMyo + "\" + list(i, :) + "\" + "fork";
    
    % Spoon Path
    path_spoon = PathMyo + "\" + list(i, :) + "\" + "spoon";
    
    
    %%%%%%%% ....::::.... FORK ....::::....%%%%%%%%
    % list the content of fork folder
    folder_list = ls(path_fork);
    
    for j = 3 : size(folder_list, 1)  % for all the files in fork folder, ...
        if contains(folder_list(j, :), "IMU") % find the file that contents IMU substring
            IMU = dlmread(path_fork + "\" + strtrim(folder_list(j, :))); % save the content of IMU file in a matrix  
        end
        
        if contains(folder_list(j, :), "EMG") % find the file that contents EMG substring
            EMG = dlmread(path_fork + "\" + strtrim(folder_list(j, :))); % save the content of EMG file in a matrix
        end
    end 
    EMG_Fork_Eat = [];
    IMU_Fork_Eat = [];
    % go through all the times and extract the emg and imd data
    for j = 1 : size(StartPoint_EndPoint_Fork, 1)
        % converting to msec
        start_frame = StartPoint_EndPoint_Fork(j, 1);
        end_frame = StartPoint_EndPoint_Fork(j, 2);
        start_time_msec = (start_frame/30)*1000;
        end_time_msec = (end_frame/30)*1000;
        
        % finding the ones in between start and end point time
        for k = 1 : size(EMG, 1)
            ind_Eat_EMG = find(EMG(:,1) >= (start_time_msec + EMG(1, 1))...
                & EMG(:,1) <= (end_time_msec + EMG(1, 1)));
        end
        EMG_Fork_Eat = [EMG_Fork_Eat; EMG(ind_Eat_EMG, :)];
        
        
        for k = 1 : size(IMU, 1)
            ind_Eat_IMU = find(IMU(:,1) >= (start_time_msec + IMU(1, 1))...
                & IMU(:,1) <= (end_time_msec + IMU(1, 1)));
        end
        IMU_Fork_Eat = [IMU_Fork_Eat; IMU(ind_Eat_IMU, :)];

    end
    EMG_Fork_Eat = EMG_Fork_Eat(1:2:end, 2:end);
    IMU_Fork_Eat = IMU_Fork_Eat(:, 2:end);
    disp(size(EMG_Fork_Eat))
    disp(size(IMU_Fork_Eat))
    
    % save the others into another matrix as non-eat data
    EMG_Fork_NotEat = setdiff(EMG(:, 2:end), EMG_Fork_Eat, 'rows');
    IMU_Fork_NotEat = setdiff(IMU(:, 2:end), IMU_Fork_Eat,'rows');
    EMG_Fork_NotEat = EMG_Fork_NotEat(1:2:end, 2:end);
    IMU_Fork_NotEat = IMU_Fork_NotEat(:, 2:end);
    % save the extracted data into .mat folder in the path
    save(fullfile(FinalPath,list(i, :)+"_"+'EMG_Fork_Eat.mat'), 'EMG_Fork_Eat');
    save(fullfile(FinalPath,list(i, :)+"_"+'IMU_Fork_Eat.mat'), 'IMU_Fork_Eat');
    save(fullfile(FinalPath,list(i, :)+"_"+'EMG_Fork_NotEat.mat'), 'EMG_Fork_NotEat');
    save(fullfile(FinalPath,list(i, :)+"_"+'IMU_Fork_NotEat.mat'), 'IMU_Fork_NotEat');
    
    
    
    %%%%%%%% ....::::.... SPOON ....::::....%%%%%%%%
    % as same as Fork:
    % list the content of spoon folder
    folder_list = ls(path_spoon);
    
    for j = 3 : size(folder_list, 1)  % for all the files in spoon folder, ...
        
        if contains(folder_list(j, :), "IMU") % find the file that contents IMU substring
            IMU = dlmread(path_spoon + "\" + strtrim(folder_list(j, :))); % save the content of IMU file in a matrix  
        end
        
        if contains(folder_list(j, :), "EMG") % find the file that contents EMG substring
            EMG = dlmread(path_spoon + "\" + strtrim(folder_list(j, :))); % save the content of EMG file in a matrix
        end
        
    
        
    end 
    EMG_Spoon_Eat = [];
    IMU_Spoon_Eat = [];
    for j = 1 : size(StartPoint_EndPoint_Spoon, 1)
        start_frame = StartPoint_EndPoint_Spoon(j, 1);
        end_frame = StartPoint_EndPoint_Spoon(j, 2);
        start_time_msec = (start_frame/30)*1000;
        end_time_msec = (end_frame/30)*1000;
        
        for k = 1 : size(EMG, 1)
            ind_Eat_EMG = find(EMG(:,1) >= (start_time_msec + EMG(1, 1))...
                & EMG(:,1) <= (end_time_msec + EMG(1, 1)));
        end
        EMG_Spoon_Eat = [EMG_Spoon_Eat; EMG(ind_Eat_EMG, :)];
        
        for k = 1 : size(IMU, 1)
            ind_Eat_IMU = find(IMU(:,1) >= (start_time_msec + IMU(1, 1))...
                & IMU(:,1) <= (end_time_msec + IMU(1, 1)));
        end
        IMU_Spoon_Eat = [IMU_Spoon_Eat; IMU(ind_Eat_IMU, :)];

    end
    EMG_Spoon_Eat = EMG_Spoon_Eat(1:2:end, 2:end);
    IMU_Spoon_Eat = IMU_Spoon_Eat(:, 2:end);
    disp(size(EMG_Spoon_Eat))
    disp(size(IMU_Spoon_Eat))
    EMG_Spoon_NotEat = setdiff(EMG(:, 2:end), EMG_Spoon_Eat, 'rows');
    IMU_Spoon_NotEat = setdiff(IMU(:, 2:end), IMU_Spoon_Eat,'rows');
    EMG_Spoon_NotEat = EMG_Spoon_NotEat(1:2:end, 2:end);
    IMU_Spoon_NotEat = IMU_Spoon_NotEat(:, 2:end);
    
    save(fullfile(FinalPath, list(i, :)+"_"+'EMG_Spoon_Eat.mat'), 'EMG_Spoon_Eat');
    save(fullfile(FinalPath, list(i, :)+"_"+'IMU_Spoon_Eat.mat'), 'IMU_Spoon_Eat');
    save(fullfile(FinalPath, list(i, :)+"_"+'IMU_Spoon_NotEat.mat'), 'IMU_Spoon_NotEat');
    save(fullfile(FinalPath, list(i, :)+"_"+'EMG_Spoon_NotEat.mat'), 'EMG_Spoon_NotEat');
    
end