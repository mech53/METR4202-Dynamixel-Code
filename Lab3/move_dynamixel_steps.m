function move_dynamixel_steps(vector)

number_of_steps = size(vector);

for i=1:number_of_steps(1)
    move_dynamixel_angles(3, vector(i, 1));
    move_dynamixel_angles(2, vector(i, 2));
end

% pause(1);

end