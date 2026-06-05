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

%% Angles

theta_desired = 30;
theta_jammer  = -45;

theta = -90:0.1:90;

%% Steering vectors

a_desired = exp(1j*k*d*n.'*sind(theta_desired));
a_jammer  = exp(1j*k*d*n.'*sind(theta_jammer));

%% Generate snapshots

Ns = 5000;

desired_signal = exp(1j*2*pi*0.03*(0:Ns-1));

jammer_signal  = 10 * ...
    exp(1j*2*pi*0.08*(0:Ns-1));

noise_power = 0.1;

noise = sqrt(noise_power/2) .* ...
    (randn(N,Ns)+1j*randn(N,Ns));

%% Received data

X = a_desired*desired_signal + ...
    a_jammer*jammer_signal + ...
    noise;

%% Covariance matrix

R = (X*X')/Ns;

%% Conventional beamformer

w_conv = exp(-1j*k*d*n.'*sind(theta_desired));

w_conv = w_conv/norm(w_conv);

%% MVDR beamformer

w_mvdr = (R\a_desired) / ...
         (a_desired'*(R\a_desired));

%% Compute patterns

AF_conv = zeros(size(theta));
AF_mvdr = zeros(size(theta));

for idx = 1:length(theta)

    a = exp(1j*k*d*n.'*sind(theta(idx)));

    AF_conv(idx) = abs(w_conv' * a);

    AF_mvdr(idx) = abs(w_mvdr' * a);

end

%% Normalize

AF_conv = AF_conv/max(AF_conv);
AF_mvdr = AF_mvdr/max(AF_mvdr);

AF_conv_dB = 20*log10(AF_conv + 1e-12);
AF_mvdr_dB = 20*log10(AF_mvdr + 1e-12);

%% Plot

figure;

plot(theta,AF_conv_dB,'LineWidth',1.5)
hold on

plot(theta,AF_mvdr_dB,'LineWidth',1.5)

xline(theta_desired,'--','Desired')
xline(theta_jammer,'--','Jammer')

grid on

xlabel('Angle (degrees)')
ylabel('Normalized Gain (dB)')

title('Conventional vs MVDR Beamformer')

legend('Conventional','MVDR')

ylim([-80 5])
xlim([-90 90])