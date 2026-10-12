
clc;
clear;
close all;

% STEP 1: Generate a larger UWOC dataset
rng(10);

Pt_values = 0.5:0.1:2.0;       % Transmit power in mW
c_values = 0.10:0.025:0.60;    % Attenuation coefficient in 1/m
distances = 1:1:20;             % Distance in metres

R = 0.5;                        % PIN responsivity in A/W
noiseStd = 1e-5;                % Receiver noise standard deviation in A

% STEP 2: Create all parameter combinations
[PtGrid, cGrid, dGrid] = ndgrid( ...
    Pt_values, c_values, distances);

Pt_mW = PtGrid(:);
attenuation = cGrid(:);
distance = dGrid(:);

% STEP 3: Calculate received power and theoretical BER
Pr = Pt_mW .* 1e-3 .* ...
    10.^(-4.343 .* attenuation .* distance ./ 10);

I1 = R .* Pr;
threshold = I1 ./ 2;

BER = 0.5 .* erfc( ...
    threshold ./ (sqrt(2) .* noiseStd));

% STEP 4: Create the table
data = table(Pt_mW, attenuation, distance, BER, ...
    'VariableNames', { ...
    'TransmitPower_mW', ...
    'Attenuation_1_per_m', ...
    'Distance_m', ...
    'BER'});

% STEP 5: Save the dataset
writetable(data, 'uwoc_ai_dataset.csv');

fprintf('Dataset generated successfully.\n');
fprintf('Total rows: %d\n', height(data));
fprintf('Minimum BER: %.4e\n', min(data.BER));
fprintf('Maximum BER: %.4e\n', max(data.BER));

% STEP 6: Plot BER versus distance
figure;
semilogy(distance, max(BER, 1e-30), '.');
xlabel('Distance (m)');
ylabel('BER');
title('UWOC BER Dataset');
grid on;
