%=========================================================================%
% Sid Arora
% ASEN 3200
% LAB 3
% Updated: 10/13/20
%=========================================================================%

%% Housekeeping
clear
clc
close all

%% Read in all base encoder files 
base_data5 = readmatrix('Unit7_Base_5');
base_data6 = readmatrix('Unit7_Base_6');
base_data7 = readmatrix('Unit7_Base_7');
base_data8 = readmatrix('Unit7_Base_8');
base_data9 = readmatrix('Unit7_Base_9');
base_data10 = readmatrix('Unit7_Base_10');

%% Calculate alpha values for each base encoder test
alpha5 = abs(find_alpha(base_data5));
alpha6 = abs(find_alpha(base_data6));
alpha7 = abs(find_alpha(base_data7));
alpha8 = abs(find_alpha(base_data8));
alpha9 = abs(find_alpha(base_data9));
alpha10 = abs(find_alpha(base_data10));

%% Calculate inertia values for each test based on specific input torques
torque_vec = [5,6,7,8,9,10]/1000;

inertia_vec = [torque_vec(1)/alpha5,torque_vec(2)/alpha6,torque_vec(3)/alpha7,torque_vec(4)/alpha8,torque_vec(5)/alpha9,torque_vec(6)/alpha10];
inertia_SC = mean(inertia_vec);

%% Functions

function alpha = find_alpha(data)
    % Inputs: data array
    % Outputs: alpha
    % Purpose: find linear regression slope of angular velocity vs time to
    % find alpha of the S/C using base encoder omega values 
    
    % Get rid of first 100 and last 100 data points to clean data 
    time = data(100:end-100,1)/1000; %[seconds]
    omega = data(100:end-100,3)*(2*pi/60); %[rad/s]
    ones_vec = ones(1,length(time));
    x = [ones_vec;time']';
    y = omega;
    regression = x\y;
    alpha = regression(2);
end