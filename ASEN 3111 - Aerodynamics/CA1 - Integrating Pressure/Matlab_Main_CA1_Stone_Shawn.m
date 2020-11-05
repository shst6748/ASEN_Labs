%ASEN 3111 Computation Assignment 01 - Main
%
%This code is split into multiple sections between Problems 1 & 2,
%calculating coefficients of lift and drag from analytical solutions for
%Problem 1 and lift and drag from given Cp data for Problem 2.
%
%   Authors: Shawn Stone
%   Collaborator: Quinn Lewis
%   Created: 9/11/20, Last Revised: 9/17/20
clc; clear all; close all;
tic
%% Problem 1: Analytical Solution
syms theta R V_inf;

gamma = 2*pi*R*V_inf;

C_p = 1 - (4*(sin(theta))^2 + (2*gamma*sin(theta))/(pi*R*V_inf) + (gamma/(2*pi*R*V_inf))^2);

cl = -0.5*int(C_p*sin(theta), theta, 0, 2*pi);
cd = -0.5*int(C_p*cos(theta),theta, 0, 2*pi);
fprintf('Problem 1:\nCoefficient of Lift: %.4f\nCoefficient of Drag: %.1f\n', double(cl), double(cd))

%% Problem 1: Composite Trapezoidal Rule
%This section computes sectional lift and drag coefficients, using the
%formulas for cl and cd given in the document. Namely, cl = -0.5*(integral of
%Cp*sin(theta) dtheta) and cd = -0.5*(integral of Cp*cos(theta) dtheta) from 0 to 2*pi.

a = 0;
b = 2*pi;
bool = 0; %used in if statement for relative error
Cl_tr = zeros(1,10);
Cd_tr = zeros(1,10);
for N = 1:10
    h = (b - a)/(N); %step size
    x = 0:h:2*pi; 
    cl_tr = 0;
    cd_tr = 0;
    for k = 1:N
        cl_tr = double(cl_tr + (-0.5*subs(C_p,theta,x(k+1)) * sin(x(k+1)) + -0.5*subs(C_p,theta,x(k)) * sin(x(k)))/2);
        cd_tr = double(cd_tr + (-0.5*subs(C_p,theta,x(k+1)) * cos(x(k+1)) + -0.5*subs(C_p,theta,x(k)) * cos(x(k)))/2);
        %^current coefficient of lift and drag, calculated using subs(f(x), x, x(k)), 
        %because C_p is still a symbolic expression
    end
    Cl_tr(N) = h*cl_tr; 
    Cd_tr(N) = h*cd_tr;
    
    error = abs((double(cl) - h*cl_tr)) / double(cl);
    if(error <= 0.001 && bool == 0)
        fprintf('It took %d panels to reach within 1/10%% relative error\n', N)
        bool = 1;
    end
end

figure()
subplot(2,1,1)
plot(1:N, Cl_tr,'LineWidth', 2)
xlabel('Number of Panels Used')
ylabel('Coefficient of Lift')
title('Composite Trapezoidal Rule')

subplot(2,1,2)
plot(1:N, Cd_tr,'LineWidth', 2)
xlabel('Number of Panels Used')
ylabel('Coefficient of Drag')
title('Composite Trapezoidal Rule')

%% Problem 1: Composite Simpson's Rule
bool = 0;
Cl_sr = zeros(1,10);
Cd_sr = zeros(1,10);
for N = 1:10
    h = (b - a)/(2*N);
    x = a:h:b;
    cl_sr = 0;
    cd_sr = 0;
    for k = 1:N
        cl_sr = double(cl_sr + (-1/2)*(subs(C_p, theta,x(2*k-1))*sin(x(2*k-1)) + 4*(subs(C_p, theta,x(2*k))*sin(x(2*k))) + subs(C_p, theta,x(2*k+1))*sin(x(2*k+1))));
        cd_sr = double(cd_sr + (-1/2)*(subs(C_p, theta,x(2*k-1))*cos(x(2*k-1)) + 4*(subs(C_p, theta,x(2*k))*cos(x(2*k))) + subs(C_p, theta,x(2*k+1))*cos(x(2*k+1))));
    end
    Cl_sr(N) = h/3 * cl_sr;
    Cd_sr(N) = h/3 * cd_sr;
    
    error = abs(double(cl) - (h/3 * cl_sr))/ double(cl);
    if(error <= 0.001 && bool == 0)
        fprintf('It took %d panels to reach within 1/10%% relative error\n', N)
        bool = 1;
    end
