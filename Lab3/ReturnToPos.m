function [ H ] = Untitled2( A )
%% This function finds the angles that ELBOW1 and ELBOW2 need to be at to
%%return to the 'calibration point' from point A.

spencer_run = 'C:\Users\Spencer\Documents\Lab3GitHub\METR4202-Dynamixel-Code\Lab3\rvctools\startup_rvc.m';
dylan_run = 'C:\Users\Dylan\Dropbox\4202_group1\Lab3\Lab3\rvctools\startup_rvc.m';
run(dylan_run);

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
spencer = 'C:\Users\Spencer\Documents\Lab3GitHub\METR4202-Dynamixel-Code\Lab3\rvctools\robot';
dylan = 'C:\Users\Dylan\Dropbox\4202_group1\Lab3\Lab3\rvctools\robot';
warning('off', 'MATLAB:rmpath:DirNotFound')
rmpath(dylan);

end

