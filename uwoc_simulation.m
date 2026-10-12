
clc;
clear;
close all;

% STEP 1: Generate binary data
N = 20;
bits = randi([0 1], 1, N);

disp('Transmitted binary data:');
disp(bits);

% STEP 2: Create OOK optical power signal
Rb = 10e6;
Tb = 1/Rb;
samplesPerBit = 100;

P1 = 1e-3;    % Optical power for bit 1: 1 mW
P0 = 0;       % Optical power for bit 0: 0 mW

opticalPower = repelem( ...
    P0 + (P1-P0)*bits, samplesPerBit);

time = (0:length(opticalPower)-1) ...
    * Tb/samplesPerBit;

% STEP 3: Underwater channel parameters
distance = 5;              % Distance in metres
c = 0.30;                   % Attenuation coefficient (1/m)

% Calculate water attenuation
loss_dB = 4.343*c*distance;

% Calculate received optical power
receivedPower = opticalPower * 10^(-loss_dB/10);

% STEP 4: Plot transmitted and received signals
figure;

plot(time*1e6, opticalPower*1e3, ...
    'LineWidth', 1.5);
hold on;

plot(time*1e6, receivedPower*1e3, ...
    '--', 'LineWidth', 1.5);

xlabel('Time (microseconds)');
ylabel('Optical Power (mW)');
title('UWOC Transmitted vs Received Optical Signal');

legend('Transmitted signal', 'Received signal');
grid on;
hold off;

% Display results
fprintf('Distance: %.1f m\n', distance);
fprintf('Attenuation coefficient: %.2f 1/m\n', c);
fprintf('Water attenuation: %.3f dB\n', loss_dB);
fprintf('Received ON power: %.4f mW\n', P1*10^(-loss_dB/10)*1e3);


% STEP 4: PIN photodetector model

responsivity = 0.5;  % Responsivity in A/W

% Convert received optical power to electrical current
photocurrent = responsivity * receivedPower;

% Display received current for an ON bit
received_on_power = P1 * 10^(-loss_dB/10);
received_on_current = responsivity * received_on_power;

fprintf('Photodetector responsivity: %.2f A/W\n', responsivity);
fprintf('Received ON current: %.6f mA\n', received_on_current*1e3);

% Plot photodetector output
figure;
plot(time*1e6, photocurrent*1e3, 'LineWidth', 1.5);

xlabel('Time (microseconds)');
ylabel('Photocurrent (mA)');
title('UWOC PIN Photodetector Output');
grid on;


% STEP 5: Add receiver noise

noiseStd = 1e-5;  % Illustrative noise standard deviation in amperes

noise = noiseStd * randn(size(photocurrent));

noisyCurrent = photocurrent + noise;

% Plot clean and noisy photocurrent
figure;

plot(time*1e6, photocurrent*1e3, 'b', ...
    'LineWidth', 1.5);
hold on;

plot(time*1e6, noisyCurrent*1e3, 'r');

xlabel('Time (microseconds)');
ylabel('Photocurrent (mA)');
title('UWOC Receiver: Clean vs Noisy Signal');

legend('Clean signal', 'Noisy signal');
grid on;
hold off;


% STEP 6: Detect received bits and calculate BER

% Sample at the middle of each bit
sampleIndex = round(samplesPerBit/2):samplesPerBit:length(noisyCurrent);
sampledCurrent = noisyCurrent(sampleIndex);

% Decision threshold: halfway between OFF and ON currents
threshold = responsivity * received_on_power / 2;

% Detect bits
receivedBits = sampledCurrent > threshold;

% Compare transmitted and received bits
errors = sum(bits ~= receivedBits);
BER = errors / N;

% Display results
disp('Transmitted bits:');
disp(bits);

disp('Received bits:');
disp(double(receivedBits));

fprintf('Number of bit errors: %d\n', errors);
fprintf('Total number of bits: %d\n', N);
fprintf('Bit Error Rate (BER): %.4f\n', BER);
