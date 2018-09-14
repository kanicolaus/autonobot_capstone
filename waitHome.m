% Functions as a workspace variable reset and also performs firstRun responsibilities

% Reset the workspace variables
iteration = iteration + 1; % increment the number of iterations
detected = 0;
objCenter = [];
objRadius = [];
Red = 0; redBall = false;
Green = 0; greenBall = false;
Blue = 0; blueBall = false;
writeDigitalPin(pwmDuino, pinOpen, 0);
writeDigitalPin(pwmDuino, pinClose, 0);
propotionl = 0;
integral = 0;
gainMaxReached = false;
gainSum = 0;
writeDigitalPin(CommsPneumDuino, pneumRed, 0);
writeDigitalPin(CommsPneumDuino, pneumGreen, 0);
writeDigitalPin(CommsPneumDuino, pneumBlue, 0);

% If this is the first run - check that the end-effector is opened before proceeding
% If closed: open it.
if firstRun
    disp('FIRST RUN - OPENING END-EFFECTOR');
    % Initialize distPix to enter the loop
    distPix = 0;
    while distPix < distOpen
        % Import image from the end-effector camera
        snap = snapshot(endEffCam);
        % Trim image for faster image processing
        imCut = snap(:,cutFrameLow:cutFrameHigh, :);
        % Look for circular features on end-effector
        [cU, rU] = imfindcircles(imCut, [4 8], 'Method', 'TwoStage',  ... %)%; %, ...
                'ObjectPolarity', 'bright', ...
                'Sensitivity', eeSensitivity);
        % Calculate distance if more than one object is detected
        if size(cU,1)>1
            distPix = sqrt((cU(1,1)-cU(2,1))^2+(cU(1,2)-cU(2,2))^2);
        end
        % Calculate proportional gain
        proportional = abs(distOpen - distPix) / 100 * gainP_open;
        % Compound integral gain
        integral = ((abs((distOpen+gainOffset) - distPix) / 100)) * gainI_open + integral;
        % Add together gain values
        gainSum = proportional+integral;
        % If gainSum is too large (more than 100% duty cycle - set to 100%)
        if (gainSum >= 1)
            gainSum = 1;
        end
        % Display pixel value and decimal duty cycle
        disp(['Pixel Distance = ' num2str(distPix)]);
        disp(['Duty cycle = ' num2str(proportional + integral)]);
        % Write duty cycle to pwmDuino
        writePWMDutyCycle(pwmDuino, pinOpen, proportional + integral);
    end
    % firstRun only true on the first run after executing 'initialization.m'
    firstRun = false;
end
% Reset output to the end-effector
writeDigitalPin(pwmDuino, pinClose, 0);
writeDigitalPin(pwmDuino, pinOpen, 0);

disp('CLAW IS OPENED - STARTING THE CYCLE');

run ballEject.m