end

figure()
subplot(2,1,1)
plot(1:N, Cl_sr,'LineWidth', 2)
xlabel('Number of Panels Used')
ylabel('Coefficient of Lift')
title('Composite Simpson Rule')

subplot(2,1,2)
plot(1:N, Cd_sr,'LineWidth', 2)
xlabel('Number of Panels Used')
ylabel('Coefficient of Drag')
title('Composite Simpson Rule')

%% Problem 2: Loading Cp and constants
load Cp

%constants
rho = 1.225;
V = 30;
alpha = deg2rad(9);
p_inf = 101.3*10^3;
q = (1/2)*rho*V^2;
c = 2;

%% Problem 2: Finding Lift and Drag for High N
%This section of code calculates lift and drag for a high number of panels.
%The singular values of l_check and d_check are lift and drag values which 
%will be used as a reference for calculating relative error later.

%NOTE: This for-loop is identical to the for-loop used in the next
%section, without the outermost for-loop, and thus isn't commented to
%reduce redundancy. The only real difference is that this for-loop only runs once, for one large value of
%panels, rather than iterating through an increasing number of panels.

panels = 5000;
h = (c - a)/(panels);
x = 0:h:c;
n_check = 0;
a_check = 0;
for k = 1:panels
    delx = x(k+1) - x(k);
    n_prime_upper = -delx*(((q*fnval(Cp_upper, x(k+1)/c)+p_inf) + (q*fnval(Cp_upper, x(k)/c))+p_inf)/2);
    n_prime_lower = delx*(((q*fnval(Cp_lower, x(k+1)/c)+p_inf) + (q*fnval(Cp_lower, x(k)/c))+p_inf)/2);
    n_check = n_check + (n_prime_upper + n_prime_lower);
    
    dely = yt(x(k+1)) - yt(x(k));
    a_prime_upper = dely*(((q*fnval(Cp_upper, x(k+1)/c)+p_inf) + (q*fnval(Cp_upper, x(k)/c))+p_inf)/2);
    a_prime_lower = dely*(((q*fnval(Cp_lower, x(k+1)/c)+p_inf) + (q*fnval(Cp_lower, x(k)/c))+p_inf)/2);
    a_check = a_check + (a_prime_upper + a_prime_lower);
    
    l_check = n_check*cos(alpha) - a_check*sin(alpha);
    d_check = n_check*sin(alpha) + a_check*cos(alpha);
end

%% Problem 2: Lift & Drag with Relative Error
%This section iterates (using trapezoidal rule) to calculate lift and drag,
%continuously comparing to the previous "l_check" and "d_check" values
%calculated previously, printing (and breaking the for loop) when it
%reaches relative error margins.

%NOTE: shear forces are ignored in an ideal flow

%NOTE: I had to split my for-loop into 2, one which runs for relative
%error of 1% and 5% (<200 panels), and another for the 0.1% error case 
%(between 920 and 1000 panels) in order to save on run time. Both for loops
%are identical in their calculation of Lift and Drag

%Preallocating vectors
panels = 200;
L = zeros(1,panels);
D = zeros(1,panels);
bool = [0 0 0]; %boolean values used in the if statements that check for error

