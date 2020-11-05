% Shawn Stone, Jason Peloquin, Alexander Kenyon, Max Buchholtz - Lab 3
    %Shawn Stone, Ryan Collins, Max Buchholz, David Alan Koester - Lab 4
% ASEN 3128 - Lab 4
% Main.m
% Created: 9/25/2020
% Last Edited: 10/21/2020

%% Housekeeping
clear; close all; clc;

%% Quadrotor parameters and constants
params = Params();

%% ODE45 setup
tspan = [0,10];
opts = odeset('RelTol',1e-7,'AbsTol',1e-9);

%% K1 and K2 gains
tau1 = 0.5;
tau2 = 0.01;
lambda1 = -1/tau1;
lambda2 = -1/tau2;

k1_roll = params.I_x * (-lambda1 - lambda2);
k2_roll = params.I_x * lambda1 * lambda2;

k1_pitch = params.I_y * (-lambda1 - lambda2);
k2_pitch = params.I_y * lambda1 * lambda2;

gains = [k1_roll, k2_roll; k1_pitch, k2_pitch];


%% Problem 2: Linear Control

% Initial condition vectors
init = zeros(12,5);
init(4,1) = deg2rad(5); %Part a initial condition
init(5,2) = deg2rad(5); %Part b initial condition
init(10,3) = 0.1; %Part c initial condition
init(11,4) = 0.1; %Part d initial condition

% Control forces and moments
f_cntl = [0; 0; -params.m*params.g];
m_cntl = force2moment(f_cntl);

titleName = ["a", "b", "c", "d"]';
for i = 1:4
    [t_2, state_2] = ode45(@(t,state) LinearQuadEOM(t,state,f_cntl,m_cntl, gains),tspan,init(:,i),opts);
    
    figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
    PlotAircraftSim(t_2,state_2,f_cntl,m_cntl, 'o', 'col', 'k')
    sgtitle('Problem 2' + titleName(i) + ': Overview')
    hold off
end

%% Problem 3: Linear vs Nonlinear Control

titleName = ["a", "b", "c", "d"]';
for i = 1:4
    [t_2, state_2] = ode45(@(t,state) LinearQuadEOM(t,state,f_cntl,m_cntl, gains),tspan,init(:,i),opts);
    [t_3, state_3] = ode45(@(t,state) QuadEOM_cntl(t,state,f_cntl,m_cntl, gains, 'k3', false),tspan,init(:,i),opts);

    figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
    PlotAircraftSim(t_2,state_2,f_cntl,m_cntl, 'o', 'col', 'k')
    PlotAircraftSim(t_3,state_3,f_cntl,m_cntl, 'o', 'col', 'b')
    sgtitle('Problem 3' + titleName(i) + ': Overview')
    hold off
end

%% Problem 4: K3 Gains and Locus Plots

%Lateral dynamics
tau3 = 1.25;
k3_vec = linspace(0, 0.001, 1000);
figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
hold on
for i = 1:length(k3_vec)
    A_mat = [0, params.g, 0;  0, 0, 1;  -k3_vec(i)/params.I_x, -gains(1,2)/params.I_x, -gains(1,1)/params.I_x];
    
    eigs = eig(A_mat);
    eigs_real = real(eigs);
    eigs_imag = imag(eigs);
    
    if i == 680
        plot(eigs_real, eigs_imag, 'kx', 'MarkerSize', 15)
    else
        plot(eigs_real, eigs_imag, 'r.')
    end
end
xline(-1/tau3, 'b--')
title('Lateral Control: Locus Plot of Eigenvalues')
hold off

%Finding the k3_roll gain from eigenvalues of locus
k3_roll = k3_vec(680);

%Longitudinal Dynamics
figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
hold on
for i = 1:length(k3_vec)
    A_mat = [0, params.g, 0;  0, 0, 1;  -k3_vec(i)/params.I_y, -gains(2,2)/params.I_y, -gains(2,1)/params.I_y];
    
    eigs = eig(A_mat);
    eigs_real = real(eigs);
    eigs_imag = imag(eigs);
    
    if i == 920
        plot(eigs_real, eigs_imag, 'kx', 'MarkerSize', 15)
    else
        plot(eigs_real, eigs_imag, 'r.')
    end
end
xline(-1/tau3, 'b--')
title('Longitudinal Control: Locus Plot of Eigenvalues')
hold off

%Finding the k3_pitch gain from eigenvalues of locus
k3_pitch = -k3_vec(920);

gains = [k1_roll, k2_roll, k3_roll; k1_pitch, k2_pitch, k3_pitch];


%% Problem 5: Nonlinear with K3 gains

[t_5, state_5] = ode45(@(t,state) QuadEOM_cntl(t,state,f_cntl,m_cntl, gains, 'k3', true),tspan,init(:,5),opts);

figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
PlotAircraftSim(t_5,state_5,f_cntl,m_cntl, 'o', 'col', 'b')
sgtitle('Problem 5: Overview')
hold off

%% Problem 6: Simulated vs Tested data

load('RSdata_10_22_1407_8.mat')

t_6_real = rt_estim.time(:);
state_6_real = rt_estim.signals.values(:,:);

real_gains = [0.002, 0.013, 0.1; 0.003, 0.005, -0.030303];
                    %[k1_roll, k2_roll, k3_roll; k1_pitch, k2_pitch, k3_pitch]

tspan6 = [0, 12.995];
[t_6, state_6] = ode45(@(t,state) QuadEOM_cntl(t,state,f_cntl,m_cntl, real_gains, 'k3', true, 'refTime', [6, 8], 'refDir', [1,0]), tspan6, init(:,5),opts);

figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
hold on
PlotAircraftSim(t_6,state_6,f_cntl,m_cntl, 'o', 'col', 'b')
PlotAircraftSim(t_6_real,state_6_real,f_cntl,m_cntl, 'o', 'col', 'r')
sgtitle('Problem 6: Overview')
hold off