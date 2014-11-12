function cup_tracking()



% Create a video file reader.
Videoclr = videoinput('kinect',1);
preview(Videoclr)

% Create two video players, one to display the video,
% and one to display the foreground mask.
videoFrame = getsnapshot(Videoclr);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track

runLoop = true;


% Detect moving objects, and track them across video frames.
while runLoop
    tic
    frame = readFrame(Videoclr);
    [centroids, bboxes] = detectObjects(frame);
    predictNewLocationsOfTracks(tracks);
    if ~isempty(centroids)
        [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment();
    
        updateAssignedTracks();
        updateUnassignedTracks();
        deleteLostTracks();
        createNewTracks();
    end

    displayTrackingResults();
    runLoop = isOpen(videoPlayer);
    toc
end


stoppreview(Videoclr); closepreview
release(videoPlayer);


end
