function PlotAircraftSim(t, state, force, moment, flags, opts)
%QUADPLOT Plots data of quadrotor motion integration.
%   Displays quadrotor flight path, position, rotation, velocity, and spinrate.
%
%   Notes:      - State data is rounded to 5 decimals to remove
%                 computational inaccuracy
%               - Angles are converted from radians to degrees
%
%   Inputs:     t                 -   time vector [s] (Mx12 double)
%               state             -   state vector (Mx12 double)
%               force             -   control forces
%               moment        -   control moments
%               flags             -   data-associated letters to plot (1x1 string)
%               opts              -   name-value pairs for plotting options (1x1 struct)
%
%   Outputs:    NONE
%
%   Author:                 Shawn Stone, Jason Peloquin
%   Contribuors:          Alexander Kenyon
%   Created:                09/11/2020
%   Edited:                  10/1/2020
%   Purpose:                ASEN 3128 - Lab 3
%   Based on Lab 2 code made by William Gravel

%% Input arguments
arguments
    t (:,1) double
    state (:,12) double
    force (3,:) double
    moment (3,:) double
    flags (1,1) string = 'o'
    opts.Title (1,1) string = 'Quadrotor Motion'
    opts.SavePlots (1,1) logical = false
    opts.Problem (1,1) string
    opts.Disturbance (1,1) double
    opts.col (1,1) string
end

params = Params();

%% Round state values while keeping relevant accuracy and convert to degrees
state = round(state,5); 
state(:,4:6) = rad2deg(state(:,4:6));
state(:,10:12) = rad2deg(state(:,10:12));

%% Quadrotor Flight Path
if contains(flags,'f')
    %figure() %used to generate figures on spearate plots for separate
    %simulations. Turn off to plot multiple simulations on same axes
    plot3(state(:,1),state(:,2),state(:,3),opts.col,'LineWidth',0.8); hold on;
    plot3(state(1,1), state(1,2), state(1,3), 'g.', 'MarkerSize', 30);
    plot3(state(end,1), state(end,2), state(end,3), 'r.', 'MarkerSize', 20);
    grid on
    xlabel('x_E [m]')
    ylabel('y_E [m]')
    zlabel('z_E [m]')
%     title('Problem ' + opts.Problem + ': Flight Path')
    
end

%% Quadrotor Position
if contains(flags,'p')
%     figure
    subplot(3,1,1)
    plot(t,state(:,1),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('x_E [m]')

    subplot(3,1,2)
    plot(t,state(:,2),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('y_E [m]')

    subplot(3,1,3)
    plot(t,state(:,3),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('z_E [m]')

%     sgtitle('Problem ' + opts.Problem + ': Position Over Time')
end

%% Quadrotor Rotation
if contains(flags,'r')
%     figure
    subplot(3,1,1)
    plot(t,state(:,4),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,4);state(:,5);state(:,6)]))-1,round(max([state(:,4);state(:,5);state(:,6)]))+1])
    xlabel('time [s]')
    ylabel('\phi [deg]')

    subplot(3,1,2)
    plot(t,state(:,5),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,4);state(:,5);state(:,6)]))-1,round(max([state(:,4);state(:,5);state(:,6)]))+1]);
    xlabel('time [s]')
    ylabel('\theta [deg]')

    subplot(3,1,3)
    plot(t,state(:,6),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,4);state(:,5);state(:,6)]))-1,round(max([state(:,4);state(:,5);state(:,6)]))+1])
    xlabel('time [s]')
    ylabel('\psi [deg]')

%     sgtitle('Problem ' + opts.Problem + ': Rotation Over Time')
end

