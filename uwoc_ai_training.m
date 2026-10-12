
clc;
clear;
close all;

% STEP 1: Load the UWOC dataset
data = readtable('uwoc_ai_dataset.csv');

% STEP 2: Prepare input features
X = [data.TransmitPower_mW, ...
    data.Attenuation_1_per_m, ...
    data.Distance_m];

% STEP 3: Prepare the BER prediction target
Y = data.BER;

% Convert BER into logarithmic scale
Ylog = log10(max(Y, 1e-30));

% STEP 4: Split data into training and testing sets
rng(10);

cv = cvpartition(height(data), 'HoldOut', 0.20);

Xtrain = X(training(cv), :);
Xtest  = X(test(cv), :);

Ytrain = Ylog(training(cv));
Ytest  = Ylog(test(cv));

% STEP 5: Train the regression ensemble model
model = fitrgp(Xtrain, Ytrain, ...
    'KernelFunction', 'ardsquaredexponential', ...
    'Standardize', true);

% STEP 6: Predict BER for unseen test data
Ypred = predict(model, Xtest);

% STEP 7: Calculate evaluation metrics
MAE = mean(abs(Ytest - Ypred));

RMSE = sqrt(mean((Ytest - Ypred).^2));

fprintf('\nUWOC AI Model Evaluation\n');
fprintf('-----------------------\n');
fprintf('Total dataset rows: %d\n', height(data));
fprintf('Training samples: %d\n', size(Xtrain, 1));
fprintf('Testing samples: %d\n', size(Xtest, 1));
fprintf('Test MAE in log10(BER): %.4f\n', MAE);
fprintf('Test RMSE in log10(BER): %.4f\n', RMSE);

% STEP 8: Plot actual versus predicted log10(BER)
figure;

scatter(Ytest, Ypred, 45, 'filled');
hold on;

limits = [min([Ytest; Ypred]), ...
    max([Ytest; Ypred])];

plot(limits, limits, 'k--', 'LineWidth', 1.5);

xlabel('Actual log10(BER)');
ylabel('Predicted log10(BER)');

title('UWOC AI: Actual vs Predicted BER');

legend('Test predictions', ...
    'Ideal prediction', ...
    'Location', 'best');

grid on;
axis square;
hold off;

% STEP 9: Save the trained BER prediction model
save('uwoc_ber_model.mat', 'model');

fprintf('\nBER model saved as uwoc_ber_model.mat\n');
fprintf('Training completed successfully.\n');
% Test BER prediction for a new UWOC condition
Pt_mW = 1.5;
attenuation = 0.25;
distance = 8;

newInput = [Pt_mW, attenuation, distance];

predictedLogBER = predict(model, newInput);
predictedBER = 10^predictedLogBER;

fprintf('\nNew UWOC condition:\n');
fprintf('Transmit power: %.2f mW\n', Pt_mW);
fprintf('Attenuation: %.2f per meter\n', attenuation);
fprintf('Distance: %.2f m\n', distance);
fprintf('Predicted log10(BER): %.4f\n', predictedLogBER);
fprintf('Predicted BER: %.4e\n', predictedBER);