function motorsetup()
    if ~libisloaded('dynamixel')    
        loadlibrary('dynamixel', 'dynamixel.h');
        DEFAULT_PORTNUM = 5;
        DEFAULT_BAUDNUM = 1;
        res = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, DEFAULT_BAUDNUM);

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
        calllib('dynamixel', 'dxl_write_word', 4, 32, 350)
       
        calllib('dynamixel','dxl_terminate');
        unloadlibrary('dynamixel'); 
    else
        
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

end