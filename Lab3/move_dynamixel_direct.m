function [] = move_dynamixel_direct(id, position);
%% Setting up the dynamixel
%During testing we had a great deal of trouble with the dynamixels having
%repeated movements without reloading the library, thus lines 6-13 load the
%library in, move the motor, then unload the library.  If we find a way to
%keep functionality and the library loaded, then it will use the else
%portion of the function
    if ~libisloaded('dynamixel')
        rmpath('C:\Users\Spencer\Documents\Lab3GitHub\METR4202-Dynamixel-Code\Lab3\rvctools\robot');
        loadlibrary('dynamixel', 'dynamixel.h');
        DEFAULT_PORTNUM = 5;
        DEFAULT_BAUDNUM = 1;
        res = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, DEFAULT_BAUDNUM);

        calllib('dynamixel', 'dxl_write_word', id, 30, position);

        calllib('dynamixel','dxl_terminate');
        unloadlibrary('dynamixel'); 
    else
        calllib('dynamixel', 'dxl_write_word', id, 30, position);
        disp('yep -Cody Birks')
    end
end