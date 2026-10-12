
clc;
clear;
close all;

% STEP 1: Load the trained AI model
load('uwoc_power_ai_model.mat', 'model');

% STEP 2: Define operating conditions
Pt_mW = 1.0;                 % Transmit power in mW
c = 0.30;                    % Attenuation coefficient in 1/m
distances = 1:0.1:20;        % Candidate distances in metres

% Minimum required received optical power
minPower_dBm = -20;

% STEP 3: Prepare input for the AI model
Xcandidate = [ ...
    Pt_mW * ones(length(distances), 1), ...
    c * ones(length(distances), 1), ...
    distances(:)];

% STEP 4: Predict received power using AI
predictedPower_dBm = predict(model, Xcandidate);

% STEP 5: Calculate theoretical received power
actualPower_dBm = 10*log10(Pt_mW) ...
                  - 4.343*c*distances;

% STEP 6: Find the maximum distance using the AI prediction
validAI = predictedPower_dBm >= minPower_dBm;

if any(validAI)
    bestAIDistance = max(distances(validAI));
else
    bestAIDistance = NaN;
end

% STEP 7: Validate using the theoretical channel model
validTheory = actualPower_dBm >= minPower_dBm;

if any(validTheory)
    bestTheoryDistance = max(distances(validTheory));
else
    bestTheoryDistance = NaN;
end

% STEP 8: Display results
fprintf('\n--- UWOC AI Optimization Results ---\n');
fprintf('Transmit power: %.2f mW\n', Pt_mW);
fprintf('Attenuation coefficient: %.2f 1/m\n', c);
fprintf('Minimum required power: %.2f dBm\n', minPower_dBm);

if ~isnan(bestAIDistance)
    fprintf('AI-predicted maximum distance: %.2f m\n', ...
        bestAIDistance);
    aiPowerAtDistance = interp1(distances, ...
        predictedPower_dBm, bestAIDistance);
    fprintf('AI-predicted power at that distance: %.2f dBm\n', ...
        aiPowerAtDistance);
else
    fprintf('AI prediction: No candidate meets the threshold.\n');
end

if ~isnan(bestTheoryDistance)
    fprintf('Theoretical maximum candidate distance: %.2f m\n', ...
        bestTheoryDistance);
    fprintf('Theoretical power at that distance: %.2f dBm\n', ...
        actualPower_dBm(find(distances == bestTheoryDistance, 1)));
else
    fprintf('Theory: No candidate meets the threshold.\n');
end

% STEP 9: Plot AI prediction and theoretical channel power
figure;

plot(distances, predictedPower_dBm, ...
    'b-', 'LineWidth', 1.5);
hold on;

plot(distances, actualPower_dBm, ...
    'k--', 'LineWidth', 1.5);

yline(minPower_dBm, 'r:', ...
    'Minimum required power');

if ~isnan(bestTheoryDistance)
    xline(bestTheoryDistance, 'g-.', ...
        'Theoretical limit');
end

xlabel('Underwater Distance (m)');
ylabel('Received Optical Power (dBm)');
title('UWOC AI-Based Distance Optimization');

legend('AI prediction', 'Theoretical channel', ...
    'Power threshold', 'Theoretical limit', ...
    'Location', 'best');

grid on;
hold off;

% STEP 10: Calculate AI prediction errors
MAE = mean(abs(predictedPower_dBm - actualPower_dBm));
RMSE = sqrt(mean((predictedPower_dBm - actualPower_dBm).^2));

fprintf('\n--- AI Prediction Error ---\n');
fprintf('MAE: %.4f dB\n', MAE);
fprintf('RMSE: %.4f dB\n', RMSE);

% STEP 16: Analyze AI prediction error

predictionError = predictedPower_dBm - actualPower_dBm;

figure;
plot(distances, predictionError, ...
    'm-', 'LineWidth', 1.5);

yline(0, 'k--');

xlabel('Underwater Distance (m)');
ylabel('AI Prediction Error (dB)');
title('UWOC AI Prediction Error vs Distance');
grid on;

fprintf('\nMean absolute error: %.4f dB\n', ...
    mean(abs(predictionError)));

fprintf('Root mean square error: %.4f dB\n', ...
    sqrt(mean(predictionError.^2)));

