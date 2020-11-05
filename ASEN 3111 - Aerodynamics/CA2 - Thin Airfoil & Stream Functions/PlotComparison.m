function [] = PlotComparison(c, alpha, V_inf, P_inf, rho_inf, N, c_vec, alpha_vec, V_inf_vec)
%   PlotComparison - takes in the same variaables as PlotAirfoilFlow, however,
%   also includes three vectors for changing chord, AoA, and freestream
%   velocity. Loops through and calls PlotAirfoilFlow for calculating
%   streamlines, equipotential lines, and pressure contours for each element
%   of c_vec, alpha_vec, and V_inf_vec. In addition, plots each change as a
%   subplot, with overall figures grouped into streamlines, equipotential lines, and
%   pressure contours.
%
%   NOTE: Only works for c_vec, alpha_vec, and V_inf_vec of length 4
%   
%   Author: Shawn Stone
%   Contributors: N/A
%   Created: 10/8/20
%   Last Modified: 10/8/20


% Define Domain
xmin=-1;
xmax=3;
ymin=-2;
ymax=2;

% Define Number of Grid Points
nx=100; % steps in the x direction
ny=100; % steps in the y direction

% Create mesh over domain using number of grid points specified
[x,y]=meshgrid(linspace(xmin,xmax,nx),linspace(ymin,ymax,ny));

for i = 1:3
    figure()
    for k = 1:1:4
        [Psi, Phi, ~, P] = PlotAirfoilFlow(c_vec(k), alpha, V_inf, P_inf, rho_inf, N, 'no');
        
        if(i == 1)
            subplot(2, 2, k)
            contour(x,y,Psi,70); hold on;
            plot([0:0.1:c_vec(k)], zeros(size([0:0.1:c_vec(k)])), 'r','LineWidth', 2)
            title(sprintf('Streamlines (c = %.1d)',c_vec(k) ))
            colorbar;
        elseif(i == 2)
            subplot(2, 2, k)
            contour(x,y,Phi,70); hold on;
            plot([0:0.1:c_vec(k)], zeros(size([0:0.1:c_vec(k)])), 'r', 'LineWidth', 2)
            title(sprintf('Equipotential Lines (c = %.1d)', c_vec(k)))
            colorbar;
        elseif (i == 3)
            subplot(2, 2, k)
            contourf(x,y,P,70); hold on;
            plot([0:0.1:c_vec(k)], zeros(size([0:0.1:c_vec(k)])), 'r', 'LineWidth', 2)
            title(sprintf('Pressure Contours [Pa] (c = %.1d)', c_vec(k)))
            colorbar;
        end
    end
end

for i = 1:3
    figure()
    for k = 1:1:4
        [Psi, Phi, ~, P] = PlotAirfoilFlow(c, alpha_vec(k), V_inf, P_inf, rho_inf, N, 'no');
        
        if(i == 1)
            subplot(2, 2, k)
            contour(x,y,Psi,70); hold on;
            plot([0:0.1:c], zeros(size([0:0.1:c])), 'r','LineWidth', 2)
            title(sprintf('Streamlines (alpha = %.1d)', rad2deg(alpha_vec(k)) ))
            colorbar;
        elseif(i == 2)
            subplot(2, 2, k)
            contour(x,y,Phi,70); hold on;
            plot([0:0.1:c], zeros(size([0:0.1:c])), 'r', 'LineWidth', 2)
            title(sprintf('Equipotential Lines (alpha = %d)', rad2deg(alpha_vec(k)) ))
            colorbar;
        elseif (i == 3)
            subplot(2, 2, k)
            contourf(x,y,P,70); hold on;
            plot([0:0.1:c], zeros(size([0:0.1:c])), 'r', 'LineWidth', 2)
            title(sprintf('Pressure Contours [Pa] (alpha = %d)', rad2deg(alpha_vec(k)) ))
            colorbar;
        end
    end
end

for i = 1:3
    figure()
    for k = 1:1:4
        [Psi, Phi, ~, P] = PlotAirfoilFlow(c, alpha, V_inf_vec(k), P_inf, rho_inf, N, 'no');
        
        if(i == 1)
            subplot(2, 2, k)
            contour(x,y,Psi,70); hold on;
            plot([0:0.1:c], zeros(size([0:0.1:c])), 'r','LineWidth', 2)
            title(sprintf('Streamlines (V_{inf} = %.1d)', V_inf_vec(k) ))
            colorbar;
        elseif(i == 2)
            subplot(2, 2, k)
            contour(x,y,Phi,70); hold on;
            plot([0:0.1:c], zeros(size([0:0.1:c])), 'r', 'LineWidth', 2)
            title(sprintf('Equipotential Lines (V_{inf} = %.1d)', V_inf_vec(k)))
            colorbar;
        elseif (i == 3)
            subplot(2, 2, k)
            contourf(x,y,P,70); hold on;
            plot([0:0.1:c], zeros(size([0:0.1:c])), 'r', 'LineWidth', 2)
            title(sprintf('Pressure Contours (V_{inf} = %.1d)', V_inf_vec(k)))
            colorbar;
        end
    end
end

end

