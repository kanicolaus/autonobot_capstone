function pneumRed()
    writeDigitalPin(CommsPneumDuino, laneRed, 1); pause(0.5);
    writeDigitalPin(CommsPneumDuino, laneRed, 0); pause(0.5);
end