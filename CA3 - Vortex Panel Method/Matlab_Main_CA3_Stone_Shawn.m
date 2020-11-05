%   Computational Assignment 03 - Flow Over Thick Airfoils
%
%   Author: Shawn Stone
%   Contributors: Quinn Lewis, Tyler Gaston, Preston Tee
%   Created: 10/16/20
%   Last Modified: 10/23/20
clc; clear all; close all;
tic
%% Problem 1
%Kuthe and Chow data:
x = [1, 0.933, 0.750, 0.5, 0.25, 0.067, 0, 0.067, 0.250, 0.5, 0.75, 0.933,1];
y = [0, -0.005, -0.017, -0.033, -0.042, -0.033, 0, 0.045, 0.076, 0.072, 0.044, 0.013, 0];
V_inf = 60; %m/s
alpha = deg2rad(8);

[CL_Kuthe, Cp_Kuthe] = VortexPanel(x, y, V_inf, alpha, length(x)-1, 'airfoil', 'Kuthe and Chow Comparison, NACA 2412:', 'plot', 'true');

%% Problem 2: Error Study
fprintf('Problem 2: Error Study Calculating...\n')
%NACA 0012:
m = 0/100; p = 0/10; t = 12/100; c = 1;
V_inf = 60; %m/s
alpha = deg2rad(0);
percent_error = 0.5; %percent error to compute for

%Arbitrary high N value used for error analysis
N = 500; % (panels+2)/2 = points, i.e  1998 panels = 1000 points
[x,y] = NACA_Airfoils(m,p,t,c,N);
[CL_maxN, Cp_maxN] = VortexPanel(x, y, V_inf, alpha, length(x)-1);
Cp_avg_maxN = mean(Cp_maxN);

%Looping through until max N to compute error
N_max = 500/10;
N_vec = 10:10:N_max*10;
Cp_avg = zeros(N_max,1);
figure('Units', 'Normalized', 'Position', [1/8, 1/8, 3/4, 3/4])
hold on
for i = 1:N_max
    [x,y] = NACA_Airfoils(m,p,t,c,N_vec(i));
    [CL_tmp, Cp_tmp] = VortexPanel(x, y, V_inf, alpha, length(x)-1, 'airfoil', 'NACA 0012:', 'plot', 'N_loop');
    Cp_avg(i) = mean(Cp_tmp);
end
hold off

%Plotting the Percent Error of the Average Cp values vs increasing panel
%numbers
Cp_error = abs((Cp_avg - Cp_avg_maxN) ./ Cp_avg_maxN) .* 100;
figure('Units', 'Normalized', 'Position', [1/8, 1/8, 3/4, 3/4])
plot(N_vec*2-2, Cp_error, 'LineWidth', 2); hold on
yline(0.5, 'r--', 'LineWidth', 2); hold off
ylabel('% error for Avg Cp')
xlabel('Number of Panels')
title(sprintf('%s Percent Error of Average Cp vs Panel Number (\\alpha of %.1d\260)', 'NACA 0012:', rad2deg(alpha)))
legend('Percent Error', sprintf('%.1d%% error bound', percent_error))

%Finding nominal nummber of panels based on the first index below the
%desired error bound
Nom_pts = N_vec(find(Cp_error <= percent_error, 1));
Nominal_panels = N_vec(find(Cp_error <= percent_error, 1))*2-2;
fprintf('Nominal number of panels for %.1d %% percent error is: %u\n\n', percent_error, Nominal_panels)


%% Problem 2: NACA 0012 Airfoil for alpha = -5, 0, 5, 10, 15
fprintf('Problem 2: NACA 0012 Cp for changing alpha is calculating...\n\n')

%NACA 0012:
m = 0/100; p = 0/10; t = 12/100; c = 1;
V_inf = 60; %m/s
alpha = deg2rad(-5:5:15);
[x,y] = NACA_Airfoils(m,p,t,c,Nom_pts);

figure('Units', 'Normalized', 'Position', [1/8, 1/8, 3/4, 3/4])
hold on
for i = 1:length(alpha)
    [CL_tmp, Cp_tmp] = VortexPanel(x, y, V_inf, alpha(i), length(x)-1, 'airfoil', 'NACA 0012:', 'plot', 'alpha_loop');
    CL_p2(i) = CL_tmp;
end
legend('-5\circ', '0\circ', '5\circ', '10\circ', '15\circ')
hold off

%% Problem 3: CL vs alpha for NACA 0012, 2412, 4412, and 2424
fprintf('Problem 3: CL vs alpha comparisons:\n')

%NACA 0012:
m = [0/100, 2/100, 4/100, 2/100]; 
p = [0/10, 4/10, 4/10, 4/10]; 
t = [12/100, 12/100, 12/100, 24/100]; 
c = 1;
V_inf = 60; %m/s
alpha = deg2rad(-5:1:15);
Airfoil_List = {'NACA 0012', 'NACA 2412' 'NACA 4412' 'NACA 2424'};

for i = 1:length(m)
    [VPM, TAT] = CLvsAlpha_VortexPanelMethod(m(i),p(i),t(i),c,Nom_pts, V_inf, alpha, Airfoil_List{i});
    fprintf('%s  airfoil:\n   Vortex Panel slope: %.4d, Thin Airfoil Theory slope: %.4d\n   Vortex Panel zero lift alpha: %.4d\260, Thin Airfoil Theory zero lift alpha: %.4d\260\n\n', Airfoil_List{i}, VPM(1), TAT(1), VPM(2), TAT(2))
end

toc