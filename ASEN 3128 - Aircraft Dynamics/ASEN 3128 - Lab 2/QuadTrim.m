function [init,f_cntl,m_cntl] = QuadTrim(x_E_dot,y_E_dot,z_E_dot,psi_val)
%QUADTRIM Calculate quadrotor trim conditions for given velocity and yaw.
%   Numerically solves system of equations for quadrotor roll angle, pitch angle, and
%   control force.
%
%   Inputs:     x_E_dot           -   inertial North velocity [m/s] (1x1 double)
%               y_E_dot           -   inertial East velocity [m/s] (1x1 double)
%               z_E_dot           -   inertial down velocity [m/s] (1x1 double)
%               psi_val           -   yaw angle [rad] (1x1 double)
%
%   Outputs:    init              -   initial state vector (12x1 double)
%               f_cntl            -   control forces [N] (3x1 double)
%               m_cntl            -   control moments [N*m] (3x1 double)
%
%   Author:     William Gravel
%   Created:    09/17/2020
%   Edited:     09/23/2020
%   Purpose:    ASEN 3128 - Lab 2

%% Function setup
syms phi theta psi_sym Z_c 
warning('off','all')
digits(128)

params = Params();

%% Rotation matrix
R_1 = @(X) [1, 0, 0; 0, cos(X), sin(X); 0, -sin(X), cos(X)];
R_2 = @(X) [cos(X), 0, -sin(X); 0, 1, 0; sin(X), 0, cos(X)];
R_3 = @(X) [cos(X), sin(X), 0; -sin(X), cos(X), 0; 0, 0, 1];

R_B_E = R_3(-psi_sym)*R_2(-theta)*R_1(-phi); % body to inertial rotation matrix
R_E_B = R_B_E.'; % inertial to body rotation matrix

%% Velocity variables
V_E_E = [x_E_dot; y_E_dot; z_E_dot]; % inertial velocity in inertial coordinates
V_E_B = R_E_B*V_E_E; % inertial velocity in body coordinates
disp(V_E_B)
disp(subs(V_E_B,psi_sym,0))

%% System of equations
f_aero = -params.nu*norm(V_E_B)*V_E_B;
f_grav = R_E_B*[0; 0; params.m*params.g];
f_cntl = [0; 0; Z_c];

f_total = f_aero + f_grav + f_cntl;

S = vpasolve(subs(f_total,psi_sym,psi_val),[phi,theta,Z_c],[-pi,pi; -pi,pi; -10,10]);

%% Solutions substitutions
f_cntl = double(subs(f_cntl,Z_c,S.Z_c));
m_cntl = force2moment(f_cntl);

V_E_B = double(subs(V_E_B,[phi,theta,psi_sym],[S.phi,S.theta,psi_val]));
u_E = V_E_B(1);
v_E = V_E_B(2);
w_E = V_E_B(3);

init = [0; 0; -20; double(S.phi); double(S.theta); psi_val; u_E; v_E; w_E; 0; 0; 0];

end
