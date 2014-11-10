function setdown
    %% Closing dynamixel connections
    calllib('dynamixel','dxl_terminate');
    unloadlibrary('dynamixel');
end