function [VPM_fit, TAT_fit] = CLvsAlpha_VortexPanelMethod(m,p,t,c,Nom_pts, V_inf, alpha, Airfoil)
%CLvsAlpha_VortexPanelMethod - calculates and plots Cl vs alpha graphs
%using both Vortex Panel Method (VPM) and Thin Airfoil Theory (TAT)
% 
% INPUTS:
%   m  -  max camber
%   p   -  location of max camber
%   t    -  thickness
%   c    -  chord length
%   Nom_pts   -  nominal number of points to be used in NACA_Airfoils for
%       an accurate estimation
%   V_inf - freestream velocity
%   alpha - angle of attack
%   Airfoil - name of the airfoil being used
% 
% OUTPUTS:
%   VPM_fit   -  vector containing slope and intercept of CL vs alpha graph
%       from Vortex Panel Method (VPM)
%   TAT_fit   -  vector containing slope and intercept of CL vs alpha graph
%       from Thin Airfoil Theory (TAT)

Nominal_panels = Nom_pts*2-2; %converts from the points used in NACA_Airfoils to number of panels
CL = zeros(length(alpha), 1);

[x,y] = NACA_Airfoils(m, p, t, c, Nom_pts);
for i = 1:length(alpha)
    [CL_tmp, ~] = VortexPanel(x, y, V_inf, alpha(i), length(x)-1);
    CL(i) = CL_tmp;
end

%Thin Airfoil Theory Slope and Intercept
%Note: The slope (d_Cl/d_alpha) is 2*pi and intercept is the zero lift
%angle of attack. The zero lift angle of attack is calculated using Eq.
%4.61 in Anderson, which uses the equation for the camberline
slope = 2*pi;
if(p ~= 0)
    func1 = @(x) ( -(m.*x).*(3.*x - 4.*c.*p) ./ (c.*p) ) .* (2.*x./c);
    func2 = @(x) ( -(2.*m.*(x-c.*p)) ./ (c.*(p-1).^2) ) .* (2.*x./c);
    int1 = (-2/pi)*integral(func1, 0, p);
    int2 = (-2/pi)*integral(func2, p, c);
    intercept = int1+int2;
else
    func = @(x) ( -(2.*m.*(x-c.*p)) ./ (c.*(p-1).^2) ) .* (2.*x./c);
    intercept = (-2/pi)*integral(func, 0, c);
end

TAT_fit = [slope, intercept];
TAT = polyval(TAT_fit, alpha);

%Finding slope and intercepts of vortex panel method CL vs alpha
VPM_fit = polyfit(alpha, CL, 1);

%Plotting
figure('Units', 'Normalized', 'Position', [1/8, 1/8, 3/4, 3/4])
hold on
plot(rad2deg(alpha), CL, 'r', 'LineWidth', 2)
plot(rad2deg(alpha), TAT, 'b', 'LineWidth', 2)
grid on
yline(0, 'k--', 'LineWidth', 2)
xlabel('alpha (degrees)')
ylabel('CL')
title(sprintf('Problem 3: %s: CL vs alpha (%.1d panels)', Airfoil, Nominal_panels))
legend('Vortex Panel Method', 'Thin Airfoil Theory')
hold off

end

