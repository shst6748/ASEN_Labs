function [PSI, PHI, V, Pressure] = PlotAirfoilFlow(c, alpha, V_inf, P_inf, rho_inf, N, plot_logical)
%PlotAirfoilFlow - calculates and plots (plotting optional) the resulting
%streamlies, equipotential lines, and pressure contours of the
%superposition of uniform flow velocity and discrete vorticies N along
%chord length c
%
%   c = chord length
%   a = angle of attack [rad]
%   V_inf = freestream velocity
%   P_inf = freestream pressure
%   rho_inf = freestream density
%   N = number of discrete vorticies
%   plot_logical = used to determine whether or not to plot the resulting
%   streamlines, equipotential lines, and pressure contours. 
%   'y' means yes, any other character/string means no.
%
%   NOTE: angle of attack is used to orient the incoming flow relative to
%   the chord line, NOT to angle the chord line relative to the flow.
%
%   Author: Shawn Stone
%   Contributors: Quinn Lewis
%   Created: 9/18/20
%   Last Modified: 10/8/20

%% Define Domain
xmin=-1;
xmax=3;
ymin=-2;
ymax=2;

%% Define Number of Grid Points
nx=100; % steps in the x direction
ny=100; % steps in the y direction

%% Create mesh over domain using number of grid points specified
[x,y]=meshgrid(linspace(xmin,xmax,nx),linspace(ymin,ymax,ny));
 
%% Initializing
%Setting up constants, chord line of the airfoil, and calculating Gamma
%along the chord
delx = c/N;
ychord = zeros(1, N);
xchord = linspace(delx/2, c - delx/2, N);
gamma = (2*alpha*V_inf).*sqrt(  (1- xchord./c)./(xchord./c) );
Gamma = gamma.*delx;

%Initializing stream function based on uniform fllow
Psi_uf = V_inf*cos(alpha)*y - V_inf*sin(alpha)*x;
PSI = Psi_uf;

%Initializing velocity potential based on uniform flow
Phi_uf = V_inf*cos(alpha)*x + V_inf*sin(alpha)*y;
PHI = Phi_uf;

%Initializing velocity based on freestream velocity
u = V_inf*cos(alpha);
v = V_inf*sin(alpha);
%% Calculating
for i = 1:N
    [Psi_vf, Phi_vf, u_vf, v_vf] = vortex(x, y, xchord(i), ychord(i), Gamma(i));
    PSI = PSI + Psi_vf; %adds each vortex contribution to initial (uniform) stream function
    PHI = PHI + Phi_vf;%adds each vortex contribution to initial (uniform) velocity potential
    u = u + u_vf;
    v = v + v_vf;
end
V = sqrt(u.^2 + v.^2);
Cp = 1 - (V ./ V_inf).^2; %coefficient of pressure equation
Pressure = P_inf + (1/2 * rho_inf * V_inf^2).*Cp; %Bernoulli's equation

%% Determine color levels for contours
% levmin_psi = PSI(1,nx); % defines the color levels -> trial and error to find a good representation
% levmax_psi = PSI(ny,nx/2);
% levels_psi = linspace(levmin_psi,levmax_psi,line_num);

%% Plot streamfunction at levels
line_num = 70;

if (plot_logical == "y")
    figure()
    contour(x,y,PSI,line_num); hold on;
    plot([0:c], zeros(size([0:c])), 'k','LineWidth', 2)
    title(sprintf('Part 1: Streamlines (N = %d)', N))
    hold off
    
    figure()
    contour(x,y,PHI,line_num); hold on;
    plot([0:c], zeros(size([0:c])), 'k', 'LineWidth', 2)
    title(sprintf('Part 1: Equipotential Lines (N = %d)', N))
    hold off
    
    figure()
    contourf(x,y,Pressure,line_num); hold on;
    plot([0:c], zeros(size([0:c])), 'k', 'LineWidth', 2)
    title(sprintf('Part 1: Pressure Contours (N = %d)', N))
    hold off
end
end
