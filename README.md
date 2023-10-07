# Vision_based_Pose_and_Velocity_Estimation_of_Microaerial_Vehicle

## Abstract
This is a vision based pose and velocity estimation of microaerial vehicle. Given planar distribution of April Tags and corresponding images captured from the drone, the planar homography matrix was formulated and the homography matrix is decomposed into rotation and translation vector respecting the orthonormality constraints. To estimate the velocity of the drone as it moves between different frames, interesting points are detected from the frames and using KLT object tracker, we can estimate the velocity of the features as they move in different frames. The velocity of the drone can be estimated based on motion model given the velocity of the features and then RANSAC for outlier rejection is then applied.

## Process Flow
The pipeline of the vision based pose and velocity estimation is explained below.

1. Formulate the correspondencies between the image plane and planar distribution of april tags
