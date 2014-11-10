load('Snapshot2.mat')
% gray scale it
imggray=single(rgb2gray(I(:,end:-1:1,:)));
%maxD=median(unique(D(:)));
%imggray=single( (D(:,end:-1:1) * (256/maxD)) );


%% sift the image
[siftf,siftd] = vl_sift(imggray);

% Select 50 features randomly (that's all the randperm is doing)
perm = randperm(size(siftf,2)) ; 
sel = perm(1:50) ;

figure(1);
imshow(uint8(imggray)); hold on;
% Use the VLFeat function to plot the features
% What it plots is the feature direction and magnitude
h1 = vl_plotframe(siftf(:,sel)) ; 
h2 = vl_plotframe(siftf(:,sel)) ;
% Colour it yellow
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off;


%% sift the can
% Here we do a sift on only the cans. Any SIFT features that we find in
% these images are specific to that can.
% For the tutorial, you should make a database of features of a can from
% multiple angles.

% Comment out some of the following lines to select the one of interest
%GERMAN CAN:
imcan=single(imggray(185:265,295:340));
%AUS CAN:
imcan=single(imggray(260:352,353:390));
%Sprite Can:
%imcan=single(imggray(266:370,295:351));
 
% sift the image
[siftfcan,siftdcan] = vl_sift(imcan);

% Same as the last section
perm = randperm(size(siftfcan,2)) ; 
sel = perm(1:min([size(siftfcan,2) 50])) ;
figure(2);
image(imcan); colormap(gray); hold on;
h1 = vl_plotframe(siftfcan(:,sel)) ; 
h2 = vl_plotframe(siftfcan(:,sel)) ; 
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off;

%% Now we find matches of the can SIFT and the full image SIFT
[matches, scores] = vl_ubcmatch(siftdcan, siftd) ;

% Plot some of these matches
sel = matches(2,:);
figure(3);
imshow(uint8(imggray)); hold on;
h1 = vl_plotframe(siftf(:,sel)) ; 
h2 = vl_plotframe(siftf(:,sel)) ; 
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off;


%% Now for broke...
% Breaks because the can is rotated so that different features are
% available.
Ieasy=I;
Deasy=D;
load('Snapshot3.mat');
Ihard=I;
Dhard=D;
I=Ieasy; D=Deasy;

imggrayhard=single(rgb2gray(Ihard(:,end:-1:1,:)));

%% sift the image
[siftfhard,siftdhard] = vl_sift(imggrayhard);

perm = randperm(size(siftfhard,2)) ; 
sel = perm(1:min([size(siftdhard,2) 50]));
figure(4);
imshow(uint8(imggrayhard)); hold on;
h1 = vl_plotframe(siftfhard(:,sel)) ; 
h2 = vl_plotframe(siftfhard(:,sel)) ; 
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off;

%% Display the matched features

[matches, scores] = vl_ubcmatch(siftdcan, siftdhard);

sel = matches(2,:);
figure(5);
imshow(uint8(imggrayhard)); hold on;
h1 = vl_plotframe(siftfhard(:,sel)) ; 
h2 = vl_plotframe(siftfhard(:,sel)) ; 
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off;

% Fail!


%% Now try case 4
load('Snapshot4.mat');
I4=rgb; D4=depth;

imggray4=single(rgb2gray(I4(:,end:-1:1,:)));

% sift the image
[siftf4,siftd4] = vl_sift(imggray4);

perm = randperm(size(siftf4,2)) ; 
sel = perm(1:min([size(siftf4,2) 50]));
figure(6);
imshow(uint8(imggray4)); hold on;
h1 = vl_plotframe(siftf4(:,sel)) ; 
h2 = vl_plotframe(siftf4(:,sel)) ; 
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off;

%% Plot the matched features
[matches, scores] = vl_ubcmatch(siftdcan, siftd4);

sel = matches(2,:);
figure(7);
imshow(uint8(imggray4)); hold on;
h1 = vl_plotframe(siftf4(:,sel)) ; 
h2 = vl_plotframe(siftf4(:,sel)) ; 
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
hold off;

% FAIL!!

% Surya:
% Try it the other way ... use snapshot 3 to train and find in 4
% won't work ... different poses....
% Seriously SIFT is cool if I only gave it a half a chance.















