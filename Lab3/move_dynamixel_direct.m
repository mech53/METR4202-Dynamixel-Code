function [] = move_dynamixel_direct(id, position);
%% Setting up the dynamixel
%During testing we had a great deal of trouble with the dynamixels having
%repeated movements without reloading the library, thus lines 6-13 load the
%library in, move the motor, then unload the library.  If we find a way to
%keep functionality and the library loaded, then it will use the else
%portion of the function    

%   Deal with the possibility that this function is called with the library
%   unloaded.

if ~libisloaded('dynamixel')
        
        %   Set up the path we have to remove - ignore the warning, if the
        %   path is already removed
        disp('The library has to be loaded :(')
        spencer = 'C:\Users\Spencer\Documents\Lab3GitHub\METR4202-Dynamixel-Code\Lab3\rvctools\robot';
        dylan = 'C:\Users\Dylan\Dropbox\4202_group1\Lab3\Lab3\rvctools\robot';
        warning('off', 'MATLAB:rmpath:DirNotFound')
        rmpath(dylan);
        
        %   Load the library
        loadlibrary('dynamixel', 'dynamixel.h');
        DEFAULT_PORTNUM = 5;
        DEFAULT_BAUDNUM = 1;
        res = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, DEFAULT_BAUDNUM);
        
        %   Now we can continue.
end

%   Execute the movement.
calllib('dynamixel', 'dxl_write_word', id, 30, position);

%   Deal with waiting until it's done moving.

speeds = 256;

% while(speeds>0) 
%     calllib('dynamixel', 'dxl_read_word', 1, 46);
%     speeds = (calllib('dynamixel', 'dxl_read_word', 1, 46)+calllib('dynamixel', 'dxl_read_word', 2, 46)+ ...
%         calllib('dynamixel', 'dxl_read_word', 3, 46)+calllib('dynamixel', 'dxl_read_word', 4, 46));
% end


end