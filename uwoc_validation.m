
clc;
clear;
close all;

% UWOC physical-model validation

Pt_mW = 1.0;
c = 0.30;
distances = 1:0.1:20;

% Theoretical received power
actualPower_dBm = 10*log10(Pt_mW) ...
    - 4.343*c*distances;

% Required received power
minPower_dBm = -20;

% Calculate the theoretical distance limit
theoreticalMaxDistance = ...
    (10*log10(Pt_mW) - minPower_dBm)/(4.343*c);

% Select the largest tested distance satisfying the limit
valid = actualPower_dBm >= minPower_dBm;
bestDistance = max(distances(valid));

fprintf('Theoretical continuous distance limit: %.3f m\n', ...
    theoreticalMaxDistance);

fprintf('Largest valid 0.1 m candidate: %.1f m\n', ...
    bestDistance);

fprintf('Received power at selected distance: %.3f dBm\n', ...
    actualPower_dBm(find(distances == bestDistance,1)));

% Plot physical-model validation
figure;

plot(distances, actualPower_dBm, ...
    'k-', 'LineWidth', 1.5);
hold on;

yline(minPower_dBm, 'r--', ...
    'Required received power');

xline(theoreticalMaxDistance, 'b:', ...
    'Continuous distance limit');

xlabel('Underwater Distance (m)');
ylabel('Received Optical Power (dBm)');
title('UWOC Physical Channel Validation');
grid on;
hold off;
