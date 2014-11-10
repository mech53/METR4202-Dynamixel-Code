function setup
    %% Setting up the dynamixel
    rmpath('C:\Users\Dylan\Documents\MATLAB\Lab 3\rvctools\robot');
    loadlibrary('dynamixel', 'dynamixel.h');
    DEFAULT_PORTNUM = 3;
    DEFAULT_BAUDNUM = 1;
    res = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, ...
        DEFAULT_BAUDNUM);
    msgid = 'MATLAB:dispatcher:nameConflict';
    warning('off', msgid);
    run('C:\Users\Dylan\Documents\MATLAB\Lab 3\rvctools\startup_rvc.m');
end