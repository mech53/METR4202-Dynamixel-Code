%Controller Algorithm for Metr4202 Prac3
closepreview
clear

state = 0;

order = [3, [2, 2, 0, 0, 0, 0], [2, 0, 1, 1, 0, 0], [2, 1, 0, 0, 0, 1]];

%  [1, 1, 0, 0, 0, 0], [1, 1, 0, 2, 0, 0]
n = order(1);

sortedOrder = [1 order(2:7)];
sortedOrder = [sortedOrder; 2 order(8:13)];

if n >= 3
    sortedOrder = [sortedOrder; 3 order(14:19)];
end

if n >= 4
    sortedOrder = [sortedOrder; 4 order(20:25)];
end

if n >= 5
    sortedOrder = [sortedOrder; 5 order(26:31)];    
end

sortedOrder = sortrows(sortedOrder,-7);


PISTON = 1;
ELBOW1 = 2;
ELBOW2 = 3;
VCUP = 4;




%
%% Model Creation
%CLEAR
clf
close all
state = 1; %model is created

%% Cup Tracking Setup

% move arm out of the way
set_motor_torques
move_dynamixel_angles(2, 0);
move_dynamixel_angles(3,80);
pause(5)

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
% find cups for a few cycles
for cup_I = 1:10
   
    [nextId,everything] = multiObjectTracking_HC_new(Videoclr,videoPlayer,tracks,nextId);
    
end


%% Fiducial Setup
%   Take an image and save it as snapshot.mat file
save('snapshot.mat','image')

%   Get the x and y coordinates of each fiducial
[x_sug, y_sug] = find_coasters('sugar_marker.mat', 'snapshot.mat')
[x_tea, y_tea] = find_coasters('tea_marker.mat', 'snapshot.mat')
[x_cof, y_cof] = find_coasters('coffee_marker.mat', 'snapshot.mat')
% 
% x_sug = 640 - x_sug;
% x_tea = 640 - x_tea;
% x_cof = 640 - x_cof;
if isnan(x_sug)
    XY_sug = [0 15];
else
    XY_sug = metric(xyzPoints,[x_sug, y_sug])
end

if isnan(x_cof)
   XY_cof = [0 15];
else
    XY_cof = metric(xyzPoints,[x_cof, y_cof])
end

if isnan(x_tea)
    XY_tea = [0 15];
else
    XY_tea = metric(xyzPoints,[x_tea, y_tea])
end

XY_cof = [18, 15];
XY_sug = [-16, 14];
XY_tea = [-16, 8];
pause(10)

%% Glass Setup
disp('Please place the glass... :)')

detector = vision.CascadeObjectDetector('glass5.xml');
% find the glass in the image

%xy_glass = glasslocation3(detector,videoFrame);


%XY_glass = metric(xyzPoints,xy_glass);
XY_glass = [-5,10];
%% Switch Statement for Control

calllib('dynamixel', 'dxl_write_word', 4, 30, 3000);

for i = 1:n
    while (1)
    switch state
        case 1
            %Find next cup to complete
            cup = sortedOrder(i,:);
            
            state = 2;
            clc
            disp('state 1')
        case 2
            %Select condiment
            if cup(3) > 0 %Does the cup need more coffee?
                condimentFlag = 1;
                cup(3) = cup(3) - 1; %Reduce the number of needed coffees by 1

            elseif cup(4) > 0 %Does the cup need more tea?
                condimentFlag = 2;
                cup(4) = cup(4) - 1; %Reduce the number of needed teas by 1

            elseif cup(5) > 0 %Does the cup need more sugar?
                condimentFlag = 3;
                cup(5) = cup(5) - 1; %Reduce the number of needed sugars by 1

            else
                condimentFlag = 0;
            end

            state = 3;
            clc
            disp('state 2')
        case 3
            %Collect condiment
            switch condimentFlag
                case 0
                    %No condiments required
                    disp('No condiments required!')
                    
                case 1
                    %Go to Coffee
                    XY_cof
                    move_dynamixel_steps(GoToPos(XY_cof)); 
                    %GoToPos returns the angles needed for move_dynamixel_steps 
                    
                    disp('Please drop coffee!')
                    pause(3)
                    condimentFlag = 0;
                case 2
                    %Go to Tea
                    move_dynamixel_steps(GoToPos(XY_tea));
                    %GoToPos returns the angles needed for move_dynamixel_steps
                    
                    disp('Please drop tea!')
                    pause(3)
                    condimentFlag = 0;
                    
                case 3
                    %Go to Sugar
                    move_dynamixel_steps(GoToPos([XY_sug]));
                    
                    disp('Please drop sugar!')
                    pause(3)
                    %GoToPos returns the angles needed for move_dynamixel_steps
                    
                    condimentFlag = 0;
            end
            state = 4;
            clc
            disp('state 3')
        case 4
            %%  Finding cups function, also ignores used cups
            [nextId,everything] = multiObjectTracking_HC_new(Videoclr,videoPlayer,tracks,nextId);
            disp(everything)
            HH = everything(:,1:2);
            disp(HH)
            selectedCups_XY = zeros(size(everything));
            selectedCups_XY(:,1:2) = metric(xyzPoints,HH);
            selectedCups_XY(:,3:4) = everything(:,3:4);
            
            SCS = size(selectedCups_XY);
            cupNumber = 0;
            for place = 1:i
                if sortedOrder(place,2) == cup(2)
                    cupNumber = cupNumber + 1;
                end
            end
                 
           
                for SCI = 1:SCS(1)
                    if (selectedCups_XY(SCI,3) == cup(2)) && (selectedCups_XY(SCI,4) == cupNumber)
                       cupNumber
                       currentCup_XY = selectedCups_XY(SCI,1:2);
                       
                       
                       if currentCup_XY(1) > 24
                           currentCup_XY(1) = 23;
                       end
                       if currentCup_XY(1) < -24
                           currentCup_XY(1) = -23;
                       end
                       if currentCup_XY(2) > 23
                           currentCup_XY(2) = 22;
                       end
                       if currentCup_XY(2) < 2
                           currentCup_XY(2) = 3;
                       end
                       
                       
                        break
                    end
                end
            
            clc
            disp('state 4')
            state = 5;
        case 5
            %Move arm to cup, and drop condiment in cup
            currentCup_XY            
            move_dynamixel_steps(GoToPos(currentCup_XY));
            pause(4)
            %   Drop the condiment in the cup
            dropit(4);
            
            if cup(3)+cup(4)+cup(5) == 0
                state = 6;
            else
                state = 2;
            end
            
            clc
            disp('state 5')
            
        case 6
            %Declare Cup Finished
            %load gong.mat
            %sound(y, Fs)
            declare = strcat('Drink_' , int2str(cup(1)), ' is completed.')
            disp(declare)
            
            clc
            disp('state 5')
            state = 1;
            break
    end
    end
end

load gong.mat
sound(y, Fs)
disp('Any more requests?')
