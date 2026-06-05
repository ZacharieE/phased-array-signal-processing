clear; clc; close all;

%% Constants
c = 3e8;
fc = 10e9;
lambda = c/fc;
d = lambda/2;
k = 2*pi/lambda;

%% Planar array dimensions
Nx = 16;
Ny = 16;

[x_idx, y_idx] = meshgrid(0:Nx-1, 0:Ny-1);

x_idx = x_idx(:);
y_idx = y_idx(:);

N = Nx * Ny;

%% Desired beam direction
az0 = 70;     % azimuth angle in degrees
el0 = 15;     % elevation angle in degrees

%% Scan angles
az = -90:1:90;
el = 0:1:90;

[AZ, EL] = meshgrid(az, el);

%% Steering vector function
steer = @(azimuth,elevation) exp( ...
    1j*k*d*( ...
    x_idx*sind(azimuth).*cosd(elevation) + ...
    y_idx*sind(elevation) ...
    ) ...
    );

%% Beamforming weights
a0 = steer(az0,el0);
w = conj(a0);
w = w / norm(w);

%% Compute 2D array factor
AF = zeros(size(AZ));

for i = 1:numel(AZ)

    a = steer(AZ(i),EL(i));

    AF(i) = abs(w.' * a);

end

AF = AF / max(AF(:));
AF_dB = 20*log10(AF + 1e-12);

%% 3D surface plot
figure;

surf(AZ,EL,AF_dB,'EdgeColor','none');
grid on;

xlabel('Azimuth (degrees)');
ylabel('Elevation (degrees)');
zlabel('Normalized Gain (dB)');

title(['2D Planar Array Beam Pattern: Az = ',num2str(az0), ...
    '°, El = ',num2str(el0),'°']);

zlim([-60 0]);
caxis([-60 0]);
colorbar;

view(45,35);

%% 2D heatmap
figure;

imagesc(az,el,AF_dB);
set(gca,'YDir','normal');
colorbar;

xlabel('Azimuth (degrees)');
ylabel('Elevation (degrees)');
title('2D Beam Pattern Heatmap');

caxis([-60 0]);

hold on;
plot(az0,el0,'rx','LineWidth',2,'MarkerSize',12);