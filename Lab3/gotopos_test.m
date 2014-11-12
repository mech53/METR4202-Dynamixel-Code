function gotopos_test

move_dynamixel_steps(GoToPos([0, 10]))
move_dynamixel_steps(ReturnToPos([0, 10]))
move_dynamixel_steps(GoToPos([0, 15]))
move_dynamixel_steps(ReturnToPos([0, 15]))

end