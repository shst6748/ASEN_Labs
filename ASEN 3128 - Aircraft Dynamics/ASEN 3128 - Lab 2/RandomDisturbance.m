function [f_cntl,m_cntl] = RandomDisturbance(f_cntl,m_cntl)
%RANDOMDISTURBANCE Applies a random disturbance one of the control inputs.
%
%   Notes:      - Disturbance applied to a single, randomly-determined component
%
%   Inputs:     f_cntl            -   control forces [N] (3x1 double)
%               m_cntl            -   control moments [N*m] (3x1 double)
%
%   Outputs:    f_cntl            -   new control forces [N] (3x1 double)
%               m_cntl            -   new control moments [N*m] (3x1 double)
%
%   Author:     William Gravel
%   Created:    09/23/2020
%   Edited:     09/24/2020
%   Purpose:    ASEN 3128 - Lab 2

randVar = randi(4);
randVal = rand()/100 - 0.005;

if randVar == 1
    f_cntl(3) = f_cntl(3) + randVal;
    fprintf('Random disturbance of %.3e [N] applied to Z_c\n',randVal)
elseif randVar == 2
    m_cntl(1) = m_cntl(1) + randVal;
    fprintf('Random disturbance of %.3e [N*m] applied to L_c\n',randVal)
elseif randVar == 3
    m_cntl(2) = m_cntl(2) + randVal;
    fprintf('Random disturbance of %.3e [N*m] applied to M_c\n',randVal)
elseif randVar == 4
    m_cntl(3) = m_cntl(3) + randVal;
    fprintf('Random disturbance of %.3e [N*m] applied to N_c\n',randVal)
end

