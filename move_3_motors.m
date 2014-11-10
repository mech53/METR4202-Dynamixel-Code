function move_3_motors(id1, theta1, id2, theta2, id3, theta3)
%   move_3_motors(id1, theta1, id2, theta2, id3, theta3)
%   Takes angles and moves the motors to those absolute positions.

id = [id1, id2, id3];
w = [theta1, theta2, theta3];

%   Convert angles to positions
m = 1023/300;   %   bits per degree

for i = 1:3;
    move_dynamixel_direct(id(i), m*w(i));
end

end
