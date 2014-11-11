function wiggleit(id)
%Centre angle of the base motor
PresentPos = int32(calllib('dynamixel','dxl_read_word',id, 36));

%Shakes the VCUP motor to ensure the condiment has dropped
move_dynamixel_direct(id, PresentPos+600);
pause(0.5);
move_dynamixel_direct(id, PresentPos-600);
pause(0.5);
move_dynamixel_direct(id, PresentPos);    
end