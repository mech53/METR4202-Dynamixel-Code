function gotopos_test

move_dynamixel_steps(GoToPos([-19, 10]))
disp('Pls drop')
pause(5)
move_dynamixel_steps(GoToPos([15, 17]))
dropit(4)
dropit(4)
dropit(4)
move_dynamixel_steps(GoToPos([-10, 20]))
disp('Pls drop')
pause(5)
move_dynamixel_steps(GoToPos([15, 17]))
dropit(4)

end