function [m_cntl] = force2moment(f_cntl)
%FORCE2MOMENT Computes quadrotor control moments from control forces.
%
%   Inputs:     f_cntl            -   control forces [N] (3x1 double)
%
%   Outputs:    m_cntl            -   control moments [N*m] (3x1 double)
%
%   Author:     William Gravel
%   Created:    09/23/2020
%   Edited:     09/23/2020
%   Purpose:    ASEN 3128 - Lab 2

params = Params();

f_1 = f_cntl(3)/4;
f_2 = f_cntl(3)/4;
f_3 = f_cntl(3)/4;
f_4 = f_cntl(3)/4;
m_cntl = [params.r/sqrt(2)*(-f_1 - f_2 + f_3 + f_4); params.r/sqrt(2)*(f_1 - f_2 - f_3 + f_4); params.k_m*(f_1 - f_2 + f_3 - f_4)];
end
