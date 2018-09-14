% Close the end-effector on the object and proceed to dropping the object
disp('Using the end-effector to grip the ball');

pause(1.5); % Delay the amount of time that the ball is in the lane before proceeding

disp('CLOSING THE CLAW');

% Reset signals to the robot
writeDigitalPin(CommsPneumDuino, laneRed, 1);
writeDigitalPin(CommsPneumDuino, laneGreen, 1);
writeDigitalPin(CommsPneumDuino, laneBlue, 1);
% Reset signals to the end-effector
writeDigitalPin(pwmDuino, pinOpen, 0);
writeDigitalPin(pwmDuino, pinClose, 0);
% Reset proportional and integral gain values
proportional = 0;
integral = 0;
% Initialize distPix to guarantee entering the loop
distPix = distOpen;
% Closing the claw
figure(2);
while distPix > distClose
    % Import image from end-effector camera
    snap = snapshot(endEffCam);
    % Trim the image for faster image processing
    imCut = snap(:,cutFrameLow:cutFrameHigh, :);
    % Locate features on the end-effector
    [cU, rU] = imfindcircles(imCut, [4 8], 'Method', 'TwoStage',  ... %)%; %, ...
            'ObjectPolarity', 'bright', ...
            'Sensitivity', eeSensitivity);
    % Display the image
    imshow(snap);
    % Calculate the distance between the pixels if more than one detected
    if size(cU,1)>1
        distPix = sqrt((cU(1,1)-cU(2,1))^2+(cU(1,2)-cU(2,2))^2);
        % Display the detected feature on screen if there are exactly two
        if size(cU,1)==2
        viscircles(cU+[cutFrameLow 0; cutFrameLow 0], rU);
        end
    end
    % Calculate proportional gain
    proportional = abs(distClose - distPix) / 100 * gainP_open;
    % Compound integral gain
    integral = ((abs((distClose-gainOffset) - distPix) / 100)) * gainI_open + integral;
    % Display distance between the circles and the percentage duty cycle to the end-effector motor
    disp(['Pixel Distance = ' num2str(round(distPix)) ' // ' ...
        'Duty Cycle = ' num2str(round((proportional+integral)*100)) '%']);
    % If gainMax is reached: Exit loop and proceed to next part of the program
    if (proportional+integral) >= gainMax
        distPix = distClose-1;
        proportional = 0;
        integral = 0;
        gainMaxReached = true;
    end
    % Write pwm duty cycle to pwmDuino
    % Note: This is not reset after being achieved to maintain a grip on the ball during movement
    writePWMDutyCycle(pwmDuino, pinClose, proportional + integral);
    writePWMDutyCycle(pwmDuino, pinOpen, 0);
end
% Display the exit conditions for the while loop
% Gain Max or Desired Distance (pixels)
if gainMaxReached
    disp(['GAIN MAX REACHED' ]);
else
    disp(['DESIRED DISTANCE REACHED']);
end

pause(0.5);

% Send pulse to the robot that the ball is gripped
writeDigitalPin(CommsPneumDuino, endEff, 0); pause(0.5);
writeDigitalPin(CommsPneumDuino, endEff, 1);

run ballDrop.m

