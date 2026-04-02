# Prediction of Net Hourly Electrical Energy Output

This repository contains the final project for the Coursera course **"Machine Learning Foundations for Product Managers."** The objective is to build a high-precision regression model to predict the electrical energy output of a Combined Cycle Power Plant (CCPP) based on environmental sensor data.

## 📺 Project Demo
You can view the full 5-minute technical presentation and notebook walk-through here:
[**Download/Watch Demo Video**](https://github.com/Takuya-Maekawa1982/prediction_for_Net_hourly_electrical_energy_output/blob/main/Coursera_Final_Project_Predictiong%20CCPP_Enrgy_Output.mp4)

---

## 🚀 Project Overview
* **Task:** Supervised Learning (Regression)
* **Features:** Ambient Temperature (AT), Exhaust Vacuum (V), Ambient Pressure (AP), and Relative Humidity (RH).
* **Target:** Net Hourly Electrical Energy Output (PE).
* **Tools:** Python, VS Code, PyCaret, Scikit-Learn, SHAP.

## 📊 Key Results
* **Best Model:** High-Capacity Extra Trees Regressor (300 estimators).
* **R-squared ($R^2$):** 96.1%
* **Mean Absolute Error (MAE):** 2.35 MW
* **Key Finding:** Ambient Temperature is the strongest driver of energy output, confirming thermodynamic principles (the 'Cold and Tight' rule).

## 🛠️ How to use
The analysis is contained within the `Final_Project.ipynb` notebook. It includes data exploration, model comparison via PyCaret, hyperparameter optimization, and model interpretation using SHAP values.
