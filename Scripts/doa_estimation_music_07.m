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

%% Two signals

theta1 = 23;
theta2 = 27;

Ns = 1000;

signal1 = exp(1j*2*pi*0.05*(0:Ns-1));
signal2 = exp(1j*2*pi*0.11*(0:Ns-1));

a1 = exp(1j*k*d*n.'*sind(theta1));
a2 = exp(1j*k*d*n.'*sind(theta2));

noise_power = 0.1;

noise = sqrt(noise_power/2) .* ...
    (randn(N,Ns)+1j*randn(N,Ns));

X = a1*signal1 + ...
    a2*signal2 + ...
    noise;

%% Covariance matrix

R = (X*X')/Ns;

%% Eigendecomposition

[V,D] = eig(R);

[eigenvalues,idx] = sort(diag(D),'descend');

V = V(:,idx);

%% One signal present

En = V(:,3:end);

%% MUSIC Spectrum

theta_scan = -90:0.2:90;

Pmusic = zeros(size(theta_scan));

for i = 1:length(theta_scan)

    a = exp(1j*k*d*n.'*sind(theta_scan(i)));

    Pmusic(i) = 1 / ...
        abs(a'*(En*En')*a);

end

Pmusic_dB = 10*log10(Pmusic/max(Pmusic));

%% Plot

figure;

plot(theta_scan,Pmusic_dB,'LineWidth',1.5);

grid on;

xlabel('Angle (degrees)');
ylabel('Normalized Spectrum (dB)');

title('MUSIC DOA Estimation');

ylim([-60 5]);
xlim([-90 90]);

xline(theta1,'--','Signal 1');
xline(theta2,'--','Signal 2');