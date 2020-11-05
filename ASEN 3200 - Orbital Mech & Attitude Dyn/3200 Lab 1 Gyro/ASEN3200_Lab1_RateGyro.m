%Shawn Stone
%ASEN 3200 Lab 1: Attitude Sensors and Actuators
%Created: 9/07/20
clc; clear; close;

%% Trimming Data
%this section eliminates all columns when the input rate is zero, 
%and converts the third column (input rate) from [rpm] to [rad/s]

%inputs all files into a cell array
celldata = {readmatrix("Auto_Torque_05A_01H"), readmatrix("Auto_Torque_05A_02H"), readmatrix("Auto_Torque_05A_05H") ...
    readmatrix("Auto_Torque_025A_01H"), readmatrix("Auto_Torque_025A_02H"), readmatrix("Auto_Torque_025A_05H") ...
    readmatrix("Auto_Torque_075A_01H"), readmatrix("Auto_Torque_075A_02H"), readmatrix("Auto_Torque_075A_05H")};

for i = 1:9
    [L, ~] = size(celldata{1,i}); %finds length of current file/matrix
    mat = celldata{1,i}; %temporary matrix variable
    for j = 1:L
        if (mat(1,3) == 0)
            mat(1,:) = [];
        end
    end
    mat(:,3) = mat(:,3) * (-2*pi/60); %converts third column from [rpm] to [rad/s]
    celldata{1,i} = mat; %redefines file/matrix in the cell array
end
clear i j;

%% Finding Adjusted Scale Facter and Bias

titleNames = [5 5 5 25 25 25 75 75 75; 1 2 5 1 2 5 1 2 5];
for k = 1:9
    encoder = celldata{1,k}(:,3);
    gyro = celldata{1,k}(:,2);
    coeff = polyfit(encoder, gyro, 1);
    xspace = linspace(-8,8);
    K(k,1) = coeff(1);
    bias(k,1) = coeff(2);
   
    figure(1)
    subplot(3,3,k)
    plot(encoder, gyro, 'LineWidth', 2)
    hold on
    plot(xspace, polyval(coeff,xspace),'--r','LineWidth',1)
    xlabel('Encoder (Input Rate, [rad/s])')
    ylabel('Gyro (Output Rate [rad/s])')
    title(sprintf('0.%2d Amps & 0.%1d Hz', titleNames(1,k), titleNames(2,k)))
    hold off
    clear encoder gyro coeff
end
clear k;

biasMean = mean(bias);
biasSTD = std(bias);

KMean = mean(K);
KSTD = std(K);

%% Plotting Angular Rate and Position vs Time

titleNames = [5 5 5 25 25 25 75 75 75; 1 2 5 1 2 5 1 2 5];
for k = 1:9
    gyro = celldata{1,k}(:,2);
    angularRate = gyro/KMean - biasMean;
    time = celldata{1,k}(:,1) - celldata{1,k}(1,1);

    figure(2)
    subplot(3,3,k)
    plot(time, angularRate, 'LineWidth', 2)
    hold on
    xlabel('time [s])')
    ylabel('Angular Rate [rad/s]')
    title(sprintf('0.%2d Amps & 0.%1d Hz: Angular Rate vs Time', titleNames(1,k), titleNames(2,k)))
    hold off
    
    angularPosition = cumtrapz(angularRate);
    
    figure(3)
    subplot(3,3,k)
    plot(time, angularPosition, 'LineWidth', 2)
    hold on
    xlabel('time [s])')
    ylabel('Angular Position [rad]')
    title(sprintf('0.%2d Amps & 0.%1d Hz: Angular Position vs Time', titleNames(1,k), titleNames(2,k)))
    hold off
    
    clear gyro angularRate angularPosition time;
end
clear k;



