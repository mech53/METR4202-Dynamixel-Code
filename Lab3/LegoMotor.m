if verLessThan('RWTHMindstormsNXT', '4.01');
    error(strcat('This program requires the RWTH - Mindstorms NXT Toolbox ' ...
    ,'version 4.01 or greater. Go to http://www.mindstorms.rwth-aachen.de ' ...
    ,'and follow the installation instructions!'));
end

COM_CloseNXT all
close all
clear all

h = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(h);
Apower = 10;
Aport  = MOTOR_A;
Adist  = 30;    

AmUp    = NXTMotor(Aport, 'Power',  Apower, 'ActionAtTachoLimit', 'HoldBrake');
AmUp.ResetPosition();

AmUp.TachoLimit=0;
AmUp.WaitFor();
AmUp.SendToNXT();