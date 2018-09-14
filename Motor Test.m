% Run initialization.m to make sure the arduino objects are created
% Close the grippers
% Turn the power supply up to 24V
% Copy and paste the following code into the command window


writePWMDutyCycle(pwmDuino, pinOpen, 1);
pause(1);
writePWMDutyCycle(pwmDuino, pinOpen, 0);

pause(3);

writePWMDutyCycle(pwmDuino, pinClose, 1);
pause(1);
writePWMDutyCycle(pwmDuino, pinClose, 0);