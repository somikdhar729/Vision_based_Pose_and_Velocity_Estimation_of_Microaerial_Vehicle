# Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle

## Abstract
This is a vision based pose and velocity estimation of microaerial vehicle. Given planar distribution of April Tags and corresponding images captured from the drone, the planar homography matrix was formulated and the homography matrix is decomposed into rotation and translation vector respecting the orthonormality constraints. To estimate the velocity of the drone as it moves between different frames, interesting points are detected from the frames and using KLT object tracker, we can estimate the velocity of the features as they move in different frames. The velocity of the drone can be estimated based on motion model given the velocity of the features and then RANSAC for outlier rejection is then applied.

## Process Flow
The pipeline of the vision based pose and velocity estimation is explained below.

1. Formulate the correspondencies between the image plane and planar distribution of april tags
![alt text](https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/april_tags.png?raw=true)

2. After formulating the planar homography matrix, Apply SVD and solve for the entries of the homography matrix


3. Decompose the Homography matrix into rotation matrix and translation vector respecting the orthonormality constraints of the rotation matrix through non linear optimization approach


4. Compare the pose estimated from the homography approach versus ground truth data obtained from Vicon system on board the nano++ quadrotor

<p float="left">
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Pose_estimation_Dataset1.png" width="20%" />
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Pose_estimation_Dataset4.png" width="20%" /> 
 
</p>
<!-- ![alt text](https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Pose_estimation_Dataset1.png?raw=true)
![alt text](https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Pose_estimation_Dataset4.png?raw=true) -->

