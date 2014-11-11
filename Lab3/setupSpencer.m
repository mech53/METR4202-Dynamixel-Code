function setupSpencer
    %% Setting up the dynamixel
    rmpath('C:\Users\Spencer\Documents\Lab3GitHub\METR4202-Dynamixel-Code\Lab3\rvctools\robot');
    loadlibrary('dynamixel', 'dynamixel.h');
    DEFAULT_PORTNUM = 5;
    DEFAULT_BAUDNUM = 1;
    res = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, DEFAULT_BAUDNUM);
    msgid = 'MATLAB:dispatcher:nameConflict';
    warning('off', msgid);
end