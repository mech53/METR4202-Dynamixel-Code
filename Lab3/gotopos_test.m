function gotopos_test

move_dynamixel_steps(GoToPos([-19, 10]))
move_dynamixel_steps(GoToPos([10, 5]))

dropit(4)

end