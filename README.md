# CSE572DataMining
Special note for the Phase_2_SVD:
    I had to add zero padding to the smaller of the IMU or EMG since they had different dimensions. This is because I had to merge the two first before normalizing and then calling SVD function.

Phase_1_Data: 
    Has all the data that was cleaned and only has the values separted by eating and non eating

Phase_2_Data:
    This contains all the graphs and data files that were processed.
    You can run files like Phase_2_Mean.m to obtain the means for each eating and non eating action and utensil.
    The files with the word Plot in them will create a plot that compares and contrasts the plots for eating and non eating actions for fork.


Phase_3_Data:
    This contians the data that was used to create the PCA data.