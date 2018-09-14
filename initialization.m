% This program initializes the variables used throughout the process
% of controlling the Fanuc M-16iB Industrial Robot Arm & the attached
% end-effector.

clc;
disp('*****************************************************')
disp('*          FANUC INDUSTRIAL ROBOT TEAM              *');
disp('*                  FALL 2015                        *');
disp('*   JEREMY HOOPER | KARL NICOLAUS | RICHARD WOOD    *');
disp('*****************************************************');
pause(5);


clear; clc; warning off; close all;
disp('Initiate operation "SUCH AMAZE, VERY BALLS, MUCH WOW"');
% Initialize the object lane camera
laneCam = webcam(2);
laneCam.Resolution = '160x120';
% Initialize the communication relay board
CommsPneumDuino = arduino('com3','uno');
% Initialize the motor control board
pwmDuino = arduino('com6','uno');
% Initialize the end-effector camera
endEffCam = webcam(1);
endEffCam.Resolution = '160x120';
% endEffCam.Brightness = 150;

% Initialize variables used throughout the program(s)

% Arduino pin variables
% - as wired on the date of the demonstration 12/8/2015
laneRed = 'D2'; % DI[6] in robot controller
laneGreen = 'D3'; % DI[5]
laneBlue = 'D4'; % DI[4]
dropRed = 'D5'; % DI[3]
dropGreen = 'D6'; % DI[2]
dropBlue = 'D7'; % DI[1]
endEff = 'D8'; % DI[7]

% Arduino variables to fire pneumatic cylinders
% - as wired on the date of the demonstration 12/8/2015
pneumRed = 'D10';
pneumGreen = 'D11';
pneumBlue = 'D12';

% Used by 'pwmDuino' object for opening and closing end-effector
pinClose = 'D6';
pinOpen = 'D5';

midX = 80; % Middle pixel of the laneCam picture
offset = 20; % Offset for declaring an object in the middle
distOpen = 78; % Pixel distance for the end-effector to be 'closed'
distClose = 50; % Pixel distance for the end-effector to be 'opened'
gainP_open = 0.45; % Proportional gain (opening)
gainP_close = 0.65; % Proportional gain (closing)
gainI_open = 0.05; % Integral gain (opening)
gainI_close = 0.09; % Integral gain (closing)

% Miscellaneous Variables
randLane = randi(3); % lane chosen to eject ball
detected = 0;
objCenter = [];
objRadius = [];
Red = 0; redBall = false;
Green = 0; greenBall = false;
Blue = 0; blueBall = false;
snapFiltered(:,:,1) = zeros([144,176]);
snapFiltered(:,:,2) = zeros([144,176]);
snapFiltered(:,:,3) = zeros([144,176]);
distPix = [];
writeDigitalPin(pwmDuino, pinOpen, 0);
writeDigitalPin(pwmDuino, pinClose, 0);
eeSensitivity = 0.9; % Sensitivity of end-effector feature recognition | 0 to 1 - higher = more detections
cutFrameLow = 11; % Lower pixel value of end-effector camera frame for image processing
cutFrameHigh = 32; % Upper pixel value of end-effector camera frame for image processing
gainMax = 0.99; % Maximum duty cycle (0 to 1) of pwm signal
gainMaxReached = false;
firstRun = true; % if true: checks end-effector position on first run of the program
watchCount = [];

% Used to increase the effects of integral gain on motor duty cycle
% Lower = slower duty cycle increase
% Higher = faster duty cycle increase
% If too high - can make end-effector uncontrollable
gainOffset = 10;

iteration = 0; % Iteration number used currently to eject balls in sequence (vs. random)

% Directions for preparing the demonstration
disp('1) Turn on robot - Use Robot Neighborhood to run "Amaze-Balls"');
disp('2) Make sure end-effector is closed - turn on motor power supply');
disp('3) Make sure end-effector and lane camera objects are created properly');
disp('	- use preview(laneCam) & preview(endEffCam) to view live feed');
disp('4) Run script "waitHome.m" to start process');
