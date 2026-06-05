clear; clc; close all;

% Constants
c = 3e8;
fc = 10e9;
lambda = c/fc;
d = lambda/2;

% Array
N = 8;
n = 0:N-1;

% Steering angle
theta0 = 30;

% Angle sweep
theta = -90:0.1:90;

k = 2*pi/lambda;

% Steering weights
w = exp(-1j*k*d*n*sind(theta0));

AF = zeros(size(theta));

for idx = 1:length(theta)

    a = exp(1j*k*d*n*sind(theta(idx)));

    AF(idx) = abs(sum(w.*a));

end

AF = AF/max(AF);
AF_dB = 20*log10(AF+1e-12);

figure;

plot(theta,AF_dB,'LineWidth',1.5);

grid on;

xlabel('Angle (degrees)');
ylabel('Normalized Array Factor (dB)');

title(['Beam Steering - N=',num2str(N),...
       ', Steering Angle=',num2str(theta0),'°']);

ylim([-60 0]);
xlim([-90 90]);