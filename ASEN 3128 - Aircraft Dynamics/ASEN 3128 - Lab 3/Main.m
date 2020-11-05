% Shawn Stone, Jason Peloquin, Alexander Kenyon, Max Buchholtz
% ASEN 3128 - Lab 3
% Main.m
% Created: 9/25/2020
% Last Edited: 10/8/2020

%% Housekeeping
clear; close all; clc;

%% Quadrotor parameters and constants
params = Params();

%% ODE45 setup
tspan = [0,15];
opts = odeset('RelTol',1e-7,'AbsTol',1e-9);

%% Lab 3
%NOTE: 3 corresponds to problem 3, 4 to problem 4, etc

% Initial condition vectors
init_3 = zeros(12,6);
init_3(4,1) = deg2rad(5); %Part a initial condition
init_3(5,2) = deg2rad(5); %Part b initial condition
init_3(6,3) = deg2rad(5); %Part c initial condition
init_3(10,4) = 0.1; %Part d initial condition
init_3(11,5) = 0.1; %Part e initial condition
init_3(12,6) = 0.1; %Part f initial condition
init_4 = init_3;
init_5 = init_3;

% Control forces and moments
f_cntl_3 = [0; 0; -params.m*params.g];
m_cntl_3 = force2moment(f_cntl_3);
f_cntl_4 = [0; 0; -params.m*params.g];
m_cntl_4 = force2moment(f_cntl_4);
f_cntl_5 = [0; 0; -params.m*params.g];
m_cntl_5 = force2moment(f_cntl_5);

% ode45 integration and plots for a-f of Problems 3, 4, and 5, overlayed on
% top of each other
titleName = ["a", "b", "c", "d", "e", "f"]';
for i = 1:6
    [t_3, state_3] = ode45(@(t,state) QuadEOM(t,state,f_cntl_3,m_cntl_3),tspan,init_3(:,i),opts);
    [t_4, state_4] = ode45(@(t,state) LinearQuadEOM(t,state,f_cntl_4,m_cntl_4),tspan,init_4(:,i),opts);
    [t_5, state_5] = ode45(@(t,state) QuadEOM_cntl(t,state,f_cntl_5,m_cntl_5),tspan,init_5(:,i),opts);
    
    figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
    PlotAircraftSim(t_3,state_3,f_cntl_3,m_cntl_3, 'f', 'col', 'b')
    PlotAircraftSim(t_4,state_4,f_cntl_4,m_cntl_4, 'f', 'col', 'k')
    PlotAircraftSim(t_5,state_5,f_cntl_5,m_cntl_5, 'f', 'col', 'r--')
    sgtitle('Problem 3-5' + titleName(i) + ' Overview')
    hold off
end

%NOTE: motor forces are plotted WITHIN PlotAircraftSim() for simplicity

%This section plots the motor forces for parts d-f of Problem 5
for k = 4:6
    [t_5, state_5] = ode45(@(t,state) QuadEOM_cntl(t,state,f_cntl_5,m_cntl_5),tspan,init_5(:,k),opts);

    figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
    PlotAircraftSim(t_5,state_5,f_cntl_5,m_cntl_5, 'm', 'col', 'r--')
    sgtitle('Problem 5' + titleName(k) + ' Motor Forces')
    hold off
end



