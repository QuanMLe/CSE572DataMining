# CSE572DataMining
Special note for the Phase_2_SVD:
    I had to add zero padding to the smaller of the IMU or EMG since they had different dimensions. This is because I had to merge the two first before normalizing and then calling SVD function.