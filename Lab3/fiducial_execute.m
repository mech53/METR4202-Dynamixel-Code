function fiducial_execute
% set up colour and depth objects
Videoclr = videoinput('kinect',1);
VidClrHD = videoinput('kinect',1,'RGB_1280x960');
depthSysObj = imaq.VideoDevice('kinect',2);
depthSysObj.ReturnedDataType = 'uint16';

image = getsnapshot(VidClrHD);
figure; imshow(image)
% open a preview of the video object, this speeds up image capture
preview(Videoclr)

% set up a video player to display tracked objects
videoFrame = getsnapshot(Videoclr);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

% Create an empty array of tracks.
tracks = initializeTracks();

% ID of the next track
nextId = 1;

pause(0.5)

depthImage = step(depthSysObj);

%Convert the depth image to the point cloud.
xyzPoints = depthToPointCloud(depthImage, depthSysObj);

release(depthSysObj)


%   Take an image and save it as snapshot.mat file
image = videoFrame;
save('snapshot.mat','image')


[x_sug, y_sug] = find_coasters('sugar_marker.mat', 'snapshot.mat')
[x_tea, y_tea] = find_coasters('tea_marker.mat', 'snapshot.mat')
[x_cof, y_cof] = find_coasters('coffee_marker.mat', 'snapshot.mat')

if isnan(x_sug)
    XY_sug = [10, 8]
else
    XY_sug = metric(xyzPoints,[x_sug, y_sug])
end

if isnan(x_tea)
    XY_tea = [0, 15]
else
    XY_tea = metric(xyzPoints,[x_tea, y_tea])
end

if isnan(x_cof)
    XY_cof = [-10 8]
else
    XY_cof = metric(xyzPoints,[x_cof, y_cof])
end

move_dynamixel_steps(GoToPos(XY_sug));
pause(3)
move_dynamixel_steps(GoToPos(XY_cof));
pause(3)
move_dynamixel_steps(GoToPos(XY_tea));
pause(3)

dropit(4)


end