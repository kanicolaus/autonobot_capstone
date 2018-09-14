disp('CLOSING THE CLAW');

writeDigitalPin(pwmDuino, pinOpen, 0);
writeDigitalPin(pwmDuino, pinClose, 0);

distPix = 100; proportional = 0;
integral = 0;

while distPix > distClose
%     snapUnfiltered = snapshot(endEffCam);
%     snapFiltered = imgaussfilt(snapshot(endEffCam),2);
    snap = snapshot(endEffCam);
    imCut = snap(:,65:85, :);
    [cU, rU] = imfindcircles(imCut, [4 8], 'Method', 'TwoStage',  ... %)%; %, ...
            'ObjectPolarity', 'bright', ...
            'Sensitivity', 0.9);
%     figure(1);
%     imshow(imCut);
%     viscircles(cU, rU);
    distPix = sqrt((cU(1,1)-cU(2,1))^2+(cU(1,2)-cU(2,2))^2);
    proportional = abs(20 - distPix) / 100 * gainP_open;
    integral = ((abs(20 - distPix) / 100)) * gainI_open + integral;

    disp(['Pixel Distance = ' num2str(distPix)]);
    disp(['Prop. Gain = ' num2str(proportional)]);
    disp(['Int. Gain = ' num2str(integral)]);

    writePWMDutyCycle(pwmDuino, pinClose, proportional + integral);
end

writeDigitalPin(pwmDuino, pinClose, 0);
writeDigitalPin(pwmDuino, pinOpen, 0);

disp('Claw Closed - Now Opening');

pause(2);

run testOpen.m
