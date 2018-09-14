% Test the pneumatics
    % % Red lane
writeDigitalPin(CommsPneumDuino, pneumRed, 1); pause(1);
writeDigitalPin(CommsPneumDuino, pneumRed, 0);
    % % Blue lane
writeDigitalPin(CommsPneumDuino, pneumBlue, 1); pause(1);
writeDigitalPin(CommsPneumDuino, pneumBlue, 0);
    % % Green lane
writeDigitalPin(CommsPneumDuino, pneumGreen, 1); pause(1);
writeDigitalPin(CommsPneumDuino, pneumGreen, 0);

% Test the signals
writeDigitalPin(CommsPneumDuino, laneRed, 0); pause(1);
writeDigitalPin(CommsPneumDuino, laneRed, 1);

writeDigitalPin(CommsPneumDuino, laneGreen, 0); pause(1);
writeDigitalPin(CommsPneumDuino, laneGreen, 1);

writeDigitalPin(CommsPneumDuino, laneBlue, 0); pause(1);
writeDigitalPin(CommsPneumDuino, laneBlue, 1);

writeDigitalPin(CommsPneumDuino, dropRed, 0); pause(1);
writeDigitalPin(CommsPneumDuino, dropRed, 1);

writeDigitalPin(CommsPneumDuino, dropGreen, 0); pause(1);
writeDigitalPin(CommsPneumDuino, dropGreen, 1);

writeDigitalPin(CommsPneumDuino, dropBlue, 0); pause(1);
writeDigitalPin(CommsPneumDuino, dropBlue, 1);

writeDigitalPin(CommsPneumDuino, endEff, 0); pause(1);
writeDigitalPin(CommsPneumDuino, endEff, 1);