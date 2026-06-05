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

%% Simulated moving targets
num_steps = 150;

satA = linspace(-60,60,num_steps);   % Satellite A moves left to right
satB = linspace(60,-60,num_steps);   % Satellite B moves right to left

%% Store gains
gainA_on_A = zeros(1,num_steps);
gainB_on_B = zeros(1,num_steps);
gainA_on_B = zeros(1,num_steps);
gainB_on_A = zeros(1,num_steps);

%% Animation
figure;

for t = 1:num_steps

    thetaA = satA(t);
    thetaB = satB(t);

    % Steering vectors for satellites
    aA = exp(1j*k*d*n.'*sind(thetaA));
    aB = exp(1j*k*d*n.'*sind(thetaB));

    % Beam A points at satellite A
    wA = exp(-1j*k*d*n.'*sind(thetaA));
    wA = wA / norm(wA);

    % Beam B points at satellite B
    wB = exp(-1j*k*d*n.'*sind(thetaB));
    wB = wB / norm(wB);

    % Gain measurements
    gainA_on_A(t) = abs(wA.' * aA);
    gainB_on_B(t) = abs(wB.' * aB);
    gainA_on_B(t) = abs(wA.' * aB);
    gainB_on_A(t) = abs(wB.' * aA);

    % Compute beam patterns
    AF_A = zeros(size(theta));
    AF_B = zeros(size(theta));

    for idx = 1:length(theta)

        a = exp(1j*k*d*n.'*sind(theta(idx)));

        AF_A(idx) = abs(wA.' * a);
        AF_B(idx) = abs(wB.' * a);

    end

    AF_A = AF_A / max(AF_A);
    AF_B = AF_B / max(AF_B);

    AF_A_dB = 20*log10(AF_A + 1e-12);
    AF_B_dB = 20*log10(AF_B + 1e-12);

    % Animate every few frames
    if mod(t,3) == 1

        clf;

        plot(theta,AF_A_dB,'LineWidth',1.5); hold on;
        plot(theta,AF_B_dB,'LineWidth',1.5);

        xline(thetaA,'--','Sat A');
        xline(thetaB,'--','Sat B');

        grid on;
        xlabel('Angle (degrees)');
        ylabel('Normalized Array Gain (dB)');
        title('Multi-Target Tracking with Two Simultaneous Beams');

        legend('Beam A','Beam B','Location','southwest');

        ylim([-60 0]);
        xlim([-90 90]);

        drawnow;

    end

end

%% Normalize gain logs
gainA_on_A_dB = 20*log10(gainA_on_A / sqrt(N) + 1e-12);
gainB_on_B_dB = 20*log10(gainB_on_B / sqrt(N) + 1e-12);
gainA_on_B_dB = 20*log10(gainA_on_B / sqrt(N) + 1e-12);
gainB_on_A_dB = 20*log10(gainB_on_A / sqrt(N) + 1e-12);

%% Plot gain history
figure;

plot(gainA_on_A_dB,'LineWidth',1.5); hold on;
plot(gainB_on_B_dB,'LineWidth',1.5);
plot(gainA_on_B_dB,'--','LineWidth',1.5);
plot(gainB_on_A_dB,'--','LineWidth',1.5);

grid on;
xlabel('Time Step');
ylabel('Normalized Gain (dB)');
title('Target Gain and Cross-Gain During Multi-Target Tracking');

legend( ...
    'Beam A on Sat A', ...
    'Beam B on Sat B', ...
    'Beam A leakage toward Sat B', ...
    'Beam B leakage toward Sat A', ...
    'Location','best');

ylim([-60 5]);