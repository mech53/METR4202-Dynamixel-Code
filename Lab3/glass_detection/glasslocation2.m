function glasslocation2(detector,image)

    close all

    bbox = step(detector, image);   % search for a glass in the image
    disp(bbox)
    detectedImg = insertObjectAnnotation(image, 'rectangle', bbox, 'glass');
    figure; imshow(detectedImg);
    s = size(bbox);
    k = 0;
    if ~isempty(bbox)   % checks to see if it found a glass
        for i = 1:s(1)  % iterate through each... there should only be 1
            k = k + 1;  % need a counter that only increases based on the 
                        % following logic
            if bbox(k,3) > 45 || bbox(k,3) < 25
                bbox(k,:) = []; % probably not a glass so remove it
                k = k - 1;  % decrease the counter so the index accounts 
                            % for removing a row
            elseif bbox(k,4) > 45
                bbox(k,:) = []; % probably not a glass so remove it
                k = k - 1;  % decrease the counter
            end   
        end
    end
    disp(bbox)
    detectedImg = insertObjectAnnotation(image, 'rectangle', bbox, 'glass');
    figure; imshow(detectedImg);

end 