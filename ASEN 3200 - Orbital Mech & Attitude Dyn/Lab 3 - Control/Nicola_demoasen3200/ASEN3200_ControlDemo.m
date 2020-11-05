%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ASEN3200 - Spacecraft Attitude Dynamics
% PD Controller Demo
%
% Author: Nicola Baresi
% Date: Feb, 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc; format longG;
set(0,'DefaultTextInterpreter','Latex');
set(0,'DefaultAxesFontsize',16);


%% S/C Data
I = 0.0064;               % Moment of inertia about z-axis (kg * m^2)
 
%% Reference Input
THT_des    = 30 * pi / 180;     % (rad)
THTdot_des = 0;                 % (rad/s)

%% Pick your Gain
% Kp = 5, Kd = 3;
% Kp = 5, Kd = -3;
% Kp = 1, Kd = 50;

% Kp = 1, Kd = 2*sqrt(I * Kp)
% Kp = 1, Kd = 20;
 Kp = 0.2, Kd = 0.003; %2*sqrt(I * Kp)- 10;

% undamped natural frequency & epsilon values
wn      = sqrt(Kp/I);
zeta    = Kd/(2*I*wn);

%% Closed-loop system - Review state space models
Acl     = [0, 1; - Kp / I, - Kd / I];
Bcl     = [0; Kp * THT_des / I];
Ccl     = [1, 0];

%% Integrate Trajectory using state space model
time    = 0:1:60;
Ic      = [0; 0];
opt     = odeset('RelTol',3e-14,'AbsTol',1e-16);
[t,x]   = ode45(@ClosedLoop,time,Ic,opt,Acl,Bcl);

% Output
y       = (Ccl*x')';

% Control 
u       = -Kp * (x(:,1)  - THT_des) - Kd * x(:,2); 
u_max   = max(u)
u_min   = min(u)


%% Plots
figure('units','normalized','outerposition',[.1 .1 0.8 0.8])
for tt = 1:length(t)
    
    subplot(3,2,[1,3,5]);
    % Plot Satellite
    sat = PlotSatellite();
    rotate(sat,[0,0,1], y(tt) * 180/pi);
    
    % Principal Axes of Satellite
    cn = cos(y(tt));
    sn = sin(y(tt));
    cn_des = cos(THT_des);
    sn_des = sin(THT_des);
    quiver3(0,0,0,3*cn,3*sn,0,'r','Linewidth',2); text(3*cn+0.01,3*sn+0.01,0,'$\hat{i}$','color','r');
    quiver3(0,0,0,-3*sn,3*cn,0,'r','Linewidth',2); text(-3*sn-0.01,3*cn-0.01,0,'$\hat{j}$','color','r');
    quiver3(0,0,0,3*cn_des,3*sn_des,0,'b','Linewidth',2); text(3*cn_des,3*sn_des,0,'$\hat{\theta}_d$','color','b');
    
    % Axes of Inertial frame
    quiver3(0,0,0,3,0,0,'k','Linewidth',1); text(3,0,0,'$\hat{X}$');
    quiver3(0,0,0,0,3,0,'k','Linewidth',1); text(0,3,0,'$\hat{Y}$');
    quiver3(0,0,0,0,0,2,'k','Linewidth',1); text(0,0,2.1,'$\hat{k} // \hat{Z}$');
    axis equal;
    xlim([-4,4]);
    ylim([-4,4]);
    zlim([-2,2.5]);
    xlabel('$x$ (-)');
    ylabel('$y$ (-)');
    zlabel('$z$ (-)');
    view([120,30]);
    hold off;
    
    subplot(3,2,2);
    plot(t(1:tt),x(1:tt,1)*180/pi,'r','Linewidth',1); hold on;
    plot(time,THT_des*ones(size(time))*180/pi,'b--','Linewidth',1);
    text(time(end-20),THT_des*180/pi + max(abs(x(:,1)))*180/pi*0.1,'$\theta_d$','Fontsize',16,'color','b');
    xlabel('$t$ (s)');
    ylabel('$\theta(t)$ (deg)');
    % lgd = legend('$\theta(t)$','$\theta_d$'); lgd.Interpreter = 'latex';
    xlim([time(1),time(end)]);
    ylim([-abs(THT_des), abs(THT_des)]*360/pi);
    % ylim([-pi, pi]*360/pi);
    hold off;
    
    subplot(3,2,4);
    plot(t(1:tt),x(1:tt,2)*180/pi,'r','Linewidth',1); hold on;
    plot(time,THT_des*zeros(size(time))*180/pi,'b--','Linewidth',1);
    text(time(end-20),THTdot_des + max(abs(x(:,2)))*180/pi*0.3,'$\dot{\theta}_d$','Fontsize',16,'color','b');
    xlabel('$t$ (s)');
    ylabel('$\dot{\theta}(t)$ (deg/s)');
    % lgd = legend('$\dot{\theta}(t)$','$\dot{\theta}_d$'); lgd.Interpreter = 'latex';
    xlim([time(1),time(end)]);
    ylim([-max(abs(x(:,2)))*360/pi, max(abs(x(:,2)))*360/pi]);
    hold off;
    
    subplot(3,2,6);
    plot(t(1:tt),u(1:tt),'k','Linewidth',1); hold on;
    plot(time,zeros(size(time)),'--k','Linewidth',1);
    xlabel('$t$ (s)');
    ylabel('$u$ (N m)');
    xlim([time(1),time(end)]);
    ylim([2*u_min, 2*u_max]);
    hold off;
    drawnow;
end

