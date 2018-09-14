CommsPneumDuino = arduino('com3','uno');
laneRed = 'D2'; % DI[6]
laneGreen = 'D3'; % DI[5]
laneBlue = 'D4'; % DI[4]
dropRed = 'D5'; % DI[3]
dropGreen = 'D6'; % DI[2]
dropBlue = 'D7'; % DI[1]
endEff = 'D8'; % DI[7]
pneumRed = 'D10';
pneumGreen = 'D11';
pneumBlue = 'D12';
dt = 0.5; dmove = 2;

writeDigitalPin(CommsPneumDuino, laneGreen, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, laneGreen, 1);

writeDigitalPin(CommsPneumDuino, laneRed, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, laneRed, 1);

writeDigitalPin(CommsPneumDuino, laneBlue, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, laneBlue, 1);

writeDigitalPin(CommsPneumDuino, dropRed, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, dropRed, 1);

writeDigitalPin(CommsPneumDuino, dropGreen, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, dropGreen, 1);

writeDigitalPin(CommsPneumDuino, dropBlue, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, dropBlue, 1);

writeDigitalPin(CommsPneumDuino, endEff, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, endEff, 1);
% //////////////////////
writeDigitalPin(CommsPneumDuino, laneGreen, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, laneGreen, 1);
pause(dmove);
writeDigitalPin(CommsPneumDuino, endEff, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, endEff, 1);
pause(dmove);
writeDigitalPin(CommsPneumDuino, dropGreen, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, dropGreen, 1);
pause(dmove);
writeDigitalPin(CommsPneumDuino, endEff, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, endEff, 1);
% //////////////////////
writeDigitalPin(CommsPneumDuino, laneBlue, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, laneBlue, 1);
pause(dmove);
writeDigitalPin(CommsPneumDuino, endEff, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, endEff, 1);
pause(dmove);
writeDigitalPin(CommsPneumDuino, dropBlue, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, dropBlue, 1);
pause(dmove);
writeDigitalPin(CommsPneumDuino, endEff, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, endEff, 1);
% ///////////////////////
writeDigitalPin(CommsPneumDuino, laneRed, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, laneRed, 1);
pause(dmove);
writeDigitalPin(CommsPneumDuino, endEff, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, endEff, 1);
pause(dmove);
writeDigitalPin(CommsPneumDuino, dropRed, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, dropRed, 1);
pause(dmove);
writeDigitalPin(CommsPneumDuino, endEff, 0); pause(dt);
writeDigitalPin(CommsPneumDuino, endEff, 1);
% ////////////////////////
while 1
    snap = snapshot(endEffCam);
    imCut = snap(:,cutFrameLow:cutFrameHigh, :);
    [cU, rU] = imfindcircles(imCut, [4 8], 'Method', 'TwoStage',  ... %)%; %, ...
                'ObjectPolarity', 'bright', ...
                'Sensitivity', eeSensitivity);
    imshow(imCut); viscircles(cU,rU);
            distPix = sqrt((cU(1,1)-cU(2,1))^2+(cU(1,2)-cU(2,2))^2)
    %     viscircles(cU,rU);
    %     viscircles(cU+[cutFrameLow 0; cutFrameLow 0], rU);
%     if size(cU,1)>1
%         distPix = sqrt((cU(1,1)-cU(2,1))^2+(cU(1,2)-cU(2,2))^2)
%         if size(cU,1)==2
%         viscircles(cU+[cutFrameLow 0; cutFrameLow 0], rU);
%         end
%     end
end
% ////////////////////////

writeDigitalPin(CommsPneumDuino, pneumBlue, 1); pause(1);
writeDigitalPin(CommsPneumDuino, pneumBlue, 0);

writeDigitalPin(CommsPneumDuino, pneumRed, 1); pause(1);
writeDigitalPin(CommsPneumDuino, pneumRed, 0);

writeDigitalPin(CommsPneumDuino, pneumGreen, 1); pause(1);
writeDigitalPin(CommsPneumDuino, pneumGreen, 0);
% ///////////////////////////
writeDigitalPin(pwmDuino, pinClose, 1); pause(1);
writeDigitalPin(pwmDuino, pinClose, 0);

writeDigitalPin(pwmDuino, pinOpen, 1); pause(1);
writeDigitalPin(pwmDuino, pinOpen, 0);

writePWMDutyCycle(pwmDuino, pinOpen, 0.5); pause(1);
writeDigitalPin(pwmDuino, pinOpen, 0);





