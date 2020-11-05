function QuadPlot(t,state,flags,opts)
%QUADPLOT Plots data of quadrotor motion integration.
%   Displays quadrotor flight path, position, rotation, velocity, and spinrate.
%
%   Notes:      - State data is rounded to 5 decimals to remove
%                 computational inaccuracy
%               - Angles are converted from radians to degrees
%
%   Inputs:     t                 -   time vector [s] (Mx12 double)
%               state             -   state vector (Mx12 double)
%               flags             -   data-associated letters to plot (1x1 string)
%               opts              -   name-value pairs for plotting options (1x1 struct)
%
%   Outputs:    NONE
%
%   Author:     William Gravel
%   Created:    09/11/2020
%   Edited:     09/24/2020
%   Purpose:    ASEN 3128 - Lab 2

%% Input arguments
arguments
    t (:,1) double
    state (:,12) double
    flags (1,1) string = 'o'
    opts.Title (1,1) string = 'Quadrotor Motion'
    opts.SavePlots (1,1) logical = false
    opts.Problem (1,1) string
    opts.Disturbance (1,1) double
end

%% Round state values while keeping relevant accuracy and convert to degrees
state = round(state,5); 
state(:,4:6) = rad2deg(state(:,4:6));
state(:,10:12) = rad2deg(state(:,10:12));

%% Quadrotor Flight Path
if contains(flags,'f')
    figure
    plot3(state(:,1),state(:,2),state(:,3),'k','LineWidth',0.8)
    grid on
    xlabel('x_E [m]')
    ylabel('y_E [m]')
    zlabel('z_E [m]')
    title('Flight Path')
    
    if opts.SavePlots && (exist('opts','var') && isfield(opts,'Problem'))
        print(sprintf('Plots/Problem_%s_Flight',opts.Problem),'-djpeg','-r300');
    end
end

