# Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle

## Abstract
This is a vision-based pose and velocity estimation of microaerial vehicles. Given the planar distribution of April Tags and corresponding images captured from the drone, the planar homography matrix was formulated and the homography matrix was decomposed into rotation and translation vectors respecting the orthonormality constraints. To estimate the velocity of the drone as it moves between different frames, interesting points are detected from the frames, and using the KLT object tracker, we can estimate the velocity of the features as they move in different frames. The velocity of the drone can be estimated based on the motion model given the velocity of the features and then RANSAC for outlier rejection is then applied.

## Process Flow
The pipeline of the vision-based pose and velocity estimation is explained below.

1. Formulate the correspondencies between the image plane and planar distribution of April tags
![alt text](https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/april_tags.png?raw=true)

2. After formulating the planar homography matrix, Apply SVD and solve for the entries of the homography matrix


3. Decompose the Homography matrix into rotation matrix and translation vector respecting the orthonormality constraints of the rotation matrix through nonlinear optimization approach


4. Compare the pose estimated from the homography approach versus ground truth data obtained from the Vicon system on board the nano++ quadrotor

<p float="left">
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Pose_estimation_Dataset1.png" width="40%" />
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Pose_estimation_Dataset4.png" width="40%" /> 
 
</p>
Two captured datasets are shown in the left(dataset 1) and right images(dataset 4) respectively.

5. Use the DetectFastFeatures function in MATLAB to detect the pixel location of the features in the camera frames.


6. Use the KLT tracker in MATLAB to track the position of the features as they move in different frames. Using prior information about the speed of the drone, we can estimate the velocity of the features as they move between different frames


7. Based on the selected motion model, we can link the velocity of the features to the velocity of the drones

<p float="left">
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Opticalflow_dataset1.png" width="40%" />
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Opticalflow_dataset4.png" width="40%" /> 
 
</p>
