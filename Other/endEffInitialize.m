% Practicing the control system for the end-effector

% % endEffCam = webcam(2);
% % pwmDuino = arduino('com6', 'uno');
% % 
% % pinClose = 'D5';
% % pinOpen = 'D6';

% % % TO TEST CLOSING THE END-EFFECTOR
% % writeDigitalPin(pwmDuino, pinClose, 1); pause(0.3);
% % writeDigitalPin(pwmDuino, pinClose,0);
% % 
% % pause(1);
% % 
% % % TO TEST OPENING THE END-EFFECTOR
% % writeDigitalPin(pwmDuino, pinOpen, 1); pause(0.3);
% % writeDigitalPin(pwmDuino, pinOpen,0);


close all; warning off;
controlOffset = 5;
distOpen = 80; % PIX
distClose = 25;
gainP_open = 0.3; gainP_close = 0.3;
gainI_open = 0.05; gainI_close = 0.05;

% TO TEST THE CAMERA
% while distPix > distClose
% %     snapUnfiltered = snapshot(endEffCam);
% %     snapFiltered = imgaussfilt(snapshot(endEffCam),2);
%     snap = snapshot(endEffCam);
%     imCut = snap(:,65:85, :);
%     [cU, rU] = imfindcircles(imCut, [4 8], 'Method', 'TwoStage',  ... %)%; %, ...
%             'ObjectPolarity', 'bright', ...
%             'Sensitivity', 0.9);
% %     figure(1);
%     imshow(imCut);
%     viscircles(cU, rU);
%     distPix = sqrt((cU(1,1)-cU(2,1))^2+(cU(1,2)-cU(2,2))^2);
%     disp(['Pixel Distance = ' num2str(distPix)]);
%     
%     proportional = distPix / 100;
%     disp(['Pixel Distance = ' num2str(proportional)]);
%     
%     writePWMDutyCycle(pwmDuino, pinClose, proportional);
% end
% writeDigitalPin(pwmDuino, pinClose, 0);
% disp('Ball Gripped');


% writePWMDutyCycle(pwmDuino, pinClose, 0.5); pause(0.5);
%     writeDigitalPin(pwmDuino, pinClose, 0);
% writePWMDutyCycle(pwmDuino, pinClose, 0.5); pause(0.5);
% writeDigitalPin(pwmDuino, pinClose, 0);
% 
% writePWMDutyCycle(pwmDuino, pinOpen, 0.3); pause(0.5);
% writeDigitalPin(pwmDuino, pinOpen, 0);






% 
% figure(2);
% imshow(snapFiltered);
% viscircles(objCenterFilt, objRadiusFilt);

% while ~detected
%     snapFiltered = imgaussfilt(snapshot(laneCam),2);
%     [objCenter, objRadius] = imfindcircles(snapFiltered, [1 10], 'Method', 'TwoStage',  ... %)%; %, ...
%         'ObjectPolarity', 'light'); % ... % );
% %             'Sensitivity', .8, ...
% %             'EdgeThreshold', 0.4);
% %     [c, r] = imfindcircles(snap);
%     imshow(snapFiltered);
%     disp(objRadius);
%     viscircles(objCenter, objRadius);
%     if isfinite(objRadius)
%         detected = 1;
%     end
% end