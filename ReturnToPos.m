function [ H ] = Untitled2( A )
L1 = Link('d', 0, 'a', 15, 'alpha', 0);
L2 = Link('d', 0, 'a', 12.3, 'alpha', 0);
bot = SerialLink([L1 L2], 'name', 'peter2')

M=[1 1 0 0 0 0];
q1=[(85)*(pi/180) (+80)*(pi/180)];%Q IS THE ORIGIN MATRIX
q2=[(85)*(pi/180) (-80)*(pi/180)];

if A(1)>=0
    q=q2
else
    q=q1
end

T3 = transl(A(1), A(2), 0);  % define the start point
T4 = transl(0, 15, 0);	% and destination
T = ctraj(T3, T4, 8); % compute a Cartesian path
p2 = bot.ikine(T,q,M); 

bot.plot(p2)

H=p2.*(180/(2*pi))

end
