% Moves the robot to the desired 'drop' position and controls
% the end-effector to open to the desired position which drops
% the ball and prepares it for catching more.

disp('DROPPING THE BALL');

% Outputs corresponding signal based on ball color
% Commands the robot to move to the desired position
if redBall
    writeDigitalPin(CommsPneumDuino, dropRed, 0); pause(1);
    writeDigitalPin(CommsPneumDuino, dropRed, 1);
elseif greenBall
    writeDigitalPin(CommsPneumDuino, dropGreen, 0); pause(1);
    writeDigitalPin(CommsPneumDuino, dropGreen, 1);
elseif blueBall
    writeDigitalPin(CommsPneumDuino, dropBlue, 0); pause(1);
    writeDigitalPin(CommsPneumDuino, dropBlue, 1);
end

pause(1.5); % Approximate time it takes for the robot to move from the lane to the drop position

% Reset pwm gain values
proportional = 0;
integral = 0;
% Initialize distPix to enter the loop
distPix = distClose;
% Opening the claw
figure(2);
while distPix < distOpen
    % Import image from the camera
    snap = snapshot(endEffCam);
    % Cut the image to reduce image processing time
    imCut = snap(:,cutFrameLow:cutFrameHigh, :);
    % Search the image for the features (circles)
    [cU, rU] = imfindcircles(imCut, [4 8], 'Method', 'TwoStage',  ...
            'ObjectPolarity', 'bright', ...
            'Sensitivity', eeSensitivity);
    % Display the image onto the screen
    imshow(snap);
    % Recalculate distance when more than one circle is detected
    if size(cU,1)>1
        distPix = sqrt((cU(1,1)-cU(2,1))^2+(cU(1,2)-cU(2,2))^2);
        % If exactly two circles detected: make visible on screen
        if size(cU,1)==2
        viscircles(cU+[cutFrameLow 0; cutFrameLow 0], rU);
        end
    end
    % Calculate proportional gain
    proportional = abs(distOpen - distPix) / 100 * gainP_open;
    % Compound integral gain
    integral = ((abs((distOpen+gainOffset) - distPix) / 100)) * gainI_open + integral;
    % Display the distance between circle centers and display duty cycle in percentage
    disp(['Pixel Distance = ' num2str(round(distPix)) ' // ' ...
        'Duty Cycle = ' num2str(round((proportional+integral)*100)) '%']);
    % Exit loop if duty cycle exceeds gainMax
    if (proportional+integral) >= gainMax
        distPix = distOpen+1;
        proportional = 0;
        integral = 0;
    end
    % Write duty cycle to arduino object
    writePWMDutyCycle(pwmDuino, pinOpen, proportional + integral);
    writePWMDutyCycle(pwmDuino, pinClose, 0);
end
% Clear pwm signals to the end-effector
writeDigitalPin(pwmDuino, pinClose, 0);
writeDigitalPin(pwmDuino, pinOpen, 0);

disp('CLAW OPENED - RETURNING TO HOME');

% Command the robot to proceed to the next part of the program
writeDigitalPin(CommsPneumDuino, endEff, 0); pause(0.5);
writeDigitalPin(CommsPneumDuino, endEff, 1);

run waitHome.m
