function test_timetout
move_dynamixel_angles(2, 0)
n = 0;
while 1
    move_dynamixel_angles(2, -15)
    pause(0.7)
    n = n + 1;
    disp(n);
    move_dynamixel_angles(2, 15)
    pause(0.7)
end

end