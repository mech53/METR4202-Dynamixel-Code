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


%%%%FORWARD KINEMATICS
%%ENTER THREE ROTATIONS IN RADIANS 
%IT RETURNS FULL ROTATION MATRIX
%j=bot.fkine([(112)*(pi/180) (29)*(pi/180) 107*(pi/180)])

M=[1 1 0 0 0 0];%MASKING ARRAY USED TO IGNORE OTHER AXIS
%WE ONLY USE 3 AXIS OF FREEDOM

q=[(0)*(pi/180) (0)*(pi/180)];%Q IS THE ORIGIN MATRIX

%%%%INVERSE KINEMATICS
%%ENTER FULL ROTATION MATRIX
%IT RETURNS THREE ROTATIONS IN RADIANS
%JOINT A, JOINT B AND JOINT C
%j=[1 0 0 5; 0 1 0 -5; 0 0 1 3; 0 0 0 1];

%k=bot.ikine(j,q,M,'ru')
%bot.plot(k)
%k=k.*(180/pi)
%bot.plot([(-75)*(pi/180) (-83)*(pi/180) 0])

 
%%%%%%
% Inverse kinematics may also be computed for a trajectory.
% If we take a Cartesian straight line path between two poses in 50 steps

T1 = transl(3, 1, 0);  % define the start point
T2 = transl(6, 9, 0);	% and destination
T = ctraj(T1, T2, 5); % compute a Cartesian path
q = bot.ikine(T,q,M,'pinv'); 
clf
bot.plot(q)