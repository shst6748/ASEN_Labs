function x_dot = LinearQuadEOM(t,x,f_cntl,m_cntl,gains, opts)
%LinearQuadEOM Function to solve for quadrotor motion.
%   Uses linearized Quadrotor system of equations to simulate translational
%   and rotational dynamics.
%
%   Inputs: t - time vector [s] (Mx12 double)
%               x - state vector (Mx12 double)
%               f_cntl - control forces [N] (3x1 double)
%               m_cntl - control moments [N*m] (3x1 double)
%
%   Outputs: x_dot - state vector derivatives (Mx12 double)
%
%   Author:                 Shawn Stone
%   Created:                10/1/2020
%   Last Modified:        10/8/2020

%% Input arguments
arguments
    t double
    x double
    f_cntl (3,:) double
    m_cntl (3,:) double
    gains (2,:) double
    opts.IncludeDrag (1,1) logical = true
end

%% Quadrotor parameters and constants
params = Params();

%% Gains
Lab3_gain = 0.004;  %Nm/rad/sec

k1_roll = gains(1,1);
k2_roll = gains(1,2);

k1_pitch = gains(2,1);
k2_pitch = gains(2,2);

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
X_c_0 = f_cntl(1);
Y_c_0 = f_cntl(2);
Z_c_0 = f_cntl(3);

%Change in control forces
delta_X_c = 0;
delta_Y_c = 0;
delta_Z_c = 0;

% Control moments
L_c = m_cntl(1);
M_c = m_cntl(2);
N_c = -r*Lab3_gain;

%% Translational Motion
x_E_dot = u_E;
y_E_dot = v_E;
z_E_dot = w_E;

u_E_dot = -params.g * theta;
v_E_dot = params.g * phi;
w_E_dot = delta_Z_c / params.m;

%% Rotational Motion
phi_dot = p;
theta_dot = q;
psi_dot = r;

p_dot = (-k2_roll/params.I_x)*phi - (k1_roll/params.I_x)*p;
q_dot = (-k2_pitch/params.I_y)*theta - (k1_pitch/params.I_y)*q;
r_dot = N_c / params.I_z;

%% Output
x_dot = [x_E_dot; y_E_dot; z_E_dot; phi_dot; theta_dot; psi_dot; u_E_dot; v_E_dot; w_E_dot; p_dot; q_dot; r_dot];

end

