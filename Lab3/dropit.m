function dropit(id)
%Centre angle of the base motor
move_dynamixel_direct(id, 0);
pause(0.5);
move_dynamixel_direct(id, 600);
pause(0.5)
move_dynamixel_direct(id, 200);
pause(0.5);
move_dynamixel_direct(id, 600);

pause(1);
move_dynamixel_direct(id, 2500);    
end