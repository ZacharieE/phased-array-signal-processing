clear; clc; close all;

%% Constants
c = 3e8;
fc = 10e9;
lambda = c/fc;
d = lambda/2;
k = 2*pi/lambda;

%% Array
N = 32;
n = 0:N-1;

%% Angle grid
theta = -90:0.1:90;

%% Simulated LEO satellite pass
num_steps = 150;
sat_angle = linspace(-70,70,num_steps);   % satellite moves across sky

%% Storage
gain_fixed_dB = zeros(1,num_steps);
gain_tracking_dB = zeros(1,num_steps);

%% Fixed beam points at broadside
theta_fixed = 0;
w_fixed = exp(-1j*k*d*n.'*sind(theta_fixed));
w_fixed = w_fixed / norm(w_fixed);

for i = 1:num_steps

    theta_sat = sat_angle(i);

    % Steering vector for actual satellite direction
    a_sat = exp(1j*k*d*n.'*sind(theta_sat));

    % Dynamic tracking beamformer
    w_tracking = exp(-1j*k*d*n.'*sind(theta_sat));
    w_tracking = w_tracking / norm(w_tracking);

    % Array gain
    gain_fixed = abs(w_fixed.' * a_sat);
    gain_tracking = abs(w_tracking.' * a_sat);

    % Convert to dB, normalized to max possible gain
    gain_fixed_dB(i) = 20*log10(gain_fixed/sqrt(N) + 1e-12);
    gain_tracking_dB(i) = 20*log10(gain_tracking/sqrt(N) + 1e-12);

end

%% Plot gain vs satellite angle
figure;

plot(sat_angle,gain_fixed_dB,'LineWidth',1.5); hold on;
plot(sat_angle,gain_tracking_dB,'LineWidth',1.5);

grid on;
xlabel('Satellite Angle (degrees)');
ylabel('Normalized Array Gain (dB)');
title('Fixed Beam vs Tracking Beamformer');
legend('Fixed Beam at 0°','Tracking Beam');
ylim([-60 5]);
xlim([-70 70]);

%% Animation of tracking beam pattern
figure;

for i = 1:3:num_steps

    theta_sat = sat_angle(i);

    w_tracking = exp(-1j*k*d*n.'*sind(theta_sat));
    w_tracking = w_tracking / norm(w_tracking);

    AF = zeros(size(theta));

    for idx = 1:length(theta)

        a = exp(1j*k*d*n.'*sind(theta(idx)));

        AF(idx) = abs(w_tracking.' * a);

    end

    AF = AF/max(AF);
    AF_dB = 20*log10(AF + 1e-12);

    plot(theta,AF_dB,'LineWidth',1.5);
    grid on;

    xline(theta_sat,'--','Satellite');

    xlabel('Angle (degrees)');
    ylabel('Normalized Array Factor (dB)');
    title(['Tracking Beamformer, Satellite Angle = ',num2str(theta_sat,'%.1f'),'°']);

    ylim([-60 0]);
    xlim([-90 90]);

    drawnow;

end