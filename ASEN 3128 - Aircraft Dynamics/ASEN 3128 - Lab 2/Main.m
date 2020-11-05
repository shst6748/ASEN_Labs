% Shawn Stone, Connor Baldwin, William Gravel
% ASEN 3128
% Main.m
% Created: 9/11/2020
% Edited: 9/24/2020

%% Housekeeping
clear; close all; clc;

%% Quadrotor parameters and constants
params = Params();

%% ODE45 setup
tspan = [0,100];
opts = odeset('RelTol',1e-7,'AbsTol',1e-9);

%% Problem 1
% Initial conditions
init_1 = [0; 0; -20; 0; 0; 0; 0; 0; 0; 0; 0; 0];

% Control forces and moments
f_cntl_1 = [0; 0; -params.m*params.g];
m_cntl_1 = force2moment(f_cntl_1);

% ODE45 integration and plots
[t_1,state_1] = ode45(@(t,state) QuadEOM(t,state,f_cntl_1,m_cntl_1,'IncludeDrag',false),tspan,init_1,opts);
% QuadPlot(t_1,state_1,'fprvso','Title','Steady Hover Motion with Control','SavePlots',true,'Problem','1')

%% Problem 2a
% Initial conditions
init_2a = [0; 0; -20; 0; 0; 0; 0; 0; 0; 0; 0; 0];

% Control forces and moments
f_cntl_2a = [0; 0; -params.m*params.g];
m_cntl_2a = force2moment(f_cntl_2a);

% ODE45 integration and plots
[t_2a,state_2a] = ode45(@(t,state) QuadEOM(t,state,f_cntl_2a,m_cntl_2a),tspan,init_2a,opts);
 QuadPlot(t_2a,state_2a,'fprvso','Title','Steady Hover Motion with Control and Drag','SavePlots',true,'Problem','2a')

%% Problem 2b
% Initial conditions, control forces and moments
[init_2b,f_cntl_2b,m_cntl_2b] = QuadTrim(0,5,0,0);

% ODE45 integration and plots
[t_2b,state_2b] = ode45(@(t,state) QuadEOM(t,state,f_cntl_2b,m_cntl_2b),tspan,init_2b,opts);
 QuadPlot(t_2b,state_2b,'fprvso','Title','Simulated Trim Motion for 5 m/s East Translation and 0° Yaw','SavePlots',true,'Problem','2b')

%% Problem 2c
% Initial conditions, control forces and moments
[init_2c,f_cntl_2c,m_cntl_2c] = QuadTrim(0,5,0,pi/2);

% ODE45 integration and plots
[t_2c,state_2c] = ode45(@(t,state) QuadEOM(t,state,f_cntl_2c,m_cntl_2c),tspan,init_2c,opts);
 QuadPlot(t_2c,state_2c,'fprvso','Title','Simulated Trim Motion for 5 m/s East Translation and 90° Yaw','SavePlots',true,'Problem','2c')

%% Problem 3a
% Initial conditions
init_3a = [0; 0; -20; 0; 0; 0; 0; 0; 0; 0; 0; 0];

% Control forces and moments
f_cntl_3a_s = [0; 0; -params.m*params.g];
m_cntl_3a_s = force2moment(f_cntl_3a_s);

% Stable ODE45 integration
[t_3a_s,state_3a_s] = ode45(@(t,state) QuadEOM(t,state,f_cntl_3a_s,m_cntl_3a_s),[0,1],init_3a,opts);

% Random control disturbance
[f_cntl_3a_d,m_cntl_3a_d] = RandomDisturbance(f_cntl_3a_s,m_cntl_3a_s);

% Disturbed ODE45 integration
[t_3a_d,state_3a_d] = ode45(@(t,state) QuadEOM(t,state,f_cntl_3a_d,m_cntl_3a_d),[1.001,5],init_3a,opts);

% Combined data
t_3a = [t_3a_s; t_3a_d];
state_3a = [state_3a_s; state_3a_d];

% Plots
 QuadPlot(t_3a,state_3a,'fo','Title','Simulated Motion with Forced Control Disturbance','SavePlots',true,'Problem','3a','Disturbance',1)

%% Problem 3b
% Experimental data
data = load('RSdata_nocontrol.mat');
t_3b = data.rt_estim.time;
state_3b = data.rt_estim.signals.values;

% Plots
 QuadPlot(t_3b,state_3b,'fo','Title','Experimental Motion without Control','SavePlots',true,'Problem','3b')
