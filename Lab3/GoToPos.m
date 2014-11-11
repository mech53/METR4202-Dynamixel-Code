function [ H ] = Untitled2( A )
L1 = Link('d', 0, 'a', 15, 'alpha', 0);
L2 = Link('d', 0, 'a', 11.5, 'alpha', 0);
bot = SerialLink([L1 L2], 'name', 'peter2')

M=[1 1 0 0 0 0];
q1=[(85)*(pi/180) (+80)*(pi/180)];%Q IS THE ORIGIN MATRIX
q2=[(85)*(pi/180) (-80)*(pi/180)];

if A(2)>=0
    q=q1
else
    q=q2
end

T1 = transl(0, 15, 0);  % define the start point
T2 = transl(A(2), A(1), 0);	% and destination
T = ctraj(T1, T2, 2); % compute a Cartesian path
p1 = bot.ikine(T,q,M); 

% bot.plot(p1)
 
H=p1.*(180/(pi))

end

