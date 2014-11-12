function gotopos_test

move_dynamixel_steps(GoToPos([10, 5]))
move_dynamixel_steps(GoToPos([-10, 15]))
dropit(4)

end