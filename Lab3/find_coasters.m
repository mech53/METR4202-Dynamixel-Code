function [x, y] = find_coasters(marker, image)
%% SIFT the marker
load(marker);

Iaorig = rgb2gray(marker(:,end:-1:1,:));
Ia = imresize(Iaorig, 0.2);
Ia = single(Ia);
[fa, da] = vl_sift(Ia);

%% SIFT the image to check
load(image);

Iborig = rgb2gray(image(:, end:-1:1,:));
Ib = imresize(Iborig, 0.2);
Ib = single(Ib);
[fb, db] = vl_sift(Ib);

%% Get the matches

[matches, scores] = vl_ubcmatch(da, db, 3);

[x, y] = visualise_sift_matches(imresize(Iaorig, 0.2), ...
    imresize(Iborig, 0.2), fa, fb, matches);
end
