function [Psi, Phi, u, v] = vortex(x, y, x_v, y_v, Gamma)
%   vortex - calculates streamfunctions, velocity potentials, and
%   components of velocity for each individual vortex location input
%
%   Inputs: mesh grid (x, y), vortex location along airfoil (x_v, y_v), and
%   strength of vortex (Gamma)
%   
%   Outputs: streamfunction, velocity potential, horizontal velocity, and
%   vertical velocity
%
%   Author: Shawn Stone
%   Contributors: Quinn Lewis
%   Created: 9/29/20
%   Last Modified: 10/8/20

r = sqrt((x - x_v).^2 + (y - y_v).^2);
theta = atan2(-(y - y_v) ,-(x - x_v));

Psi = (Gamma / (2*pi)) * log(r);
Phi = -(Gamma) / (2*pi) * theta;

u = (Gamma*(y-y_v)) ./ (2*pi.*r.^2);
v = (-Gamma*(x-x_v)) ./ (2*pi.*r.^2);
end

