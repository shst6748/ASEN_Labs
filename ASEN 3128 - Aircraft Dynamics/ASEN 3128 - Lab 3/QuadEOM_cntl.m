function [x_dot] = QuadEOM_cntl(t,x,f_cntl,m_cntl,opts)
%QUADEOM Function to solve for quadrotor motion.
%   Quadrotor system of equations of motion for translational and
%   rotational kinematics and dynamics.
%
%   Inputs:     t                 -   time vector [s] (Mx12 double)
%                   x                 -   state vector (Mx12 double)
%                   f_cntl            -   control forces [N] (3x1 double)
%                   m_cntl            -   control moments [N*m] (3x1 double)
%
%   Outputs:    x_dot             -   state vector derivatives (Mx12 double)
%
%   Author:                 Shawn Stone
%   Created:                10/1/2020
%   Last Edited:           10/8/2020
%   Purpose:                ASEN 3128 - Lab 3

%% Input arguments
arguments
    t double
    x double
    f_cntl (3,:) double
    m_cntl (3,:) double
    opts.IncludeDrag (1,1) logical = true
end

%% Quadrotor parameters and constants
params = Params();

%% State variables
% Translational kinematics
x_E = x(1); 
y_E = x(2); 
z_E = x(3);

% Rotational kinematics
phi = x(4);
theta = x(5);
psi = x(6);

% Translational dynamics
u_E = x(7);
v_E = x(8);
w_E = x(9);

% Rotational dynamics
p = x(10);
q = x(11);
r = x(12);

%% Forces and moments
% Control forces
X_c = f_cntl(1);
Y_c = f_cntl(2);
Z_c = f_cntl(3);

% Control moments
control_gain = 0.004; %Nm/rad/sec
L_c = -p*control_gain;
M_c = -q*control_gain;
N_c = -r*control_gain;

% Aerodynamic forces
if opts.IncludeDrag
    f_aero = -params.nu*norm([u_E,v_E,w_E])*[u_E; v_E; w_E];
    X = f_aero(1);
    Y = f_aero(2);
    Z = f_aero(3);
else
    X = 0;
    Y = 0;
    Z = 0;
end

% Aerodynamic moments
if opts.IncludeDrag
    m_aero = -params.mu*norm([p,q,r])*[p; q; r];
    L = m_aero(1);
    M = m_aero(2);
    N = m_aero(3);
else
    L = 0;
    M = 0;
    N = 0;
end

%% Translational Kinematics
R = [cos(theta)*cos(psi), sin(phi)*sin(theta)*cos(psi) - cos(phi)*sin(psi), cos(phi)*sin(theta)*cos(psi) + sin(phi)*sin(psi);
     cos(theta)*sin(psi), sin(phi)*sin(theta)*sin(psi) + cos(phi)*cos(psi), cos(phi)*sin(theta)*sin(psi) - sin(phi)*cos(psi);
     -sin(theta), sin(phi)*cos(theta), cos(phi)*cos(theta)];

tkin = [u_E; v_E; w_E];
tkin_dot = R*tkin;

x_E_dot = tkin_dot(1);
y_E_dot = tkin_dot(2);
z_E_dot = tkin_dot(3);

%% Rotational Kinematics
T = [1, sin(phi)*tan(theta), cos(phi)*tan(theta);
     0, cos(phi), -sin(phi);
     0, sin(phi)*sec(theta), cos(phi)*sec(theta)];

rkin = [p; q; r];
rkin_dot = T*rkin;

phi_dot = rkin_dot(1);
theta_dot = rkin_dot(2);
psi_dot = rkin_dot(3);

%% Translational Dynamics
tdyn_dot = [r*v_E - q*w_E; p*w_E - r*u_E; q*u_E - p*v_E] + params.g*[-sin(theta); cos(theta)*sin(phi); cos(theta)*cos(phi)] + 1/params.m*[X; Y; Z] + 1/params.m*[X_c; Y_c; Z_c];

u_E_dot = tdyn_dot(1);
v_E_dot = tdyn_dot(2);
w_E_dot = tdyn_dot(3);

%% Rotational Dynamics
rdyn_dot = [(params.I_y - params.I_z)/params.I_x*q*r; (params.I_z - params.I_x)/params.I_y*p*r; (params.I_x - params.I_y)/params.I_z*p*q] + [L/params.I_x; M/params.I_y; N/params.I_z] + [L_c/params.I_x; M_c/params.I_y; N_c/params.I_z];

p_dot = rdyn_dot(1);
q_dot = rdyn_dot(2);
r_dot = rdyn_dot(3);

%% Derivative State Vector
x_dot = [x_E_dot; y_E_dot; z_E_dot; phi_dot; theta_dot; psi_dot; u_E_dot; v_E_dot; w_E_dot; p_dot; q_dot; r_dot];
end