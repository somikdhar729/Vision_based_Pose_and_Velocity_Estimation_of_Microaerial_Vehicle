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
  
  ### Comments on the obtained results for the three datasets
  • For the two datasets, position, orientation and velocity from the raw data and estimated states represent the
  uncertainty bounds reflecting errors in the estimates.
5. Use the DetectFastFeatures function in MATLAB to detect the pixel location of the features in the camera frames.


6. Use the KLT tracker in MATLAB to track the position of the features as they move in different frames. Using prior information about the speed of the drone, we can estimate the velocity of the features as they move between different frames


7. Based on the selected motion model, we can link the velocity of the features to the velocity of the drones

<p float="left">
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Opticalflow_dataset1.png" width="40%" />
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Opticalflow_dataset4.png" width="40%" /> 
 
</p>
    The Velocity (linear and angular) velocities are shown for both datasets.

8. Applying RANSAC to reject outliers and better refine the velocity estimates.
<p float="left">
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Opticalflow_dataset1_ransac.png" width="40%" />
  <img src="https://github.com/somikdhar729/Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle/blob/main/Opticalflow_dataset4_ransac.png" width="40%" /> 
 
</p>
The filtered velocity estimates are shown for both datasets (left to right respectively).
<br>

 <center> 
<b> Comments on the obtained results </b> <br>
  • For both datasets, the results improved after running the RANSAC algorithm. <br>
  • For both datasets, I have applied the Butterworth filter of order 3 for the linear velocities and Savitzky-Golay
  filter of order 3 for the angular velocities. <br>
  • Since the velocities are estimated based on the optical flow at these sparse points, there may be regions of the
  image where the flow is not accurately captured, leading to inaccuracies in the estimated velocities. <br>
  • While RANSAC-based outlier rejection is an effective method for removing outliers in the optical flow, it may
  also remove valid data points that have been misclassified as outliers. This can result in the loss of information
  and the generation of inaccurate velocity estimates. <br>
  • The accuracy of the velocity estimation is highly dependent on the accuracy of feature tracking. If the feature
  tracking algorithm is not robust enough to handle changes in illumination, texture, or appearance, then the
  resulting optical flow may be inaccurate and lead to inaccurate velocity estimates. <br>
  • The accuracy of the optical flow and velocity estimation is also dependent on the spatial resolution of the
  image. If the image is undersampled, then the optical flow computation may be inaccurate, and the resulting
  velocity estimates may be inaccurate. </center>

