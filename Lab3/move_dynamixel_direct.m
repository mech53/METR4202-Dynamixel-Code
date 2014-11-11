function [] = move_dynamixel_direct(id, position);
    %% Setting up the dynamixel
%     loadlibrary('dynamixel', 'dynamixel.h');
%     DEFAULT_PORTNUM = 3;
%     DEFAULT_BAUDNUM = 1;
%     res = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, ...
%         DEFAULT_BAUDNUM);
    
    calllib('dynamixel', 'dxl_write_word', id, 30, position);

    %% Closing dynamixel connections
%     calllib('dynamixel','dxl_terminate');
%     unloadlibrary('dynamixel');
end