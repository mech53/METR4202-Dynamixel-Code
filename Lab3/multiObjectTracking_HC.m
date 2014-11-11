function multiObjectTracking_HC()



% Create a video file reader.
Videoclr = videoinput('kinect',1);
preview(Videoclr)

% Create two video players, one to display the video,
% and one to display the foreground mask.
videoFrame = getsnapshot(Videoclr);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

% Create System objects for foreground detection and blob analysis

detector = vision.CascadeObjectDetector('smallcupDetectoraxon2.xml');

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track

runLoop = true;


% Detect moving objects, and track them across video frames.
while runLoop
    tic
    frame = readFrame(Videoclr);
    [centroids, bboxes] = detectObjects(frame);
    predictNewLocationsOfTracks();
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
release(detector);

    function tracks = initializeTracks()
        % create an empty array of tracks
        tracks = struct(...
            'id', {}, ...
            'bbox', {}, ...
            'kalmanFilter', {}, ...
            'age', {}, ...
            'totalVisibleCount', {}, ...
            'consecutiveInvisibleCount', {});
    end

    function frame = readFrame(video_object)
        frame = getsnapshot(video_object);
    end

    function [centroids, bboxes] = detectObjects(frame)
        
        
        K = fspecial('gaussian');
        Igf = imfilter(frame, K);

        min_radius = 10;
        max_radius = 50;

        [centroids,radii,metric]=imfindcircles(Igf,[min_radius, max_radius]);
        s = size(centroids);
        bboxes = zeros(s(1),4);
        for i = 1:s(1)
            left = centroids(i,1) - radii(i);
            if left < 1
                left = 1;
            end 
            top = centroids(i,2) - radii(i);
            if top < 1
                top = 1;
            end

            diameter = 2*radii(i);

            bboxes(i,1) = left;
            bboxes(i,2) = top;
            bboxes(i,3) = diameter;
            bboxes(i,4) = diameter;

        end
        
        
        %[centroids, bboxes] = findcircles(frame);
        % Detect foreground.
        %{
        bboxes = detector.step(frame);
        s = size(bboxes);
        centroids = [];
        for i = 1:s(1)
            cx = bboxes(i,1) - bboxes(i,3)/2;
            cy = bboxes(i,2) - bboxes(i,4)/2;
            centroids = [centroids;cx,cy];
        end
        %}


    end

    function predictNewLocationsOfTracks()
        for i = 1:length(tracks)
            bbox = tracks(i).bbox;

            % Predict the current location of the track.
            predictedCentroid = predict(tracks(i).kalmanFilter);
            
            % Shift the bounding box so that its center is at
            % the predicted location.
            predictedCentroid = predictedCentroid - bbox(3:4) / 2;
            tracks(i).bbox = [predictedCentroid, bbox(3:4)];
        end
    end


    function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment()

        nTracks = length(tracks);
        nDetections = size(centroids, 1);
        disp(size(centroids))
        disp(centroids(1,:))
        % Compute the cost of assigning each detection to each track.
        cost = zeros(nTracks, nDetections);
        for i = 1:nTracks
            cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
        end

        % Solve the assignment problem.
        costOfNonAssignment = 20;
        [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks(cost, costOfNonAssignment);
    end

    function updateAssignedTracks()
        numAssignedTracks = size(assignments, 1);
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);

            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).kalmanFilter, centroid);

            % Replace predicted bounding box with detected
            % bounding box.
            tracks(trackIdx).bbox = bbox;

            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;

            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
        end
    end

    function updateUnassignedTracks()
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).age = tracks(ind).age + 1;
            tracks(ind).consecutiveInvisibleCount = ...
                tracks(ind).consecutiveInvisibleCount + 1;
        end
    end

    function deleteLostTracks()
        if isempty(tracks)
            return;
        end

        invisibleForTooLong = 15;
        ageThreshold = 8;

        % Compute the fraction of the track's age for which it was visible.
        ages = [tracks(:).age];
        totalVisibleCounts = [tracks(:).totalVisibleCount];
        visibility = totalVisibleCounts ./ ages;

        % Find the indices of 'lost' tracks.
        lostInds = (ages < ageThreshold & visibility < 0.6) | ...
            [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;

        % Delete lost tracks.
        tracks = tracks(~lostInds);
    end

    function createNewTracks()
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);

        for i = 1:size(centroids, 1)

            centroid = centroids(i,:);
            bbox = bboxes(i, :);

            % Create a Kalman filter object.
            kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
                centroid, [200, 50], [100, 25], 100);

            % Create a new track.
            newTrack = struct(...
                'id', nextId, ...
                'bbox', bbox, ...
                'kalmanFilter', kalmanFilter, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'consecutiveInvisibleCount', 0);

            % Add it to the array of tracks.
            tracks(end + 1) = newTrack;

            % Increment the next id.
            nextId = nextId + 1;
        end
    end

    function displayTrackingResults()
        % Convert the frame and the mask to uint8 RGB.
        frame = im2uint8(frame);

        minVisibleCount = 8;
        if ~isempty(tracks)

            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than
            % a minimum number of frames.
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);

            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);

                % Get ids.
                ids = int32([reliableTracks(:).id]);

                % Create labels for objects indicating the ones for
                % which we display the predicted rather than the actual
                % location.
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels, isPredicted);

                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);

            end
        end

        % Display the mask and the frame.
        step(videoPlayer, frame);
    end


end