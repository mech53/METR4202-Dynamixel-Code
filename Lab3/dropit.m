function dropit(id)
%Centre angle of the base motor
calllib('dynamixel', 'dxl_write_word', id, 30, 0);
while(calllib('dynamixel', 'dxl_read_word', 4, 46)>0);
pause(0.1)
end
calllib('dynamixel', 'dxl_write_word', id, 30, 3000);
while(calllib('dynamixel', 'dxl_read_word', 4, 46)>0);
pause(0.1)
end
calllib('dynamixel', 'dxl_write_word', id, 30, 0);
while(calllib('dynamixel', 'dxl_read_word', 4, 46)>0);
pause(0.1)
end
calllib('dynamixel', 'dxl_write_word', id, 30, 3000);

end