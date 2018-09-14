% Chooses how the balls will be ejected from the lanes

% randLane: integer with value of 0, 1, or 2
% - other values will cause error

randLane = mod(iteration,3); % UNCOMMENT FOR SEQUENTIAL OPERATION (DEFAULT)
% randLane = randi(3)-1; % UNCOMMENT FOR RANDOM OPERATION

run laneObserve.m
