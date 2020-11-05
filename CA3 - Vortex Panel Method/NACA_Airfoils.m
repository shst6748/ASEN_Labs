function [x,y] =  NACA_Airfoils(m,p,t,c,N)
%NACA_Airfoils reads in airfoil parameters listed below and outputs
%N number of boundary points for the given airfoil.
%
%INPUTS:
%   m  -  max camber
%   p   -  location of max camber
%   t    -  thickness
%   c    -  chord length
%   N   -  number of employed panels.
%
%OUTPUTS:
%   x   -  vector containing the x-location of the boundary points
%   y   -  vector containing the y-location of the boundary points

x = linspace(c,0,N);
y_t = (t/0.2)*c.*(0.2969.*sqrt(x./c) - 0.126.*(x./c) - 0.3516.*(x./c).^2 + 0.2843.*(x./c).^3 - 0.1036.*(x./c).^4);

y_c = zeros(1, length(x));
Xi = zeros(1,length(x));
for i = 1:N
    if (0 <= x(i) ) && (x(i) < p*c)
        y_c(i) = (m*x(i)/p^2)*(2*p - x(i)/c);
        Xi(i) = atan(-(m*x(i))*(3*x(i) - 4*c*p)/(c*p));
    elseif (p*c <= x(i) ) && (x(i) <= c)
        y_c(i) = m*( (c-x(i))/(1-p)^2 )*( 1 + x(i)/c - 2*p );
        Xi(i) = atan(-(2*m*(x(i)-c*p))/(c*(p-1)^2));
    end
end

x_u = x - y_t.*sin(Xi);
x_l = x + y_t.*sin(Xi);
x = [x_l(1:(end-1)), flip(x_u)]';

y_u = y_c + y_t.*cos(Xi);
y_l = y_c - y_t.*cos(Xi);
y = [y_l(1:(end-1)), flip(y_u)]';

end