%% Quadrotor Velocity
if contains(flags,'v')
%     figure
    subplot(3,1,1)
    plot(t,state(:,7),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('u^E [m/s]')

    subplot(3,1,2)
    plot(t,state(:,8),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('v^E [m/s]')

    subplot(3,1,3)
    plot(t,state(:,9),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('w^E [m/s]')

%     sgtitle('Problem ' + opts.Problem + ': Velocity Over Time')
end

%% Quadrotor Spinrate
if contains(flags,'s')
%     figure
    subplot(3,1,1)
    plot(t,state(:,10),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,10);state(:,11);state(:,12)]))-1,round(max([state(:,10);state(:,11);state(:,12)]))+1])
    xlabel('time [s]')
    ylabel('p [deg/s]')

    subplot(3,1,2)
    plot(t,state(:,11),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,10);state(:,11);state(:,12)]))-1,round(max([state(:,10);state(:,11);state(:,12)]))+1])
    xlabel('time [s]')
    ylabel('q [deg/s]')

    subplot(3,1,3)
    plot(t,state(:,12),opts.col,'LineWidth',0.8); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,10);state(:,11);state(:,12)]))-1,round(max([state(:,10);state(:,11);state(:,12)]))+1])
    xlabel('time [s]')
    ylabel('r [deg/s]')

%     sgtitle('Problem ' + opts.Problem + ': Spinrate Over Time')
end

%% Control Forces and Moments

if contains(flags,'c')
%     figure
    subplot(4,1,1)
    plot(t,force(:,3),opts.col,'LineWidth',1); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('Z_c [N]')

    subplot(4,1,2)
    plot(t,moment(1,:),opts.col,'LineWidth',1); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('L_c [Nm]')

    subplot(4,1,3)
    plot(t,moment(2,:),opts.col,'LineWidth',1); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('M_c [Nm]')
    
    subplot(4,1,4)
    plot(t,moment(3,:),opts.col,'LineWidth',1); hold on;
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('N_c [Nm]')

%     sgtitle('Problem ' + opts.Problem + ': Control Forces and Moments Over Time')
end

%% Motor Forces

if contains(flags,'m')
%     figure
Gain = 0.004; %Nm/rad/sec
force_z = ones([length(t), 1])*force(3);
moment = -1*state(:,10:12)*Gain;
motor = ComputeMotorForces(force_z(:,1), moment(:,1), moment(:,2), moment(:,3), params.r, params.k_m);

    subplot(4,1,1)
    plot(t,motor(:,1),opts.col,'LineWidth',2); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([min(motor,[], 'all'), max(motor,[], 'all')])
    xlabel('time [s]')
    ylabel('f1 [N]')

    subplot(4,1,2)
    plot(t,motor(:,2),opts.col,'LineWidth',2); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([min(motor, [],'all'), max(motor,[], 'all')])
    xlabel('time [s]')
    ylabel('f2 [N]')

    subplot(4,1,3)
    plot(t,motor(:,3),opts.col,'LineWidth',2); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([min(motor, [],'all'), max(motor,[], 'all')])
    xlabel('time [s]')
    ylabel('f3 [N]')
    
    subplot(4,1,4)
    plot(t,motor(:,4),opts.col,'LineWidth',2); hold on;
    grid on
    xlim([t(1),t(end)])
    ylim([min(motor, [],'all'), max(motor, [],'all')])
    xlabel('time [s]')
    ylabel('f4 [N]')

%     sgtitle('Problem ' + opts.Problem + ': Control Forces and Moments Over Time')
end

%% Quadrotor Overview

if contains(flags,'o')
    labels = ["x_E [m]","y_E [m]","z_E [m]","\phi [deg]","\theta [deg]","\psi [deg]","u^E [m/s]","v^E [m/s]","w^E [m/s]","p [deg/s]","q [deg/s]","r [deg/s]"];
    
%     figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
    colors = ["r","g","b","m","y","c","r","g","b","m","y","c"];
    for i = 1:12
        subplot(4,3,i)
        plot(t,state(:,i),opts.col,'LineWidth',0.8); hold on;
        if exist('opts','var') == 1 && isfield(opts,'Disturbance')
            xline(opts.Disturbance,'k--');
        end
        grid on
        xlim([t(1),t(end)])
        xlabel('time [s]')
        ylabel(labels(i))
    end
    
%     sgtitle('Problem ' + opts.Problem + ': Overview')
end

end
