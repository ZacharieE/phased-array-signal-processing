clear; clc; close all;

jammer_angles = [32 35 40 50 70];

figure;

for p = 1:length(jammer_angles)

    theta_jammer = jammer_angles(p);

    %% Constants
    c = 3e8;
    fc = 10e9;
    lambda = c/fc;
    d = lambda/2;
    k = 2*pi/lambda;

    %% Array
    N = 32;
    n = 0:N-1;

    %% Desired direction
    theta_desired = 30;

    %% Signals
    Ns = 5000;
    t = 0:Ns-1;

    desired = exp(1j*2*pi*0.03*t);
    jammer  = 5*exp(1j*2*pi*0.08*t);

    %% Steering vectors

    a_desired = exp(1j*k*d*n.'*sind(theta_desired));
    a_jammer  = exp(1j*k*d*n.'*sind(theta_jammer));

    %% Received array data

    X_desired = a_desired * desired;
    X_jammer  = a_jammer  * jammer;

    noise_power = 0.5;

    noise = sqrt(noise_power/2) * ...
        (randn(N,Ns) + 1j*randn(N,Ns));

    X = X_desired + X_jammer + noise;

    %% Beamformer weights

    amp_uniform = ones(N,1);

    w_uniform = amp_uniform .* ...
        exp(-1j*k*d*n.'*sind(theta_desired));

    w_uniform = w_uniform / norm(w_uniform);

    %% Output

    y_uniform = w_uniform.' * X;

    %% FFT

    Nfft = 4096;

    Y = fftshift(abs(fft(y_uniform,Nfft)));

    Y_dB = 20*log10(Y/max(Y)+1e-12);

    f = linspace(-0.5,0.5,Nfft);

    %% Plot

    subplot(2,3,p)

    plot(f,Y_dB,'LineWidth',1.2)

    grid on

    title(['Jammer = ',num2str(theta_jammer),'°'])

    xlabel('Frequency')
    ylabel('Magnitude (dB)')

    ylim([-80 5])

end

sgtitle('Uniform Beamformer Response vs Jammer Angle')