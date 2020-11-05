function sat = PlotSatellite()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ASEN3200 - Spacecraft Attitude Dynamics
% sat = PlotSatellite()
%
% Plot a cubic spacecraft with solar panel and give the handle to this
% object for further processing
%
% Author: Nicola Baresi
% Date: Feb, 2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% First side
Vx  = [sqrt(2)/2, sqrt(2)/2, sqrt(2)/2, sqrt(2)/2];
Vy  = [sqrt(2)/2, sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2];
Vz  = [sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2, sqrt(2)/2];
sat(1) = fill3(Vx,Vy,Vz,'c'); hold on;

% Second side
Vx  = [sqrt(2)/2, sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2];
Vy  = [-sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2];
Vz  = [sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2, sqrt(2)/2];
sat(2) = fill3(Vx,Vy,Vz,'c'); 

% Third side
Vx  = [-sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2];
Vy  = [-sqrt(2)/2, -sqrt(2)/2, sqrt(2)/2, sqrt(2)/2];
Vz  = [sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2, sqrt(2)/2];
sat(3) = fill3(Vx,Vy,Vz,'c'); 

% Fourth side
Vx  = [-sqrt(2)/2, -sqrt(2)/2, sqrt(2)/2, sqrt(2)/2];
Vy  = [sqrt(2)/2, sqrt(2)/2, sqrt(2)/2, sqrt(2)/2];
Vz  = [sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2, sqrt(2)/2];
sat(4) = fill3(Vx,Vy,Vz,'c'); 

% Fifth side
Vx  = [sqrt(2)/2, sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2];
Vy  = [sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2, sqrt(2)/2];
Vz  = [sqrt(2)/2, sqrt(2)/2, sqrt(2)/2, sqrt(2)/2];
sat(5) = fill3(Vx,Vy,Vz,'c'); 

% Sixth side
Vx  = [sqrt(2)/2, sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2];
Vy  = [sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2, sqrt(2)/2];
Vz  = [-sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2, -sqrt(2)/2];
sat(6) = fill3(Vx,Vy,Vz,'c');

% Bearing one
Vx  = [0, 0];
Vy  = [sqrt(2)/2, 1];
Vz  = [0, 0];
sat(7) = plot3(Vx,Vy,Vz,'k','Linewidth',1);


% Bearing two
Vx  = [0, 0];
Vy  = [-sqrt(2)/2, -1];
Vz  = [0, 0];
sat(8) = plot3(Vx,Vy,Vz,'k','Linewidth',1);

% First solar panel
Vx  = [0, 0, 0, 0];
Vy  = [1, 1, 4, 4];
Vz  = [sqrt(2)/4, -sqrt(2)/4, -sqrt(2)/4, sqrt(2)/4];
sat(9) = fill3(Vx,Vy,Vz,'b');

% Second solar panel
Vx  = [0, 0, 0, 0];
Vy  = [-1, -1, -4, -4];
Vz  = [sqrt(2)/4, -sqrt(2)/4, -sqrt(2)/4, sqrt(2)/4];
sat(10) = fill3(Vx,Vy,Vz,'b'); 




