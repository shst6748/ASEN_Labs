%   Design Deliverable 02 - Range and Endurance of the Tempest UAS using
%   Theory
%
%   Author: Shawn Stone
%   Contributors: Quinn Lewis
%   Created: 11/1/20
%   Last Modified: 11/4/20
clear all; clc; close all;

%% Getting parameters and creating chord function
tp = Tempest_Parameters();

h = 1829; %[m] cruise height
V_inf = 19; %m/s 
[rho_inf, ~, ~, ~, mu_inf, ~, ~] = atmos(h);
q_inf = (1/2)*rho_inf*V_inf^2;

%Creating function of chord with respect to span (based on a half-ellipse)
N = 100;
x = linspace(tp.a_semi/N, tp.a_semi - tp.a_semi/N, N); %from fuselage to tip of right wing
c = (tp.b_semi/tp.a_semi)*sqrt( tp.a_semi^2 - x.^2); % height of half-ellipse

%% Calculation of Cd0: 1/4 chord transition
%This section calculated the Cd0 assuming a x_cr at 1/4 of the chord
%length

Re_x_cr = 5*10^5; %5*10^5 for a flat plate approximation
x_cr = (1/4).*c; %assuming a turbulent transition 1/4 of the way along the chord

CD0_qc = ParasiteDrag(c, x_cr, rho_inf, V_inf, mu_inf, Re_x_cr);

%% Calculation of Cd0: laminar flow
%The realistic calculation of x_cr (below) isn't used because with a flate
%plate reynold number of 5*10^5, x_cr is longer than the chord, meaning the
%wing is under laminar flow for the full length of chord
% x_cr = (mu_inf*Re_x_cr) / (rho_inf*V_inf);
x_cr = 1;
CD0_lam = ParasiteDrag(c, x_cr, rho_inf, V_inf, mu_inf, Re_x_cr);

%% Calculation of Cd0: turbulent flow
%This section is assuming a fully turbulent flow over the wing on top and
%bottom

x_cr = 0;
CD0_turb = ParasiteDrag(c, x_cr, rho_inf, V_inf, mu_inf, Re_x_cr);

%% Calculating k
%The main assumption is that the Tempest's Oswald efficiency factor, e, is
%1, based on the fact that its wing is semi-elliptical (and elliptical
%wings have e = 1)

e = 1;
k = 1/(pi*e*tp.AR);

%% Max Endurance

num = (tp.nu*tp.V*tp.C);
A = 2/sqrt(rho_inf*tp.S);
B = CD0^(1/4);
C = (2*tp.W_g.*sqrt(k./3)).^(3/2);
denom = A*B*C;

E_max = tp.Rt^(1-tp.n) .* (num ./ denom).^tp.n

%% Max Range

A = 1/sqrt(rho_inf*tp.S);
B = CD0^(1/4);
C = (2*tp.W_g.*sqrt(k)).^(3/2);
denom = A*B.*C;
Ur = sqrt( ((2*tp.W_g) / (rho_inf*tp.S)) .* sqrt(k./CD0) );

R_max = 3.6*tp.Rt^(1-tp.n) * (num / denom)^tp.n * Ur










