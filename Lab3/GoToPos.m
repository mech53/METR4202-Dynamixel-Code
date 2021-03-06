function [ H ] = GoToPos( A )
%% This function finds the angles that ELBOW1 and ELBOW2 need to be at to
%%reach point A.

%% Finds the angles needed for the motor to move to the A position.

%There is a conflit between the dynamixel library and the rvctools library,
%this readds the rvctools library for use, while it is removed at the end
%of this function.
spencer_run = 'C:\Users\Spencer\Documents\Lab3GitHub\METR4202-Dynamixel-Code\Lab3\rvctools\startup_rvc.m';
dylan_run = 'C:\Users\Dylan\Documents\MATLAB\Github\METR4202-Dynamixel-Code\Lab3\rvctools\startup_rvc';
run(spencer_run);
L1 = Link('d', 0, 'a', 15, 'alpha', 0);
L2 = Link('d', 0, 'a', 12, 'alpha', 0);
bot = SerialLink([L1 L2], 'name', 'peter2')

M=[1 1 0 0 0 0];
q1=[(85)*(pi/180) (+80)*(pi/180)];%Q IS THE ORIGIN MATRIX
q2=[(85)*(pi/180) (-80)*(pi/180)];

if A(2)>=0
    q=q1
else
    q=q2
end

T1 = transl(5, 15, 0);  % define the start point
T2 = transl(A(2), A(1), 0);	% and destination
T = ctraj(T1, T2, 2); % compute a Cartesian path
p1 = bot.ikine(T,q,M); 

% bot.plot(p1)
 
H=p1.*(180/(pi))
spencer = 'C:\Users\Spencer\Documents\Lab3GitHub\METR4202-Dynamixel-Code\Lab3\rvctools\robot';
dylan = 'C:\Users\Dylan\Documents\MATLAB\Github\METR4202-Dynamixel-Code\Lab3\rvctools\robot';
warning('off', 'MATLAB:rmpath:DirNotFound')
rmpath(spencer);

% Once this function finishes a new command will be sent to the motor, to 
% stop this from happening while the motor is already moving this section 
% waits for the motors to all be still.

end
