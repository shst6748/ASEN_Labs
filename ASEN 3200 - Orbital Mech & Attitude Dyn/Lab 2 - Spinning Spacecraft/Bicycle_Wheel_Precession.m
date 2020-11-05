%Shawn Stone
%ASEN 3200 Lab 2 - Spinning Spacecraft
%Created 9/14/20
clc; clear all; close all;

%% Constants
diameter = 25.5; %[in]
R = diameter/2;
Cir = pi*diameter;
axle_length = 0.0254*7.5; %[m]
M = 2.59; %[kg]
g = 9.81; %[m/s^2]

mph = [35, 25, 20, 15]; %speedometer reading [mph]
spin_rate = (35.2*mph*pi)/Cir; %wheel spin rate [rad/s]

K = 0.0254*12; %[m] radius of gyration (estimated)
h = 0.0254*2; %[m] thickness of bicycle wheel (estimated)

I3 = M*K^2; %[kg*m^2]
I1 = (M/12)*(6*K^2 + h^2); %[kg*m^2]
% I1 = (M*K^2)/2; %[kg*m^2]

My = axle_length*M*g; %[Nm]
omegax = My ./ ((I1-I3)*spin_rate); %[rad/s]
period = (2*pi) ./ omegax*-1;


