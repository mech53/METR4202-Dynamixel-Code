% glass finder training %

negativeFolder = fullfile(matlabroot, 'toolbox', 'nope');
trainCascadeObjectDetector('glass4.xml', positiveInstances, negativeFolder, 'FalseAlarmRate', 0.01, 'NumCascadeStages', 8);
detector = vision.CascadeObjectDetector('glass4.xml');
img = imread('glass45');
bbox = step(detector, img);
disp(bbox)
detectedImg = insertObjectAnnotation(img, 'rectangle', bbox, 'glass');
figure; imshow(detectedImg);
