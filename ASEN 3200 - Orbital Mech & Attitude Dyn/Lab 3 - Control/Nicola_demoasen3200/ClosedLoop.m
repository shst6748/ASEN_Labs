function dx = ClosedLoop(t,x,A,B)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ASEN3200 - Spacecraft Attitude Dynamics
% dx = CloseLoop(t,x,A,B)
%
% Integrate the Closed-loop dynamics via MATLAB's ode.
% Input:
% - t       time
% - x       state
% - A       closed loop dynamics
% - B       input
%
% Author: Nicola Baresi
% Date: Feb, 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dx = A*x + B;

%% Equivalent of...
% tht_dd = -Kp/I * (tht - tht_des) - Kd/I * tht_d