function dropit(id)
%Centre angle of the base motor
for i = 1:2
calllib('dynamixel', 'dxl_write_word', id, 30, 0);
% while(calllib('dynamixel', 'dxl_read_word', 4, 46)>0);
pause(0.25)
% end
calllib('dynamixel', 'dxl_write_word', id, 30, 3000);
% while(calllib('dynamixel', 'dxl_read_word', 4, 46)>0);
pause(0.25)
% end
calllib('dynamixel', 'dxl_write_word', id, 30, 0);
% while(calllib('dynamixel', 'dxl_read_word', 4, 46)>0);
pause(0.25)
% end
calllib('dynamixel', 'dxl_write_word', id, 30, 3000);

end

end