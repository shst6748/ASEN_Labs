function [params] = Params()
%PARAMS Exports a structure of all quadrotor parameters and constants.
%
%   Inputs:     NONE
%
%   Outputs:    params            -   global parameters structure (1x1 struct)
%               Output2           -   short variable description [unit] (MxN type)
%
%   Author:     William Gravel
%   Created:    09/11/2020
%   Edited:     09/18/2020
%   Purpose:    ASEN 3128 - Lab 2

m = 0.068; % quadrotor mass [kg]
r = 0.06; % radial distance from CG to propeller [m]
k_m = 0.0024; % control moment coefficient [N*m/N]
I_x = 6.8e-5; % body x-axis moment of inertia [kg*m^2]
I_y = 9.2e-5; % body y-axis moment of inertia [kg*m^2]
I_z = 1.35e-4; % body z-axis moment of inertia [kg*m^2]
nu = 1e-3; % aerodynamic force coefficient [N/(m/s)^2]
mu = 2e-6; % aerodynamic moment coefficient [N*m/(rad/s)^2]
g = 9.81; % gravitational acceleration [m/s^2]

params = struct('m',m,'r',r,'k_m',k_m,'I_x',I_x,'I_y',I_y,'I_z',I_z,'nu',nu,'mu',mu,'g',g);
end
