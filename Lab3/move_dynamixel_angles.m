function move_dynamixel_angles(id, theta)
%   Centre angle of the base motor
id_3_base = 150;

%   Centre angle of the arm motor
id_2_base = 150;

%   Change theta to the relative angle
if id == 2
    theta = id_2_base + theta;
elseif id == 3
    theta = id_3_base + theta;
end

m = 1023/300;   %   bits per degree

move_dynamixel_direct(id, m*theta);

end