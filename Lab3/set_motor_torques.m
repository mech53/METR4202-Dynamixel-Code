function set_motor_torques
%   Set a default value for the position
%   Set up the path we have to remove - ignore the warning, if the
%   path is already removed
disp('The library has to be loaded :(')
spencer = 'C:\Users\Spencer\Documents\Lab3GitHub\METR4202-Dynamixel-Code\Lab3\rvctools\robot';
dylan = 'C:\Users\Dylan\Dropbox\4202_group1\Lab3\Lab3\rvctools\robot';
warning('off', 'MATLAB:rmpath:DirNotFound')
rmpath(spencer);

%   Load the library
loadlibrary('dynamixel', 'dynamixel.h');
DEFAULT_PORTNUM = 5;
DEFAULT_BAUDNUM = 1;
res = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, DEFAULT_BAUDNUM);

%   Now we can continue.

calllib('dynamixel', 'dxl_write_word', 1, 34, 200) 
calllib('dynamixel', 'dxl_write_word', 2, 34, 200) 
calllib('dynamixel', 'dxl_write_word', 3, 34, 200) 
calllib('dynamixel', 'dxl_write_word', 4, 34, 1023) 
% calllib('dynamixel', 'dxl_write_word', 1, 32, 150)
calllib('dynamixel', 'dxl_write_word', 2, 32, 128)
% calllib('dynamixel', 'dxl_write_word', 3, 32, 150)
% calllib('dynamixel', 'dxl_write_word', 4, 32, 350)

% calllib('dynamixel', 'dxl_write_byte', 1, 28, 128)
% calllib('dynamixel', 'dxl_write_byte', 1, 29, 128)
% calllib('dynamixel', 'dxl_write_byte', 2, 28, 128)
% calllib('dynamixel', 'dxl_write_byte', 2, 29, 128)
% calllib('dynamixel', 'dxl_write_byte', 3, 28, 128)
% calllib('dynamixel', 'dxl_write_byte', 3, 29, 128)

end