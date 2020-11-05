%   Computational Assignment 02 - Flow Over Thin Airfoils
%
%   Author: Shawn Stone
%   Contributors: Quinn Lewis
%   Created: 9/18/20
%   Last Modified: 10/8/20
clc; clear all; close all;

%% Bullet Point #1
c = 2; %[m]
alpha = deg2rad(12); %[rad]
V_inf = 68; % [m/s]
P_inf = 101.3*10^3; % [Pa]
rho_inf = 1.225; % [kg/m^3]
N = 100; 

PlotAirfoilFlow(c, alpha, V_inf, P_inf, rho_inf, N, 'y');

%% Error Analysis
%Finding expected/"correct" value for comparison
N = 10000;
[~, ~, V_expected, p_expected] = PlotAirfoilFlow(c, alpha, V_inf, P_inf, rho_inf, N, 'no');

%initializing variables
start = 10;
step = 10;
Total_N = 1000;

%initializing vectors of average percent error values
V_error = zeros(Total_N / step, 1); 
p_error = zeros(Total_N / step, 1);

for N = start:step:Total_N
    [~, ~, V, p] = PlotAirfoilFlow(c, alpha, V_inf, P_inf, rho_inf, N, 'n');
    
    %calculates the average percent error for all elements in Velociy and
    %Pressure fields
    V_error(N/step,1) = mean((abs(V - V_expected) ./ V_expected) .* 100, 'all'); 
    p_error(N/step,1) = mean((abs(p - p_expected) ./ p_expected) .* 100, 'all');
end

%plotting 
figure()
plot(start:step:Total_N, V_error, 'r', 'LineWidth', 2); hold on;
plot(start:step:Total_N, p_error, 'b', 'LineWidth', 2); 
title('Avg. Percent Error of Velocity & Pressure vs Number of Vorticies')
xlabel(sprintf('Number of Voriticies %d', Total_N))
ylabel('Avg. Percent Error')
legend('Velocity', 'Pressure')
hold off;
    
%% Changes in Chord Length, AoA, and V_inf
%redeclaring initial variables
c = 2;
alpha = deg2rad(12);
V_inf = 68;
P_inf = 101.3*10^3;
rho_inf = 1.225;
N = 100;

%Creating changing variable vectors
c_vec = 0.5:0.5:2;
alpha_vec = deg2rad(0:5:15);
V_inf_vec = 50:50:200;

PlotComparison(c, alpha, V_inf, P_inf, rho_inf, N, c_vec, alpha_vec, V_inf_vec)



