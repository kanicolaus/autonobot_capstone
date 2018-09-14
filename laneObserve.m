% Ejects a ball from the lanes and captures its position and color


disp('Watching for objects in the lane');

figure(1);
watchCount = 0;
while ~detected
    % Increment variable watchCount
    watchCount = watchCount + 1;
%     disp('Watch count' num2str(watchCount));
    % Use gaussian filter on snapshots from laneCam
    snapFiltered = imgaussfilt(snapshot(laneCam),2);
    % Search for spherical object in the lane
    [objCenter, objRadius] = imfindcircles(snapFiltered, ...
        [15 25], 'Method', 'TwoStage',  ...
        'ObjectPolarity', 'dark');
    % Display camera feed on screen
    imshow(snapFiltered);
    % Display detected circles
    viscircles(objCenter, objRadius);
    % If object found - set detected to true
    if isfinite(objRadius)
        detected = 1;
    end
    % Number of frames seen before ejected ball
    if watchCount == 30; % Increase to speed up firing of the ball (DEFAULT: 30)
        % Use randLane to choose the ball to eject
        switch randLane
            case 1
                writeDigitalPin(CommsPneumDuino, pneumRed, 1);
            case 2
                writeDigitalPin(CommsPneumDuino, pneumGreen, 1);
            case 0
                writeDigitalPin(CommsPneumDuino, pneumBlue, 1);
            otherwise
                disp('Error triggering random pneumatic cylinder');
        end
    end
end

disp('OBJECT DETECTED');
% Round objCenter for integer values (pixel)
objCenter = round(objCenter);
% Extract RGB values from object centerpoint
Red = snapFiltered(objCenter(1,2),objCenter(1,1),1);
Green = snapFiltered(objCenter(1,2),objCenter(1,1),2);
Blue = snapFiltered(objCenter(1,2),objCenter(1,1),3);
% Use RGB values to determine color of the object
if Red > Green && Red > Blue
    disp('RED BALL');
    redBall = true;
elseif Blue > Red && Blue > Green
    disp('BLUE BALL');
    blueBall = true;
else
    disp('GREEN BALL');
    greenBall = true;
end
% Use objCenter to determine the lane - output corresponding signal to robot controller
if objCenter(1) > (midX - offset) && objCenter(1) < (midX + offset)
    disp('MIDDLE LANE');
    writeDigitalPin(CommsPneumDuino, laneGreen, 0);
elseif objCenter(1) > (midX + offset)
    disp('RIGHT LANE');
    writeDigitalPin(CommsPneumDuino, laneRed, 0);
else
    disp('LEFT LANE');
    writeDigitalPin(CommsPneumDuino, laneBlue, 0);
end
% Reset the pneumatics
writeDigitalPin(CommsPneumDuino, pneumRed, 0);
writeDigitalPin(CommsPneumDuino, pneumGreen, 0);
writeDigitalPin(CommsPneumDuino, pneumBlue, 0);

run ballGrip.m
