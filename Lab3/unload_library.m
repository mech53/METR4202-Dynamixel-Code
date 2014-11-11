function unload_library

%   Use in case of emergency.

calllib('dynamixel','dxl_terminate');
unloadlibrary('dynamixel'); 
end