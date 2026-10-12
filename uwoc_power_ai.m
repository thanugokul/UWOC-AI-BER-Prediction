
clc;
clear;
close all;

% Step 1: Generate training data
rng(10);

N = 500;
Pt_mW = 0.5 + 1.5*rand(N,1);
c = 0.1 + 0.5*rand(N,1);
d = 1 + 19*rand(N,1);

% Step 2: Calculate received power
loss_dB = 4.343 .* c .* d;
Pr_dBm = 10*log10(Pt_mW) - loss_dB;

% Step 3: Prepare AI inputs and target
X = [Pt_mW, c, d];
Y = Pr_dBm;

% Step 4: Split into training and testing data
idx = randperm(N);
nTrain = round(0.8*N);

trainIdx = idx(1:nTrain);
testIdx = idx(nTrain+1:end);

% Step 5: Train a regression model
model = fitrensemble(X(trainIdx,:), Y(trainIdx), ...
    'Method','Bag', 'NumLearningCycles',100);

% Step 6: Predict received power
Ypred = predict(model, X(testIdx,:));

% Step 7: Evaluate the model
MAE = mean(abs(Y(testIdx)-Ypred));
RMSE = sqrt(mean((Y(testIdx)-Ypred).^2));

fprintf('Test MAE: %.4f dB\n', MAE);
fprintf('Test RMSE: %.4f dB\n', RMSE);

% Step 8: Plot actual vs predicted power
figure;
scatter(Y(testIdx), Ypred, 'filled');
hold on;

lims = [min(Y(testIdx)), max(Y(testIdx))];
plot(lims, lims, 'k--', 'LineWidth',1.5);

xlabel('Actual Received Power (dBm)');
ylabel('Predicted Received Power (dBm)');
title('UWOC AI Power Prediction');
grid on;
hold off;

% Step 9: Save the model
save('uwoc_power_ai_model.mat','model');
