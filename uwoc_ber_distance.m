
clc;
clear;
close all;

% UWOC BER versus distance simulation
rng(10);                 % Reproducible random results

N = 100000;               % Number of transmitted bits
Rb = 10e6;                 % Bit rate: 10 Mbps
samplesPerBit = 20;        % Samples per bit

Pt = 1e-3;                 % ON optical power: 1 mW
responsivity = 0.5;        % Photodetector responsivity: A/W
c = 0.30;                  % Water attenuation coefficient: 1/m
noiseStd = 1e-5;           % Assumed current-noise std. dev.: A

distances = [1 2 3 5 7 10];
BER = zeros(size(distances));

% Generate one bit sequence for all distances
bits = randi([0 1], 1, N);

% Repeat each bit to create the OOK optical signal
opticalPower = repelem(Pt * bits, samplesPerBit);

for k = 1:length(distances)

    % Underwater attenuation
    loss_dB = 4.343 * c * distances(k);
    receivedPower = opticalPower * 10^(-loss_dB/10);

    % PIN photodetector
    photocurrent = responsivity * receivedPower;

    % Add receiver noise
    noisyCurrent = photocurrent + ...
        noiseStd * randn(size(photocurrent));

    % Sample near the centre of each bit
    sampleIndex = round(samplesPerBit/2): ...
        samplesPerBit:(N*samplesPerBit);

    sampledCurrent = noisyCurrent(sampleIndex);

    % Detection threshold
    threshold = responsivity * Pt * ...
        10^(-loss_dB/10) / 2;

    receivedBits = sampledCurrent > threshold;

    % Calculate BER
    errors = sum(bits ~= receivedBits);
    BER(k) = errors / N;

    fprintf('Distance: %2d m | BER: %.6g | Errors: %d\n', ...
        distances(k), BER(k), errors);
end

% Plot BER against distance
figure;
semilogy(distances, max(BER, 0.5/N), '-o', ...
    'LineWidth', 1.5);

xlabel('Underwater Distance (m)');
ylabel('Bit Error Rate (BER)');
title('UWOC BER vs Distance');
grid on;

% Display the results in a table
results = table(distances', BER', ...
    'VariableNames', {'Distance_m', 'BER'});

disp(results);
writetable(results, 'uwoc_ber_results.csv');