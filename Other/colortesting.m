disp('Watching for objects in the lane');
% pause(0.3);
% writeDigitalPin(CommsPneumDuino, pneumRed, 0);
% writeDigitalPin(CommsPneumDuino, pneumGreen, 0);
% writeDigitalPin(CommsPneumDuino, pneumBlue, 0);
% figure(1); watchCount = 0;
while 1
    while ~detected
        watchCount = watchCount + 1;
        snapFiltered = imgaussfilt(snapshot(laneCam),2);
        [objCenter, objRadius] = imfindcircles(snapFiltered, [15 25], 'Method', 'TwoStage',  ... %)%; %, ...
            'ObjectPolarity', 'dark'); % ... % );
        imshow(snapFiltered);
    %     disp(objRadius);
        viscircles(objCenter, objRadius);
        if isfinite(objRadius)
            detected = 1;
            pause(2);
        end
    %     disp(watchCount);
    %     if watchCount == 30;
    %         switch randLane
    %         case 1
    %             writeDigitalPin(CommsPneumDuino, pneumRed, 1);
    %         case 2
    %             writeDigitalPin(CommsPneumDuino, pneumGreen, 1);
    %         case 3
    %             writeDigitalPin(CommsPneumDuino, pneumBlue, 1);
    %             otherwise
    %             disp('Error triggering random pneumatic cylinder');
    %         end
    %     end
    end
    detected = 0;
%     disp('OBJECT DETECTED');
    objCenter = round(objCenter);
    Red = snapFiltered(objCenter(1,2),objCenter(1,1),1);
    Green = snapFiltered(objCenter(1,2),objCenter(1,1),2);
    Blue = snapFiltered(objCenter(1,2),objCenter(1,1),3);
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

    if objCenter(1) > (midX - offset) && objCenter(1) < (midX + offset)
        disp('MIDDLE LANE');
%         writeDigitalPin(CommsPneumDuino, laneGreen, 0); %pause(0.5);
    %     writeDigitalPin(CommsPneumDuino, laneGreen, 1);
    elseif objCenter(1) > (midX + offset)
        disp('RIGHT LANE');
%         writeDigitalPin(CommsPneumDuino, laneRed, 0); %pause(0.5);
    %     writeDigitalPin(CommsPneumDuino, laneRed, 1);
    else
        disp('LEFT LANE');
%         writeDigitalPin(CommsPneumDuino, laneBlue, 0); %pause(0.5);
    %     writeDigitalPin(CommsPneumDuino, laneBlue, 1);
    end
%     writeDigitalPin(CommsPneumDuino, pneumRed, 0);
%     writeDigitalPin(CommsPneumDuino, pneumGreen, 0);
%     writeDigitalPin(CommsPneumDuino, pneumBlue, 0);
    % pause(5);
end
% run endEffectorControl.m
