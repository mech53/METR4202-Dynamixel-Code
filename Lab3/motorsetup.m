function motorsetup()

calllib('dynamixel', 'dxl_write_word', 1, 34, 512);
pause(0.1)
calllib('dynamixel', 'dxl_write_word', 2, 34, 512);
pause(0.1)
calllib('dynamixel', 'dxl_write_word', 3, 34, 512);
pause(0.1)
calllib('dynamixel', 'dxl_write_word', 4, 34, 512);
pause(0.1)

calllib('dynamixel', 'dxl_write_word', 1, 32, 150)
pause(0.1)
calllib('dynamixel', 'dxl_write_word', 2, 32, 150)
pause(0.1)
calllib('dynamixel', 'dxl_write_word', 3, 32, 150)
pause(0.1)
calllib('dynamixel', 'dxl_write_word', 4, 32, 130)

end