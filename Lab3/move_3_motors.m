function [theta1, theta2, theta3] = move_3_motors(id1, theta1, id2, ...
    theta2, id3, theta3)

move_dynamixel_angles(id1, theta1);
move_dynamixel_angles(id2, theta2);
move_dynamixel_angles(id3, theta3);

end