function motor_forces = ComputeMotorForces(Zc, Lc, Mc, Nc, R, km)
%FUNCTION DESCRIPTION
%
%
force_matrix = [-1 -1 -1 -1; -R/sqrt(2) -R/sqrt(2) R/sqrt(2) R/sqrt(2); R/sqrt(2) -R/sqrt(2) -R/sqrt(2) R/sqrt(2); km -km km -km];
control_moments = [Zc, Lc, Mc, Nc]';
motor_forces = (force_matrix \ control_moments)';
end






