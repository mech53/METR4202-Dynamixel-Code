function [nextId,everything] = multiObjectTracking_HC_new(Vidclr,VidPlayer,trks,Nid)

% Create the colour video object
Videoclr = Vidclr;

% Create the video player object.
videoPlayer = VidPlayer;
% Create an empty array of tracks.
tracks = trks;

% ID of the next track
nextId = Nid;

% we run the loop while the video player is open, initialy true
%runLoop = true;

% Detect moving objects, and track them across video frames.

        
    tic
    
    % read in a frame from the video player
    frame = readFrame(Videoclr);
    
    % detects cups in the frame
    [centroids, bboxes] = detectObjects(frame);
    
    % predict the new cup location
    predictNewLocationsOfTracks();
    
    % if cups have been found update the tracks
    if ~isempty(centroids)
        [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment();
    
        updateAssignedTracks();
        updateUnassignedTracks();
        deleteLostTracks();
        createNewTracks();
    end
    % dispaly the updated tracks in the video player
    displayTrackingResults();
    

    disp(bboxes(:,1:2))
    
    Radiis = bboxes(:,3)./2;
                

        large_counter = 0;
        medium_counter = 0;

        everything = zeros(length(Radiis),4);

        for inde = 1:length(Radiis)

            everything(inde,1:2) = bboxes(inde,1:2);

            if Radiis(inde) > 26
                large_counter = large_counter + 1;
                %name(ind) = cellstr(strcat('large',int2str(large_counter)));
                everything(inde,3) = 2;
                everything(inde,4) = large_counter;
            else
                medium_counter = medium_counter + 1;
                %name(ind) = cellstr(strcat('medium',int2str(medium_counter)));
                everything(inde,3) = 1;
                everything(inde,4) = medium_counter;
            end
        end
    
    %disp(everything)
    
    % check that the videoplayer is still open
    %runLoop = isOpen(videoPlayer);
    toc


    function frame = readFrame(video_object)
        % gets the current frame from the video object
        frame = getsnapshot(video_object);
    end

    function [centroids, bboxes] = detectObjects(frame)
        % finds cirlces in an image given a rand of radii
        
        % slightly blur the image to make shadows ect. be less identifiable
        K = fspecial('gaussian');
        Igf = imfilter(frame, K);
        
        % set the desired radii (in pixels)
        min_radius = 20;
        max_radius = 40;
        
        % search the image
        [centroids,radii,metrics]=imfindcircles(Igf,[min_radius, max_radius],'sensitivity',0.9);

        % turns the centroids into a box for display
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

    end

    function predictNewLocationsOfTracks()
        % predicts the location of centroids using a kalman filter
            
        for i = 1:length(tracks)
            bbox = tracks(i).bbox;

            % Predict the current location of the track.
            predictedCentroid = predict(tracks(i).kalmanFilter);
            
            % Shift the bounding box so that its center is at
            % the predicted location.
            predictedCentroid = predictedCentroid - bbox(3:4) / 2;
            
            % update tracks
            tracks(i).bbox = [predictedCentroid, bbox(3:4)];
        end
    end


    function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment()

        nTracks = length(tracks);
        nDetections = size(centroids, 1);
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
        % updates the assigned tracks
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
        % updates the unassigned tracks
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).age = tracks(ind).age + 1;
            tracks(ind).consecutiveInvisibleCount = ...
                tracks(ind).consecutiveInvisibleCount + 1;
        end
    end

    function deleteLostTracks()
        if isempty(tracks)
            % if no tracks have been found do nothing
            return;
        end
        
        % set thresholds to determine if a track needs deletion
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
        % Convert the frame to uint8 RGB.
        frame = im2uint8(frame);

        minVisibleCount = 8;
        if ~isempty(tracks)

            % False detections tend to result in short-lived tracks.
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

                %Radiis = bboxes(:,3)./2;
                

                %large_counter = 0;
                %medium_counter = 0;
                
                %everything = zeros(length(Radiis),4);
                %{
                for ind = 1:length(Radiis)
                    
                    everything(ind,1:2) = bboxes(ind,1:2);
                    
                    if Radiis(ind) > 26
                        large_counter = large_counter + 1;
                        %name(ind) = cellstr(strcat('large',int2str(large_counter)));
                        everything(ind,3) = 2;
                        everything(ind,4) = large_counter;
                    else
                        medium_counter = medium_counter + 1;
                        %name(ind) = cellstr(strcat('medium',int2str(medium_counter)));
                        everything(ind,3) = 1;
                        everything(ind,4) = medium_counter;
                    end
                end
                %}
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                %labels = strcat(labels,name');
                labels = strcat(labels, isPredicted);
                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);
            
                
            end
        end

        % Display the mask and the frame.
        step(videoPlayer, frame);
        %cents(:,2) = bboxes(:,1:2);
        %cents(:,3) = names;
        
        % note to self the point here was to make a returnable (thats a
        % word now) item that had the xy loactions and the name, will need
        % to be a struct because names are strings... or change names to a
        % number some how
    end


end