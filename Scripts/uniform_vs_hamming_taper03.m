clear; clc; close all;

c = 3e8;
fc = 10e9;

lambda = c/fc;

d = lambda/2;

k = 2*pi/lambda;

N = 32;
n = 0:N-1;

theta0 = 30;

theta = -90:0.1:90;

amp_uniform = ones(1,N);
amp_hamming = hamming(N).';

w_uniform = amp_uniform .* ...
    exp(-1j*k*d*n*sind(theta0));

w_hamming = amp_hamming .* ...
    exp(-1j*k*d*n*sind(theta0));

AF_uniform = zeros(size(theta));
AF_hamming = zeros(size(theta));

for idx = 1:length(theta)

    a = exp(1j*k*d*n*sind(theta(idx)));

    AF_uniform(idx) = abs(sum(w_uniform.*a));

    AF_hamming(idx) = abs(sum(w_hamming.*a));

end

AF_uniform = AF_uniform/max(AF_uniform);
AF_hamming = AF_hamming/max(AF_hamming);

AF_uniform_dB = 20*log10(AF_uniform+1e-12);
AF_hamming_dB = 20*log10(AF_hamming+1e-12);

figure;

plot(theta,AF_uniform_dB,'LineWidth',1.5)
hold on

plot(theta,AF_hamming_dB,'LineWidth',1.5)

grid on

xlabel('Angle (deg)')
ylabel('AF (dB)')

title('Uniform vs Hamming Taper')

legend('Uniform','Hamming')

ylim([-80 0])
xlim([-90 90])