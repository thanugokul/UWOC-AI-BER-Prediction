# UWOC AI-Based BER Prediction

**MATLAB Simulation and Machine Learning for Underwater Wireless Optical Communication**

## Overview

This project simulates an Underwater Wireless Optical Communication (UWOC) system and uses machine learning to predict the Bit Error Rate (BER) under different underwater channel conditions.

It investigates how transmission power, attenuation coefficient, and underwater distance affect communication reliability.

## Objectives

- Simulate an optical communication system.
- Model underwater optical attenuation using the Beer–Lambert law.
- Calculate theoretical Bit Error Rate (BER).
- Generate a dataset for machine-learning training.
- Train a regression model to predict BER.
- Compare AI predictions with theoretical results.

## Technologies Used

- MATLAB / MATLAB Online
- Gaussian Process Regression (GPR)
- Beer–Lambert attenuation model
- MATLAB tables and CSV datasets
- Machine learning and data visualization

## System Methodology

1. Define transmit power, attenuation coefficient, and distance.
2. Calculate received optical power after underwater attenuation.
3. Model photodetector current and receiver noise.
4. Calculate theoretical BER.
5. Generate a dataset across multiple channel conditions.
6. Train a regression model.
7. Evaluate predictions using MAE, RMSE, and comparison plots.

## Mathematical Model

The Beer–Lambert attenuation equation is:

\[
P_r = P_t e^{-cd}
\]

where:

- \(P_t\) = transmitted optical power
- \(P_r\) = received optical power
- \(c\) = attenuation coefficient
- \(d\) = transmission distance

## Dataset

The generated dataset contains **6,720 rows**.

| Feature | Description |
|---|---|
| `TransmitPower_mW` | Transmit power in milliwatts |
| `Attenuation_1_per_m` | Attenuation coefficient |
| `Distance_m` | Transmission distance in metres |
| `BER` | Theoretical bit error rate |

## Model Evaluation

Current random holdout evaluation:

| Metric | Result |
|---|---:|
| Training samples | 5,376 |
| Testing samples | 1,344 |
| MAE in log10(BER) | 0.1842 |
| RMSE in log10(BER) | 0.3802 |

These metrics describe prediction error on the logarithmic BER scale. Independent testing is needed to confirm performance on unseen channel conditions.

## Project Files

| File | Purpose |
|---|---|
| `uwoc_simulation.m` | Basic UWOC signal simulation |
| `uwoc_ber_distance.m` | BER versus distance analysis |
| `uwoc_ai_dataset.m` | Dataset generation |
| `uwoc_ai_training.m` | Regression model training and evaluation |
| `uwoc_ai_optimization.m` | AI-based distance analysis |
| `uwoc_power_ai.m` | Power prediction workflow |
| `uwoc_validation.m` | Channel model validation |
| `uwoc_ai_dataset.csv` | Generated dataset |
| `uwoc_ber_results.csv` | BER simulation results |
| `uwoc_ai_model.mat` | Saved model file |
| `uwoc_power_ai_model.mat` | Saved power prediction model |

## How to Run

1. Download or clone this repository.
2. Open MATLAB and navigate to the project folder.
3. Run `uwoc_ai_dataset.m` to generate the dataset.
4. Run `uwoc_ai_training.m` to train and evaluate the regression model.
5. Run `uwoc_ber_distance.m` to analyze BER versus distance.
6. Run the validation and optimization scripts as required.

Check the scripts for their input files and required MATLAB toolboxes.

## Limitations

- The dataset is mathematically simulated, not measured experimentally.
- Results depend on the selected attenuation and receiver-noise assumptions.
- Model accuracy should be checked on independent test conditions.
- This project is a simulation prototype, not a validated operational UWOC system.

## Future Improvements

- Include more realistic underwater channel effects.
- Compare multiple machine-learning algorithms.
- Add simulation graphs and output visualizations.
- Validate predictions against experimental data.

## Author

Thanugokul# UWOC-AI-BER-Prediction
MATLAB simulation and AI-based BER prediction for Underwater Wireless Optical Communication.
