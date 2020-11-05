function [CL, Cp] = VortexPanel( XB, YB, V_inf, alpha, M, opts)
%VortexPanel is a function adapted from the Kuthe and Chow Vortex Panel
%method code written in FORTRAN
% 
% INPUTS:
%   XB    -  x component of boundary points (normally input from the output
%       of NACA_Airfoils function)
%   YB    -  y component of boundary points (normally input from the output
%       of NACA_Airfoils function)
%   V_inf - freestream velocity
%   alpha - angle of attack
%   M    -  number of panels
%   opts  - plotting options
% 
% OUTPUTS:
%   VPM_fit   -  vector containing slope and intercept of CL vs alpha graph
%   from Vortex Panel Method (VPM)
%   TAT_fit   -  vector containing slope and intercept of CL vs alpha graph
%   from Thin Airfoil Theory (TAT)

arguments
    XB (:,:) double
    YB (:,:) double
    V_inf (1,1) double
    alpha (1,1) double
    M (1,1) double
    opts.airfoil (1,1) string
    opts.plot (1,1) string = 'false'
end

%Preallocating vectors
X = zeros(M,1); Y = zeros(M,1); S = zeros(M,1);
sine = zeros(M,1); cosine = zeros(M,1); theta = zeros(M,1);
V = zeros(M,1); Cp = zeros(M,1); RHS = zeros(M,1); 

Cn1 = zeros(M); Cn2 = zeros(M); Ct1 = zeros(M); 
Ct2 = zeros(M); An = zeros(M+1); At = zeros(M,M+1); 

for i = 1:M
    X(i) = 0.5*(XB(i)+XB(i+1));
    Y(i) = 0.5*(YB(i)+YB(i+1));
    S(i) = sqrt( (XB(i+1)-XB(i))^2 + (YB(i+1)-YB(i))^2 );
    theta(i) = atan2( (YB(i+1)-YB(i)), (XB(i+1)-XB(i)));
    sine(i) = sin( theta(i) );
    cosine(i) = cos( theta(i) );
    RHS(i) = sin( theta(i) - alpha);
end

for i = 1:M
    for j = 1:M
        if( i == j )
            Cn1(i,j) = -1;
            Cn2(i,j) = 1;
            Ct1(i,j) = pi/2;
            Ct2(i,j) = pi/2;
        else
            A = -( X(i) - XB(j) )*cosine(j) - ( Y(i)-YB(j) )*sine(j);
            B = ( X(i)-XB(j) )^2 + ( Y(i)-YB(j) )^2;
            C = sin( theta(i) - theta(j) );
            D = cos( theta(i) - theta(j) );
            E = ( X(i) - XB(j) )*sine(j) - ( Y(i)-YB(j) )*cosine(j);
            F = log( 1+S(j)*( S(j)+2*A )/B );
            G = atan2( E*S(j) , B + A*S(j) );
            P = ( X(i) - XB(j) )*sin( theta(i) - 2*theta(j) ) ...
               + ( Y(i) - YB(j) )*cos( theta(i) - 2*theta(j) );
            Q = ( X(i) - XB(j) )*cos( theta(i) - 2*theta(j) ) ...
                 - ( Y(i) - YB(j) )*sin( theta(i) - 2*theta(j) );
            Cn2(i,j) = D + 0.5*Q*F/S(j) - (A*C + D*E)*G/S(j);
            Cn1(i,j) = 0.5*D*F + C*G - Cn2(i,j);
            Ct2(i,j) = C + 0.5*P*F/S(j) + (A*D - C*E)*G/S(j);
            Ct1(i,j) = 0.5*C*F - D*G - Ct2(i,j);
        end
    end
end

%Computing "influence coefficients"
for i = 1:M
    An(i,1) = Cn1(i,1);
    An(i,M+1) = Cn2(i,M);
    At(i,1) = Ct1(i,1);
    At(i,M+1) = Ct2(i,M);
    for j = 2:M
        An(i,j) = Cn1(i,j) + Cn2(i,j-1);
        At(i,j) = Ct1(i,j) + Ct2(i,j-1);
    end
end

An(M+1, 1) = 1;
An(M+1, M+1) = 1;
An(M+1,2:M) = 0;
RHS(M+1) = 0;

gama = An\RHS;
for i = 1:M
    V(i) = cos( theta(i)-alpha );
    for j = 1:M+1
        V(i) = V(i) + At(i,j)*gama(j);
        Cp(i) = 1 - V(i)^2;
    end
end

if (strcmp(opts.plot, 'N_loop'))
    plot(X/(max(XB) - min(XB)), Cp, 'LineWidth', 1)
    ylabel('Cp')
    xlabel('x/c')
    set(gca, 'YDir','reverse')
    title(sprintf('%s Cp vs x/c (\\alpha of %.1d\260)', opts.airfoil, rad2deg(alpha)))
elseif (strcmp(opts.plot, 'alpha_loop'))
    plot(X/(max(XB) - min(XB)), Cp, 'LineWidth', 2)
    ylabel('Cp')
    xlabel('x/c')
    set(gca, 'YDir','reverse')
    title(sprintf('%s Cp vs x/c (%.1d panels)', opts.airfoil, M))
elseif (strcmp(opts.plot, 'true'))
    figure('Units', 'Normalized', 'Position', [1/8, 1/8, 3/4, 3/4])
    hold on
    plot(X/(max(XB) - min(XB)), Cp, 'LineWidth', 2)
    ylabel('Cp')
    xlabel('x/c')
    set(gca, 'YDir','reverse')
    title(sprintf('%s Cp vs x/c (\\alpha of %.1d\260 and %.1d panels)', opts.airfoil, rad2deg(alpha), M))
    hold off
end
Gamma = sum(V.*S);
CL = (2*Gamma) / (max(XB) - min(XB));
end

