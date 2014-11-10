%Controller Algorithm for Metr4202 Prac3

state = 0;

order = [3, [1, 1, 0, 3, 0, 0], [2, 0, 2, 0, 0, 1], [1, 2, 0, 1, 0, 0]];

n = order(1);

sortedOrder = [1 order(2:7)];
sortedOrder = [sortedOrder; 2 order(8:13)];

if n => 3
    sortedOrder = [sortedOrder; 3 order(14:19)];
end

if n => 4
    sortedOrder = [sortedOrder; 4 order(20:25)];
end

if n => 5
    sortedOrder = [sortedOrder; 5 order(26:29)];    
end

sortedOrder = sortrows(sortedOrder,-7)


PISTON = 1;
ELBOW1 = 2;
ELBOW2 = 3;
VCUP = 4;




%
%% Model Creation
%CLEAR
clf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        SETUP ROBOT WITH 'LEGO UNITS' AS MEASUREMENT   %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L1 = Link('d', 0, 'a', 10, 'alpha', 0);
L2 = Link('d', 0, 'a', 10, 'alpha', pi/2);
%L3 = Link('d', 0, 'a', 10, 'alpha', 0);
bot = SerialLink([L1 L2], 'name', 'peter2')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

state = 1; %model is created

%%%%FORWARD KINEMATICS
%%ENTER THREE ROTATIONS IN RADIANS 
%IT RETURNS FULL ROTATION MATRIX
%j=bot.fkine([(112)*(pi/180) (29)*(pi/180) 107*(pi/180)])

M=[1 1 0 0 0 0];%MASKING ARRAY USED TO IGNORE OTHER AXIS
%WE ONLY USE 3 AXIS OF FREEDOM

q=[(0)*(pi/180) (0)*(pi/180)];%Q IS THE ORIGIN MATRIX

%% Cup Tracking Setup



%% Fiducial Setup
%   Take an image and save it as snapshot.mat file

%   Get the x and y coordinates of each fiducial
[x_acd, y_acd] = find_coasters('acd_marker.mat', 'snapshot.mat');
[x_sug, y_sug] = find_coasters('sugar_marker.mat', 'snapshot.mat');
[x_tea, y_tea] = find_coasters('tea_marker.mat', 'snapshot.mat');
[x_cof, y_cof] = find_coasters('coffee_marker.mat', 'snapshot.mat');


%% Switch Statement for Control

for i = 1:order(1)
    switch State
        case 1
            %Find next cup to complete
            cup = sortedOrder(i,:)
            
            state = 2;
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
        case 3
            %%  REVISE THIS DYLAN AND ALSO VOSS AND CODY
            %Collect condiment
            switch condimentFlag
                case 0
                    %No condiments required
                    disp('No condiments required')
                    
                case 1
                    %Go to Coffee
                    
                    
                    condimentFlag = 0;
                case 2
                    %Go to Tea
                    
                    
                    condimentFlag = 0;
                case 3
                    %Go to Sugar
                    
                    
                    condimentFlag = 0;
            end
            
            state = 4;
        case 4
            %%  REVISE THIS VOSS AND CODY
            %Locate selected cup
            if selectedCup = 0
                for j = 1:order(1)
                    if visibleCups(j,2) == cup(2)
                        selectedCup = visibleCups(j,:)
                        break
                    end
                end
            end
            
            %Run Cup tracking to get position of selectedCup
            
            state = 5;
        case 5
            %%  REVISE THIS DYLAN
            %Move arm to cup, and drop condiment in cup
            
            clf
            bot.plot(q);
            draw_grid(0);
            T2 = transl(selectedCup(3:5));	% and destination
            k = bot.ikine(T2,k,M);
            bot.animate(k);
            
            move_dynamixel_direct(ELBOW1, 512*k(1)/(pi))
            pause(1);
            move_dynamixel_direct(ELBOW2, 512*k(1)/(pi))
            pause(1);
            
            move_dynamixel_direct(VCUP, 200)
            pause(1);
            move_dynamixel_direct(VCUP, 512)

            if cup(3)+cup(4)+cup(5) = 0
                state = 6;
            else
                state = 2;
            end
            
        case 6
            %Declare Cup Finished
            load gong.mat
            sound(y, Fs)
            declare = ['Drink ',cup(1),'is completed.'];
            disp(declare)
            
            state = 1;
    end
end

load gong.mat
sound(y, Fs)
disp('Any more requests?')

