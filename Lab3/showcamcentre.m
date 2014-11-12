function A = showcamcentre()

Videoclr = videoinput('kinect',2);
preview(Videoclr)

videoFrame = getsnapshot(Videoclr);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);



runLoop = true;


    % Detect moving objects, and track them across video frames.
    while runLoop
        frame = getsnapshot(Videoclr);
        frame = decorrstretch(frame,'Tol',0.01); % only for the depth map
        
        centre = [320,240,3];
        
        frame = insertObjectAnnotation(frame, 'circle', centre,'centre');
        
        step(videoPlayer, frame);
        runLoop = isOpen(videoPlayer);
    end
    A = frame;
    stoppreview(Videoclr); closepreview
    release(videoPlayer);


end