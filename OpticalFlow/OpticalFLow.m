%% PROJECT 2 VELOCITY ESTIMATION
close all;
clear all;
clc;
addpath('../data')

%Change this for both dataset 1 and dataset 4. Do not use dataset 9.
datasetNum = 1;

[sampledData, sampledVicon, sampledTime] = init(datasetNum);

%% INITIALIZE CAMERA MATRIX AND OTHER NEEDED INFORMATION
K = [311.0520        0        201.8724;
 
  0         311.3885    113.6210;
 
  0            0           1   ]; % Camera matrix
inv_K = K^(-1);
T_CB = [cos(pi/4), sin(pi/4), 0, -0.04; -sin(pi/4), cos(pi/4), 0, 0; 0, 0, 1, -0.03; 0, 0, 0, 1];

tracker = vision.PointTracker('MaxBidirectionalError',1);

for n = 2:length(sampledData)
    %% Initalize Loop load images
    prev_image = sampledData(n-1).img;
    curr_image = sampledData(n).img;
    dt = 0.025;
    %% Detect good points
    prev_corner = detectFASTFeatures(prev_image);
    prev_corners_strongest = selectStrongest(prev_corner,50);
    prev_points = prev_corners_strongest.Location;
    %% Initalize the tracker to the last frame.
    
    initialize(tracker,prev_points, prev_image); 
    %% Find the location of the next points;
    [curr_points, valid] = step(tracker, curr_image);
    %% Calculate velocity
    %% Calculate Height
    % Use a for loop
    img_vel = zeros(100,1);
    Z = zeros(50,1);
    [position, orientation, R_c2w] = estimatePose(sampledData,n);
    curr_points_norm1 = zeros(50,2);
    pos = T_CB^(-1)*[position,1]';
    R_b2w = eul2rotm(orientation,'XYZ');
    for i = 1:50
       prev_point_norm = inv_K*[prev_points(i, :), 1]';
       curr_point_norm = inv_K*[curr_points(i, :) 1]'; 
       curr_points_norm1(i,:) = curr_point_norm(1:2);
       udx = (curr_point_norm(1) - prev_point_norm(1)) / dt;
       udy = (curr_point_norm(2) - prev_point_norm(2)) / dt;
       img_vel(2*i-1:2*i) = [udx;udy];
        Z(i) = (-R_c2w(3, 1) * curr_point_norm(1) - R_c2w(3, 2) * curr_point_norm(2) - pos(3)) / R_c2w(3, 3);

    end
    

    %% RANSAC    
    % Write your own RANSAC implementation in the file velocityRANSAC

    ransac_flag = true; % RANSAC flag for activating the ransac function 
    Vel = velocityRANSAC(img_vel,curr_points_norm1,Z,R_c2w,0.7,ransac_flag);

    %% Thereshold outputs into a range.
    % Not necessary
    
    %% Fix the linear velocity
    % Change the frame of the computed velocity to world frame
    S = [0 -0.03 0;0.03 0 -0.04;0 0.04 0];
    ADJOINT = [T_CB(1:3,1:3) -T_CB(1:3,1:3)*S;zeros(3,3) T_CB(1:3,1:3)];
    Vel = ADJOINT*(Vel);
    Vel(1:3) = R_b2w'*Vel(1:3);
    Vel(4:6) = R_b2w'*Vel(4:6);
    %% ADD SOME LOW PASS FILTER CODE
    % Not neceessary but recommended 
    estimatedV(:,n) = Vel;
    
    %% STORE THE COMPUTED VELOCITY IN THE VARIABLE estimatedV AS BELOW
%     estimatedV(:,n) = Vel; % Feel free to change the variable Vel to anything that you used.
    % Structure of the Vector Vel should be as follows:
    % Vel(1) = Linear Velocity in X
    % Vel(2) = Linear Velocity in Y
    % Vel(3) = Linear Velocity in Z
    % Vel(4) = Angular Velocity in X
    % Vel(5) = Angular Velocity in Y
    % Vel(6) = Angular Velocity in Z

    tracker.release();
end


Wn = 0.075;
n = 3;  % filter order

% Design the filter
[b, a] = butter(n, Wn, 'low');
estimatedV(1,:) = filtfilt(b,a,estimatedV(1,:));%Linear Velocity in X
estimatedV(2,:) = filtfilt(b,a,estimatedV(2,:));%Linear Velocity in Y
estimatedV(3,:) = filtfilt(b,a,estimatedV(3,:));%Linear Velocity in Z
estimatedV(4,:) = sgolayfilt(double(estimatedV(4,:)),3,7);%Angular Velocity in X
estimatedV(5,:) = sgolayfilt(double(estimatedV(5,:)),3,7);%Angular Velocity in Y
estimatedV(6,:) = sgolayfilt(double(estimatedV(6,:)),3,7);%Angular Velocity in Z

plotData(estimatedV, sampledData, sampledVicon, sampledTime, datasetNum)
