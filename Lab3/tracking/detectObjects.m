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