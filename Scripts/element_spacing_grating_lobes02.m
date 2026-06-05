clear; clc; close all;

c = 3e8;
fc = 10e9;
lambda = c/fc;

N = 8;
n = 0:N-1;

theta0 = 30;
theta = -90:0.1:90;

k = 2*pi/lambda;

spacing_list = [lambda/2 lambda];

figure;

for p = 1:length(spacing_list)

    d = spacing_list(p);

    w = exp(-1j*k*d*n*sind(theta0));

    AF = zeros(size(theta));

    for idx = 1:length(theta)

        a = exp(1j*k*d*n*sind(theta(idx)));

        AF(idx) = abs(sum(w.*a));

    end

    AF = AF/max(AF);

    AF_dB = 20*log10(AF+1e-12);

    subplot(1,2,p)

    plot(theta,AF_dB,'LineWidth',1.5)

    grid on

    if d == lambda/2
        title('d = \lambda/2')
    else
        title('d = \lambda')
    end

    ylim([-60 0])
    xlim([-90 90])

    xlabel('Angle (deg)')
    ylabel('AF (dB)')

end