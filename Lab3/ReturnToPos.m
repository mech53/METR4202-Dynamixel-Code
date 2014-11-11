function [ H ] = Untitled2( A )
%% This function finds the angles that ELBOW1 and ELBOW2 need to be at to
%%return to the 'calibration point' from point A.

L1 = Link('d', 0, 'a', 15, 'alpha', 0);
L2 = Link('d', 0, 'a', 11.5, 'alpha', 0);
bot = SerialLink([L1 L2], 'name', 'peter2')

M=[1 1 0 0 0 0];
q1=[(85)*(pi/180) (+80)*(pi/180)];%Q IS THE ORIGIN MATRIX
q2=[(85)*(pi/180) (-80)*(pi/180)];

if A(2)>=0
    q=q2
else
    q=q1
end

T3 = transl(A(2), A(1), 0);  % define the start point
T4 = transl(15, 0, 0);	% and destination
T = ctraj(T3, T4, 2); % compute a Cartesian path
p2 = bot.ikine(T,q,M); 


H=p2.*(180/(pi))

%% Once this function finishes a new command will be sent to the motor, to 
%%stop this from happening while the motor is already moving this section 
%%waits for the motors to all be still.

speeds = 256;

while(speeds>0) 
    calllib('dynamixel', 'dxl_read_word', 1, 46);
    speeds = (calllib('dynamixel', 'dxl_read_word', 1, 46)+calllib('dynamixel', 'dxl_read_word', 2, 46)+ ...
        calllib('dynamixel', 'dxl_read_word', 3, 46)+calllib('dynamixel', 'dxl_read_word', 4, 46));
end


end

