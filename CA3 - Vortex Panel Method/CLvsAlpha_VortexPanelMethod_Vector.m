function [] = CLvsAlpha_VortexPanelMethod_Vector(m,p,t,c,Nom_pts, V_inf, alpha, Airfoil)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Nominal_panels = Nom_pts*2-2;
CL = zeros(length(alpha), length(m));
figure('Units', 'Normalized', 'Position', [1/8, 1/8, 3/4, 3/4])
hold on
for j = 1:length(m)
    [x,y] = NACA_Airfoils(m(j), p(j), t(j), c, Nom_pts);
    for i = 1:length(alpha)
        [CL_tmp, ~] = VortexPanel(x, y, V_inf, alpha(i), length(x)-1);
        CL(i,j) = CL_tmp;
    end
    
    %Thin Airfoil Theory Slope and Intercept
    %Note: The slope (d_Cl/d_alpha) is 2*pi and intercept is the zero lift
    %angle of attack. The zero lift angle of attack is calculated using Eq.
    %4.61 in Anderson, which uses the equation for the camberline
    slope = 2*pi;
    if(p ~= 0)
        func1 = @(x) ( -(m(j).*x).*(3.*x - 4.*c.*p(j)) ./ (c.*p(j)) ) .* (2.*x./c);
        func2 = @(x) ( -(2.*m(j).*(x-c.*p(j))) ./ (c.*(p(j)-1).^2) ) .* (2.*x./c);
        int1 = (-2/pi)*integral(func1, 0, p(j));
        int2 = (-2/pi)*integral(func2, p(j), c);
        intercept = int1+int2;
    else
        func = @(x) ( -(2.*m(j).*(x-c.*p(j))) ./ (c.*(p(j)-1).^2) ) .* (2.*x./c);
        intercept = (-2/pi)*integral(func, p(j), c);
    end
    
    TAT_fit = [slope, intercept];
    TAT = polyval(TAT_fit, alpha);
    
    %Plotting
    plot(rad2deg(alpha), CL(:,j), 'LineWidth', 2)
    plot(rad2deg(alpha), TAT, 'b', 'LineWidth', 1)
    grid on
    xlabel('alpha (degrees)')
    ylabel('CL')
end
title(sprintf('CL vs alpha (%.1d panels)', Nominal_panels))
hold off
end