%first for-loop, which includes 5% and 1% relative error cases
for N = 1:panels
    h = (c - a)/(N);
    x = 0:h:c;
    n_total = 0;
    a_total = 0;
    for k = 1:N
        delx = x(k+1) - x(k);
        n_prime_upper = -delx*(((q*fnval(Cp_upper, x(k+1)/c)+p_inf) + (q*fnval(Cp_upper, x(k)/c))+p_inf)/2);
        %^calculates N' for the upper surface
        n_prime_lower = delx*(((q*fnval(Cp_lower, x(k+1)/c)+p_inf) + (q*fnval(Cp_lower, x(k)/c))+p_inf)/2);
        %^calculates N' for the lower surface
        n_total = n_total + (n_prime_upper + n_prime_lower);
        %^summation of upper and lower N' values
        
        dely = yt(x(k+1)) - yt(x(k));
        a_prime_upper = dely*(((q*fnval(Cp_upper, x(k+1)/c)+p_inf) + (q*fnval(Cp_upper, x(k)/c))+p_inf)/2);
        %^calculates A' for the upper surface
        a_prime_lower = dely*(((q*fnval(Cp_lower, x(k+1)/c)+p_inf) + (q*fnval(Cp_lower, x(k)/c))+p_inf)/2);
        %^calculates A' for the lower surface
        a_total = a_total + (a_prime_upper + a_prime_lower);
        %^summation of upper and lower A' values
        
        l_total = n_total*cos(alpha) - a_total*sin(alpha); %calculates lift from N and A
        d_total = n_total*sin(alpha) + a_total*cos(alpha); %calculates drag from N and A
    end
    L(N) = l_total;
    D(N) = d_total;
    
    error = abs((l_check - l_total)) / l_check;
    if (error <= 0.01 && bool(2) == 0)
        fprintf('It took %d integration points (%d panels) to reach within 1%% relative error\n', 2*(N+1),N)
        bool(2) = 1;
        break %used to break out of for-loop once 1% relative error has been reached
    elseif (error <= 0.05 && bool(3) == 0)
        fprintf('Problem 2:\nIt took %d integration points (%d panels) to reach within 5%% relative error\n', 2*(N+1),N)
        bool(3) = 1;
    end
end


%Preallocating vectors
panels = 1000;
L = zeros(1,panels);
D = zeros(1,panels);
bool = [0 0 0];
%Second for loop, which includes 0.1% relative error case
for N = 920:panels
    h = (c - a)/(N);
    x = 0:h:c;
    n_total = 0;
    a_total = 0;
    for k = 1:N
        delx = x(k+1) - x(k);
        n_prime_upper = -delx*(((q*fnval(Cp_upper, x(k+1)/c)+p_inf) + (q*fnval(Cp_upper, x(k)/c))+p_inf) / 2); 
        %^calculates N' for the upper surface
        n_prime_lower = delx*(((q*fnval(Cp_lower, x(k+1)/c)+p_inf) + (q*fnval(Cp_lower, x(k)/c))+p_inf) / 2);
        %^calculates N' for the lower surface
        n_total = n_total + (n_prime_upper + n_prime_lower); 
        %^summation of upper and lower N' values
        
        dely = yt(x(k+1)) - yt(x(k));
        a_prime_upper = dely*(((q*fnval(Cp_upper, x(k+1)/c)+p_inf) + (q*fnval(Cp_upper, x(k)/c))+p_inf) / 2);
        %^calculates A' for the upper surface
        a_prime_lower = dely*(((q*fnval(Cp_lower, x(k+1)/c)+p_inf) + (q*fnval(Cp_lower, x(k)/c))+p_inf) / 2);
        %^calculates A' for the lower surface
        a_total = a_total + (a_prime_upper + a_prime_lower);
        %^summation of upper surface and lower surface A' values
        
        l_total = n_total*cos(alpha) - a_total*sin(alpha);
        d_total = n_total*sin(alpha) + a_total*cos(alpha);
    end
    L(N) = l_total;
    D(N) = d_total;
    
    error = abs((l_check - l_total)) / l_check; %relative error = abs(answer - current) / answer
    if(error <= 0.001 && bool(1) == 0)
        fprintf('It took %d integration points (%d panels) to reach within 1/10%% relative error\n', 2*(N+1),N)
        bool(1) = 1;
        break %used to exit the for loop once reaching desired relative error margin
    end
end
toc
%% Function(s)

function yout = yt(x)
%yt  This function simply computes the y value for a given x location of a
%NACA 0012 airfoil
%   Authors: Shawn Stone
%   Created: 9/17/20, Last Revised: 9/17/20


t = 12/100; %thickness (depends on airfoil)
c = 2; %chord length
yout = (t*c/0.2)*(0.2969*sqrt(x/c) - 0.126*(x/c) - 0.3516*((x/c)^2) + 0.2843*((x/c)^3) - 0.1036*((x/c)^4));
end


