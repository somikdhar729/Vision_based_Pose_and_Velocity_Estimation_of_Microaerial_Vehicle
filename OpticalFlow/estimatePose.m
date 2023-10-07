function [position, orientation, R_c2w] = estimatePose(data, t)
%% CHANGE THE NAME OF THE FUNCTION TO estimatePose
% Please note that the coordinates for each corner of each AprilTag are
% defined in the world frame, as per the information provided in the
% handout. Ideally a call to the function getCorner with ids of all the
% detected AprilTags should be made. This function should return the X and
% Y coordinate of each corner, or each corner and the centre, of all the
% detected AprilTags in the image. You can implement that anyway you want
% as long as the correct output is received. A call to that function
% should made from this function.
    %% Input Parameter Defination
    % data = the entire data loaded in the current dataset
    % t = index of the current data in the dataset
    
    %% Output Parameter Defination
    
    % position = translation vector representing the position of the
    % drone(body) in the world frame in the current time, in the order XYZ
    
    % orientation = euler angles representing the orientation of the
    % drone(body) in the world frame in the current time, in the order XYZ
    
    %R_c2w = Rotation which defines camera to world frame

    K = [311.0520, 0, 201.8724;0, 311.3885, 113.6210;0, 0, 1];
    
    inv_K = K^(-1);
    n_tags = size(data(t).id, 2);


    world_points = zeros(n_tags, 8);
    for j = 1:n_tags
        id = data(t).id(j);
        corners = reshape(getCorner(id), [4, 2]);
        
        world_points(j,:) =  reshape(corners.', 1, []);
    end
    
    img_points = zeros(n_tags, 8);
    for j = 1:n_tags
        img_points(j,:) = [data(t).p1(:,j)', data(t).p2(:,j)', data(t).p3(:,j)', data(t).p4(:,j)'];
        
    
    end

   A = zeros(2 * n_tags * 4, 9);
    for j = 1:n_tags
        for k = 1:4
            idx = (j - 1) * 4 + k;
            A(2 * idx - 1, :) = [world_points(j, 2*k-1), world_points(j, 2*k), 1, 0, 0, 0, -img_points(j, 2*k-1)*world_points(j, 2*k-1), -img_points(j, 2*k-1)*world_points(j, 2*k), -img_points(j, 2*k-1)];
            A(2 * idx, :) = [0, 0, 0, world_points(j, 2*k-1), world_points(j, 2*k), 1, -img_points(j, 2*k)*world_points(j, 2*k-1), -img_points(j, 2*k)*world_points(j, 2*k), -img_points(j, 2*k)];
        end
    end

    [~, ~, V] = svd(A);
    H = reshape(V(:, end), [3, 3])';
    H = H*sign(V(9,9));
    
    T_CB = [cos(pi/4) sin(pi/4) 0 -0.04;
            -sin(pi/4) cos(pi/4) 0 0;
            0 0 1 -0.03;
            0 0 0 1];

    % Compute the camera pose estimation from the homography matrix and the camera matrix


    lambda = 1/sqrt(norm(inv_K * H(:, 1)) * norm(inv_K * H(:, 2)));
    r1 = lambda*inv_K*H(:,1);
    r2 = lambda*inv_K*H(:,2);
    r3 = cross(r1,r2);
    t = lambda*inv_K*H(:,3);


    R = [r1, r2, r3];

    
    % Apply SVD decomposition to remove the noise in the rotation matrix
    [U1,~,V1] = svd(R');
    R_est = U1*diag([1,1,det(U1*V1')])*V1';
    t_est = -R_est*t;

    T =  [R_est, t_est; 0 0 0 1]*T_CB^(-1);
    position = T(1:3, 4)';
    ori = T(1:3,1:3);

    [ori2,ori1] = rotm2eul(ori, 'XYZ');
    orientation = ori2;


    R_c2w = R_est;
    
end