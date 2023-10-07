function res = getCorner(id)
%% CHANGE THE NAME OF THE FUNCTION TO getCorner
    %% Input Parameter Description
    % id = List of all the AprilTag ids detected in the current image(data)
    
    %% Output Parameter Description
    % res = List of the coordinates of the 4 corners (or 4 corners and the
    % centre) of each detected AprilTag in the image in a systematic method

    % Define the size of the AprilTag (in meters)
    tagSize = 0.152;
    
    % Define the position of the top-left corner of the mat (in meters)
    matPosition = [0, 0];
    
    % Define the spacing between tags (in meters)
    tagSpacing = 0.152;
    
    % Define the extra spacing between tags in columns 3-4 and 6-7 (in meters)
    extraSpacing = 0.178 - tagSpacing;
    
    % Initialize an empty matrix to store the centers of the tags
    tagCenters = zeros(12, 9, 2);
    
    % Iterate through the rows and columns of the tag IDs matrix
    for row = 1:12
        for col = 1:9
            % Compute the position of the top-left corner of the tag in the world frame
            x = (row-1) * 2*tagSize+tagSize/2;
            y = (col-1) * 2*tagSize+tagSize/2;
            if col >= 4
                y = y + extraSpacing;
            end
            if col >= 7
                y = y + extraSpacing;
            end
            tagPosition = matPosition + [x, y];
            
            % Compute the center of the tag in the world frame
            tagCenter = tagPosition;
            
            % Store the center of the tag in the output matrix
            tagCenters(row, col, :) = tagCenter;
            
        end
    end

    p1 = zeros(12, 9, 2);
    p2 = zeros(12, 9, 2);
    p3 = zeros(12, 9, 2);
    p4 = zeros(12, 9, 2);
    
    for row = 1:12
        for col = 1:9
            q = tagCenters(row,col,1);
            r = tagCenters(row,col,2);
            bl = [q+0.076,r-0.076];
            br = [q+0.076,r+0.076];
            tl = [q-0.076,r-0.076];
            tr = [q-0.076,r+0.076];

            p1(row,col,:) = bl;
            p2(row,col,:) = br;
            p4(row,col,:) = tl;
            p3(row,col,:) = tr;
        end
    end
    
    tag = [0, 12, 24, 36, 48, 60, 72, 84,  96;
 
             1, 13, 25, 37, 49, 61, 73, 85,  97;
            
             2, 14, 26, 38, 50, 62, 74, 86,  98;
             
             3, 15, 27, 39, 51, 63, 75, 87,  99;
             
             4, 16, 28, 40, 52, 64, 76, 88, 100;
             
             5, 17, 29, 41, 53, 65, 77, 89, 101;
             
             6, 18, 30, 42, 54, 66, 78, 90, 102;
             
             7, 19, 31, 43, 55, 67, 79, 91, 103;
             
             8, 20, 32, 44, 56, 68, 80, 92, 104;
             
             9, 21, 33, 45, 57, 69, 81, 93, 105;
            
             10, 22, 34, 46, 58, 70, 82, 94, 106;
            
             11, 23, 35, 47, 59, 71, 83, 95, 107];
    res = zeros(length(id),4,2);
    for i = 1:length(id)

        [r_index,c_index] = find(tag == id(i));
        
        res(i,1,:) = p1(r_index,c_index,:);
        res(i,2,:) = p2(r_index,c_index,:);
        res(i,3,:) = p3(r_index,c_index,:);
        res(i,4,:) = p4(r_index,c_index,:);

    end
end