%% Quadrotor Position
if contains(flags,'p')
    figure
    subplot(3,1,1)
    plot(t,state(:,1),'r','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('x_E [m]')

    subplot(3,1,2)
    plot(t,state(:,2),'g','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('y_E [m]')

    subplot(3,1,3)
    plot(t,state(:,3),'b','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('z_E [m]')

    sgtitle('Position Over Time')
    
    if opts.SavePlots && (exist('opts','var') && isfield(opts,'Problem'))
        print(sprintf('Plots/Problem_%s_Position',opts.Problem),'-djpeg','-r300');
    end
end

%% Quadrotor Rotation
if contains(flags,'r')
    figure
    subplot(3,1,1)
    plot(t,state(:,4),'m','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,4);state(:,5);state(:,6)]))-1,round(max([state(:,4);state(:,5);state(:,6)]))+1])
    xlabel('time [s]')
    ylabel('\phi [deg]')

    subplot(3,1,2)
    plot(t,state(:,5),'y','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,4);state(:,5);state(:,6)]))-1,round(max([state(:,4);state(:,5);state(:,6)]))+1]);
    xlabel('time [s]')
    ylabel('\theta [deg]')

    subplot(3,1,3)
    plot(t,state(:,6),'c','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,4);state(:,5);state(:,6)]))-1,round(max([state(:,4);state(:,5);state(:,6)]))+1])
    xlabel('time [s]')
    ylabel('\psi [deg]')

    sgtitle('Rotation Over Time')
    
    if opts.SavePlots && (exist('opts','var') && isfield(opts,'Problem'))
        print(sprintf('Plots/Problem_%s_Rotation',opts.Problem),'-djpeg','-r300');
    end
end

%% Quadrotor Velocity
if contains(flags,'v')
    figure
    subplot(3,1,1)
    plot(t,state(:,7),'r','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('u^E [m/s]')

    subplot(3,1,2)
    plot(t,state(:,8),'g','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('v^E [m/s]')

    subplot(3,1,3)
    plot(t,state(:,9),'b','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('w^E [m/s]')

    sgtitle('Velocity Over Time')
    
    if opts.SavePlots && (exist('opts','var') && isfield(opts,'Problem'))
        print(sprintf('Plots/Problem_%s_Velocity',opts.Problem),'-djpeg','-r300');
    end
end

%% Quadrotor Spinrate
if contains(flags,'s')
    figure
    subplot(3,1,1)
    plot(t,state(:,10),'m','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,10);state(:,11);state(:,12)]))-1,round(max([state(:,10);state(:,11);state(:,12)]))+1])
    xlabel('time [s]')
    ylabel('p [deg/s]')

    subplot(3,1,2)
    plot(t,state(:,11),'y','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,10);state(:,11);state(:,12)]))-1,round(max([state(:,10);state(:,11);state(:,12)]))+1])
    xlabel('time [s]')
    ylabel('q [deg/s]')

    subplot(3,1,3)
    plot(t,state(:,12),'c','LineWidth',0.8)
    grid on
    xlim([t(1),t(end)])
    ylim([round(min([state(:,10);state(:,11);state(:,12)]))-1,round(max([state(:,10);state(:,11);state(:,12)]))+1])
    xlabel('time [s]')
    ylabel('r [deg/s]')

    sgtitle('Spinrate Over Time')
    
    if opts.SavePlots && (exist('opts','var') && isfield(opts,'Problem'))
        print(sprintf('Plots/Problem_%s_Spinrate',opts.Problem),'-djpeg','-r300');
    end
end

%% Quadrotor Overview
if contains(flags,'a')
    figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
    subplot(4,3,1)
    hold on
    an1 = animatedline('Color','red','LineWidth',2);
    plot(t,state(:,1),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('x_E [m]')
    
    subplot(4,3,2)
    hold on
    an2 = animatedline('Color','red','LineWidth',2);
    plot(t,state(:,2),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('y_E [m]')
    
    subplot(4,3,3)
    hold on
    an3 = animatedline('Color','red','LineWidth',2);
    plot(t,state(:,3),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('z_E [m]')
    
    subplot(4,3,4)
    hold on
    an4 = animatedline('Color','red','LineWidth',2);
    plot(t,rad2deg(state(:,4)),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('\phi [deg]')
    
    subplot(4,3,5)
    hold on
    an5 = animatedline('Color','red','LineWidth',2);
    plot(t,rad2deg(state(:,5)),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('\theta [deg]')
    
    subplot(4,3,6)
    hold on
    an6 = animatedline('Color','red','LineWidth',2);
    plot(t,rad2deg(state(:,6)),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('\psi [deg]')
    
    subplot(4,3,7)
    hold on
    an7 = animatedline('Color','red','LineWidth',2);
    plot(t,state(:,7),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('u^E [m/s]')
    
    subplot(4,3,8)
    hold on
    an8 = animatedline('Color','red','LineWidth',2);
    plot(t,state(:,8),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('v^E [m/s]')
    
    subplot(4,3,9)
    hold on
    an9 = animatedline('Color','red','LineWidth',2);
    plot(t,state(:,9),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('w^E [m/s]')
    
    subplot(4,3,10)
    hold on
    an10 = animatedline('Color','red','LineWidth',2);
    plot(t,rad2deg(state(:,10)),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('p [deg/s]')
    
    subplot(4,3,11)
    hold on
    an11 = animatedline('Color','red','LineWidth',2);
    plot(t,rad2deg(state(:,11)),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('q [deg/s]')
    
    subplot(4,3,12)
    hold on
    an12 = animatedline('Color','red','LineWidth',2);
    plot(t,rad2deg(state(:,12)),'k')
    hold off
    grid on
    xlim([t(1),t(end)])
    xlabel('time [s]')
    ylabel('r [deg/s]')
    
    sgtitle(opts.Title)
    
    n = 10;
    for k = 1:n:length(t)-(n-1)
        addpoints(an1,t(k:k+n-1),state(k:k+n-1,1));
        addpoints(an2,t(k:k+n-1),state(k:k+n-1,2));
        addpoints(an3,t(k:k+n-1),state(k:k+n-1,3));
        addpoints(an4,t(k:k+n-1),rad2deg(state(k:k+n-1,4)));
        addpoints(an5,t(k:k+n-1),rad2deg(state(k:k+n-1,5)));
        addpoints(an6,t(k:k+n-1),rad2deg(state(k:k+n-1,6)));
        addpoints(an7,t(k:k+n-1),state(k:k+n-1,7));
        addpoints(an8,t(k:k+n-1),state(k:k+n-1,8));
        addpoints(an9,t(k:k+n-1),state(k:k+n-1,9));
        addpoints(an10,t(k:k+n-1),rad2deg(state(k:k+n-1,10)));
        addpoints(an11,t(k:k+n-1),rad2deg(state(k:k+n-1,11)));
        addpoints(an12,t(k:k+n-1),rad2deg(state(k:k+n-1,12)));
        drawnow
    end
    k = k + n;
    addpoints(an1,t(k:end),state(k:end,1));
    addpoints(an2,t(k:end),state(k:end,2));
    addpoints(an3,t(k:end),state(k:end,3));
    addpoints(an4,t(k:end),rad2deg(state(k:end,4)));
    addpoints(an5,t(k:end),rad2deg(state(k:end,5)));
    addpoints(an6,t(k:end),rad2deg(state(k:end,6)));
    addpoints(an7,t(k:end),state(k:end,7));
    addpoints(an8,t(k:end),state(k:end,8));
    addpoints(an9,t(k:end),state(k:end,9));
    addpoints(an10,t(k:end),rad2deg(state(k:end,10)));
    addpoints(an11,t(k:end),rad2deg(state(k:end,11)));
    addpoints(an12,t(k:end),rad2deg(state(k:end,12)));
end

if contains(flags,'o')
    labels = ["x_E [m]","y_E [m]","z_E [m]","\phi [deg]","\theta [deg]","\psi [deg]","u^E [m/s]","v^E [m/s]","w^E [m/s]","p [deg/s]","q [deg/s]","r [deg/s]"];
    
    figure('Units','Normalized','Position',[1/8 1/8 3/4 3/4])
    colors = ["r","g","b","m","y","c","r","g","b","m","y","c"];
    for i = 1:12
        subplot(4,3,i)
        hold on
        plot(t,state(:,i),colors(i),'LineWidth',0.8)
        if exist('opts','var') == 1 && isfield(opts,'Disturbance')
            xline(opts.Disturbance,'k--');
        end
        hold off
        grid on
        xlim([t(1),t(end)])
        xlabel('time [s]')
        ylabel(labels(i))
    end
    
    sgtitle(opts.Title)
    
    if opts.SavePlots && (exist('opts','var') && isfield(opts,'Problem'))
        print(sprintf('Plots/Problem_%s_Overview',opts.Problem),'-djpeg','-r300');
    end
end

end
