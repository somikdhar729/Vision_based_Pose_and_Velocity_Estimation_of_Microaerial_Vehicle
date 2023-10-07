function [Vel] = velocityRANSAC(optV,optPos,Z,R_c2w,e,ransac_flag)
%% CHANGE THE NAME OF THE FUNCTION TO velocityRANSAC
    %% Input Parameter Description
    % optV = The optical Flow
    % optPos = Position of the features in the camera frame 
    % Z = Height of the drone
    % R_c2w = Rotation defining camera to world frame
    % e = RANSAC hyper parameter    
    
    %% Output Parameter Description
    % Vel = Linear velocity and angualr velocity vector
    
    H = zeros(2*length(optPos),6);
    x = optPos(:,1);
    y = optPos(:,2);
    for i = 1:length(optPos)
        Z_i = Z(i);
        A_i = (1/Z_i)*[-1, 0, x(i); 0, -1, y(i)];
        B_i = [x(i)*y(i), -1+x(i)^2, y(i); 1+y(i)^2, -x(i)*y(i), -x(i)];
        H(2*i-1:2*i,:) = [A_i,B_i];
    end

    Vel = pinv(H)*optV;

    if ransac_flag
        
        V_ini = Vel;
        p_suc = 0.99;
        thresh = 0.0001;
        current_inlier = 0;
        previous_inlier =0;
        k = int16(log(1 - p_suc)/log(1 - e^3));
        h_temp = zeros(6,6);
        for itx = 1:k   % # RANSAC iterations
            randI = randperm(length(optPos), 3);  % generate 3 unique feature indices
            v1 = optV(2*randI(1)-1:2*randI(1));       % extract 3 random velocities per iteration
            v2 = optV(2*randI(2)-1:2*randI(2));
            v3 = optV(2*randI(3)-1:2*randI(3));
            v = [v1;v2;v3];
            for i1 = 1:3
                Z_i = Z(randI(i1));
                A_temp = (1/Z_i).* [-1    0   x(randI(i1)) ; 0   -1  y(randI(i1)) ];
                B_temp = [ x(randI(i1))*y(randI(i1)) -(1+(x(randI(i1))^2))    y(randI(i1)) ;
                    (1+(y(randI(i1))^2))    -x(randI(i1))*y(randI(i1))  -x(randI(i1))];
                h_temp(2*i1-1:2*i1,:) = [A_temp B_temp];
            end
            Vel_temp = pinv(h_temp)*v;
            
            % count inliers for this iteration
            current_inlier = sum((vecnorm(H*Vel_temp - optV, 2, 2).^2) < thresh);
            if current_inlier > previous_inlier
                Vel = Vel_temp;
                previous_inlier = current_inlier;
            end
        end
    end
end