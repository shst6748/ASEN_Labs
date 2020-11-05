function tp = Tempest_Parameters()
%Tempest_Parameters() - outputs struct of Tempest/TTwister UAS aircraft
%characteristics
%
%   Author: Shawn Stone
%   Contributors: N/A
%   Created: 10/12/20
%   Last Modified: 11/4/20

%Geometry and physical characteristics
h = 1829; %cruising altitude [m]
nu = 0.5; %overall propulsion effeciency
b = 3.22; %wingspan INCLUDING FUSELAGE
S = 0.63; %wing area
AR = 16.5; %aspect ratio
%airfoil = MH 32;
L = 1.56; %length [m]
W_e = 4.5*9.81; %empty weight [kg]
W_g = 6.4*9.81; %gross takeoff weight [N]
b_semi = 0.23; %semi-minor axis
a_semi = 1.53; %semi-major axis

%Battery characteristics
%type = 2 lithium polymer (Li-Po) battery packs
C = 18; %capacity for full system [Ah]
V = 26.1; %voltage for the full system [Volts]
Rt = 1; %rating in h
n = 1.3; %discharge parameter
m_bats = 2*984/1000; %battery pack mass [kg]
cur_max = 2*50; %2 motors with 50 amps per motor

tp = struct('h', h, 'nu', nu, 'b', b, 'S', S, 'AR', AR, 'L', L, 'W_e', W_e, 'W_g', W_g, 'C', C, 'V', V, 'Rt', Rt, 'n', n, ...
    'm_bats', m_bats, 'cur_max', cur_max, 'b_semi', b_semi, 'a_semi', a_semi);
end

