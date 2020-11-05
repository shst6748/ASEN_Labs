%   Design Deliverable 01 - Range and Endurance of the Tempest UAS
%
%   Author: Shawn Stone
%   Contributors: Quinn Lewis
%   Created: 10/12/20
%   Last Modified: 10/12/20
clear all; clc; close all;

%% Constants
const = Constants(); %creates struct of constants

%function atmoscoesa() to find density at given altitude
[~, ~, ~, rho] = atmoscoesa(const.h); %rho in [kg/m^3]

%% Reading Data
CFD = readmatrix('3111 DD#1 CFD.csv');
alpha = CFD(:,1);
CL = CFD(:,2);
CD = CFD(:,3);

%% Computing alpha at zero lift
%fitting the curve
polynomials_CL = polyfit(alpha(1:15), CL(1:15), 1);
f_CL = polyval(polynomials_CL, alpha(1:15));

%finding alpha (CD_0 occurs at zero lift AoA)
alpha_zero = roots(polynomials_CL);

figure('Name', 'CLvAlpha', 'Units','Normalized','Position',[1/8 1/8 3/4 3/4])
plot(alpha, CL, 'k', 'LineWidth', 2); hold on;
plot(alpha(1:15), f_CL, 'r--', 'LineWidth', 2); hold off;
xline(alpha_zero, 'b:', 'LineWidth', 2)
grid on
xlabel('\alpha (degrees)', 'FontSize', 16)
ylabel('CL', 'FontSize', 16)
title('CL vs Angle of Attack, \alpha', 'FontSize', 16)
legend({'raw data', 'linear regression', 'alpha at zero lift'}, 'FontSize', 16, 'Location', 'SouthEast')

%% Computing CD0

%fitting the curve
polynomials_CD = polyfit(alpha, CD, 5);
f_CD = polyval(polynomials_CD, alpha);

%Finding CD0 by indexing the polyfit at the zero lift angle of attack
CD0 = polyval(polynomials_CD, alpha_zero)

figure('Name', 'CDvAlpha', 'Units','Normalized','Position',[1/8 1/8 3/4 3/4])
plot(alpha, CD, 'k', 'LineWidth', 2); hold on;
plot(alpha, f_CD, 'r--', 'LineWidth', 2); hold off;
xlabel('\alpha (degrees)', 'FontSize', 16)
ylabel('CD', 'FontSize', 16)
title('CD vs Angle of Attack, \alpha', 'FontSize', 16)
legend({'raw data', '5th order polynomial fit'}, 'FontSize', 16, 'Location', 'NorthWest')


%% Computing k
%adjusting CL and CD data to exclude stall and negative values
CLsquared_adj = CL(4:14).^2;
CD_adj = CD(4:14);

%fitting the curve
polynomials_k = polyfit(CLsquared_adj, CD_adj, 1);
f_k = polyval(polynomials_k, CLsquared_adj);

k = polynomials_k(1) %k is the slope of CD vs CL^2
% CD0_2 = polynomials_k(2)

%variable for plotting the raw data
CLsquared = CL.^2;

figure('Name', 'CDvCLsquared', 'Units','Normalized','Position',[1/8 1/8 3/4 3/4])
plot(CLsquared_adj, f_k, 'r--', 'LineWidth', 2); hold on;
plot(CLsquared_adj, CD_adj, 'k', 'LineWidth', 2); 
plot(CLsquared, CD, 'k:', 'LineWidth', 2); hold off;
xlabel('CL^2', 'FontSize', 16)
ylabel('CD', 'FontSize', 16)
title('CD vs CL^2', 'FontSize', 16)
legend({'linear regression', 'trimmed data', 'raw data'}, 'FontSize', 16, 'Location', 'NorthWest')

%% Max Endurance

num = (const.nu*const.V*const.C);
A = 2/sqrt(rho*const.S);
B = CD0^(1/4);
C = (2*const.W_g.*sqrt(k./3)).^(3/2);
denom = A*B*C;

E_max = const.Rt^(1-const.n) .* (num ./ denom).^const.n

%% Max Range

A = 1/sqrt(rho*const.S);
B = CD0^(1/4);
C = (2*const.W_g.*sqrt(k)).^(3/2);
denom = A*B.*C;
Ur = sqrt( ((2*const.W_g) / (rho*const.S)) .* sqrt(k./CD0) );

R_max = 3.6*const.Rt^(1-const.n) * (num / denom)^const.n * Ur


%% Functions

function const = Constants()
%Params - outputs struct of constants
%
%   Author: Shawn Stone
%   Contributors: N/A
%   Created: 10/12/20
%   Last Modified: 10/12/20

%Geometry and physical characteristics
h = 1829; %cruising altitude [m]
nu = 0.5; %overall propulsion effeciency
b = 3.22; %wingspan
S = 0.63; %wing area
AR = 16.5; %aspect ratio
%airfoil = MH 32;
L = 1.56; %length [m]
W_e = 4.5*9.81; %empty weight [kg]
W_g = 6.4*9.81; %gross takeoff weight [N]

%Battery characteristics
%type = 2 lithium polymer (Li-Po) battery packs
C = 18; %capacity for full system [Ah]
V = 26.1; %voltage for the full system [Volts]
Rt = 1; %rating in h
n = 1.3; %discharge parameter
m_bats = 2*984/1000; %battery pack mass [kg]
cur_max = 2*50; %2 motors with 50 amps per motor

const = struct('h', h, 'nu', nu, 'b', b, 'S', S, 'AR', AR, 'L', L, 'W_e', W_e, 'W_g', W_g, 'C', C, 'V', V, 'Rt', Rt, 'n', n, 'm_bats', m_bats, 'cur_max', cur_max);
end


