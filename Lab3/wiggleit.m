function wiggleit(id)
%Centre angle of the base motor
PresentPos = int32(calllib('dynamixel','dxl_read_word',id,P_PRESENT_POSITION));
move_dynamixel_direct(id, PresentPos+10);
pause(0.5);
move_dynamixel_direct(id, PresentPos-10);
pause(0.5);
move_dynamixel_direct(id, PresentPos);
end