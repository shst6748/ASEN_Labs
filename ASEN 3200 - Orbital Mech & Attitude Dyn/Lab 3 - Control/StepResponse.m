%Shawn Stone
%ASEN 3200 - Lab A-3 - Spacecraft Pitch Axis Control
%Created 10/17/20
clc; clear all; close all;

I = 0.0064; %[kg*m^2]
Kp = 0.0735; % [Nm/rad]
Kd = 0.0256; %[Nm/rad/s]

ts = 1.5; 
percent_settle = 5;
percent_over = 10;
amp = 0.5;

t = [0:0.01:5]';
nt = length(t);
one = ones(nt,1);

opt = stepDataOptions('StepAmplitude', amp);
sys = tf(Kp/I, [1 Kd/I Kp/I]);
y = step(sys,t, opt);

%Generates step response plot with overshoot bounds for analysis
%question 1 in lab document, based on derived control gains & moment of
%inertia
figure('Units', 'Normalized', 'Position', [1/8, 1/8, 3/4, 3/4])
hold on
plot(t,y, 'LineWidth', 2)
plot(t,amp*[one one]+percent_settle/100*one*[amp -amp],'k--' , 'LineWidth', 2)
plot(t,amp*[one one]+percent_over/100*one*[amp -amp],'r--' , 'LineWidth', 2)
grid on
xlabel('time (s)', 'FontSize', 14)
ylabel('theta (rad)', 'FontSize', 14)
title('Expected Step Response vs Time', 'FontSize', 14)
legend('response', '+5% settling bound', '-5% settling bound', '+10% overshoot', '-10% undershoot', 'Location', 'SouthEast', 'FontSize', 14)

