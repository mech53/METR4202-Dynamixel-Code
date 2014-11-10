function XYZ = metric(xyzPoints,pixelxy)

    % returns the X Y Z metric loactions of a point in an image using a
    % pointcloud relative to the camera centre.
    % xyzPoints is a pointcloud generated from 'thepointcloud' function,
    % it's important that the pointcloud is generated with the camera in
    % the same position as it was when taking the image used for pixelxy.
    
    % inputs: xyzPointcloud --> k x m x 3 matrix where k x m is the image
    % size. pixelxy --> n x 2 matrix where n,1 is the nth pixelx and n,2 is
    % the nth pixely
    
    % output: XYZ -- > n x 3 matrix where n,1 through n,3 are the nth 
    % metric X Y Z coordinates respectively
    
    s = size(pixelxy);  % check number of pixel points
    XYZ = zeros(s);     % allocate space for new matrix
    
    max = size(xyzPoints);  % check image size
    
    for i = 1:s(1)  % iterate through each pixel locations
        
        pixelx = max(2) - pixelxy(i,1); % image is flipped
        if pixelx == 0; % image size does not go lower than 1 
            pixelx = 1;
        end
        pixely = pixelxy(i,2);
        
        XYZ(i,1) = xyzPoints(pixely, pixelx, 1);    % note that point cloud
        XYZ(i,2) = xyzPoints(pixely, pixelx, 2);    % is of the form Y,X,Z
        XYZ(i,3) = xyzPoints(pixely, pixelx, 3);    % so pixely is first
    end
    
end

