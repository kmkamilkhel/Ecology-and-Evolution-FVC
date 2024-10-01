# **Ecology and Evolution of Fractional Vegetation Cover (FVC)**

**Repository Overview**  
This repository contains the datasets, R scripts, and Google Earth Engine (GEE) code used to analyze the spatiotemporal dynamics of Fractional Vegetation Cover (FVC) across various regions. The project integrates machine learning models and environmental predictors such as precipitation, temperature, soil moisture, and other climatic variables to forecast and analyze vegetation dynamics over time. This data has been used in the manuscript and made available for open access.

---

### **Table of Contents**
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
   - [Overview of Datasets](#overview-of-datasets)
3. [Methods and Preprocessing](#methods-and-preprocessing)
   - [NDVI Calculation and Cloud Correction](#ndvi-calculation-and-cloud-correction)
   - [Machine Learning Models](#machine-learning-models)
   - [Trend Analysis](#trend-analysis)
4. [Usage](#usage)
5. [How to Cite](#how-to-cite)
6. [License](#license)

---

### **Introduction**
This project aims to explore the spatiotemporal patterns of Fractional Vegetation Cover (FVC) using Landsat-derived Normalized Difference Vegetation Index (NDVI) data and various environmental predictors. The analysis spans across different landscapes, with an emphasis on forecasting vegetation cover changes in response to environmental variables.

---

### **Data Sources**

#### Overview of Datasets

| Variable        | Description                       | Source             | Spatial Resolution | Temporal Span  | References |
|-----------------|-----------------------------------|--------------------|--------------------|----------------|------------|
| Precipitation   | Rainfall measurements             | CHIRPS             | 5 km               | Monthly        | de Sousa et al., 2020; Funk et al., 2015; Peterson et al., 2013 |
| Temperature     | Air temperature                   | Terra Climate      | 4.5 km             | Monthly        | Abatzoglou et al., 2018; Ruhoff et al., 2022; Xu et al., 2023   |
| VPD             | Vapor Pressure Deficit            | Terra Climate      | 4.5 km             | Monthly        | Various    |
| Solar Radiation | Solar radiation                   | Terra Climate      | 4.5 km             | Monthly        | Various    |
| Soil Moisture   | Soil moisture levels              | ESA CCI            | 0.25 degrees       | Monthly        | Various    |
| FVC             | Fractional Vegetation Cover (NDVI)| USGS (Landsat 5, 7, 8) | 30 meters          | 16 days        | Crawford et al., 2023; Loveland and Dwyer, 2012; Mehmood et al., 2024b |

These datasets were crucial in constructing the environmental predictor variables used in the machine learning models and trend analysis. Each dataset was carefully preprocessed to ensure accurate model performance.

---

### **Methods and Preprocessing**

#### 1. **NDVI Calculation and Cloud Correction**
Landsat data was processed in **Google Earth Engine (GEE)** to extract NDVI values, ensuring cloud correction using the QA band. A custom GEE script handles the preprocessing steps, including:
- **Cloud Masking**: Using the QA_PIXEL band for Landsat imagery to filter out cloud and shadow pixels.
- **NDVI Calculation**: Using the NIR and Red bands to compute NDVI for each time step.

##### Example Script: 
[NDVI Calculation GEE Script](#) (Link to GEE code).

#### 2. **Machine Learning Models**
To predict FVC, machine learning models were applied using environmental predictors. The following models were implemented using the **caret** package in R:
- **XGBoost**
- **Random Forest**
- **SVM (Support Vector Machines)**
- **KNN (K-Nearest Neighbors)**

##### Preprocessing:
- **Feature Engineering**: Rasters were stacked, and corresponding samples were extracted for model training and evaluation.
- **Cross-Validation**: Repeated cross-validation was used to tune hyperparameters.
- **Metrics**: Models were evaluated based on RMSE, MSE, MAE, and R-squared.

##### Example Scripts:
- [FVC Distribution Scripts](#) (Link to R scripts for FVC analysis)
- [Machine Learning Code](#) (Link to Machine Learning model scripts)

#### 3. **Trend Analysis**
Trend analysis was conducted using **linear regression** in ArcGIS to identify significant vegetation cover trends over time. The process involved:
- **Data**: NDVI data over the 2000–2023 period.
- **Method**: Linear regression was applied to each pixel's NDVI time series to assess positive or negative vegetation trends.
- **Outputs**: Trend raster maps identifying areas with increasing or decreasing vegetation cover.

##### Example Workflow:
1. **NDVI Time-Series Data**: Preprocessed NDVI data was input into ArcGIS for regression.
2. **Linear Regression**: Performed pixel-wise across the time series.
3. **Trend Map Export**: Exported maps display areas with statistically significant trends.

---

### **Usage**

To replicate this analysis or use the provided scripts and datasets, follow these steps:

1. **Google Earth Engine (GEE)**:  
   - Load the [NDVI Calculation Script](#) to extract and preprocess Landsat data for your region.
   - Adjust the study area and date range in the script as needed.

2. **R Scripts for Machine Learning**:  
   - Use the provided R scripts for machine learning-based FVC prediction.
   - Input your data into the script, ensuring that raster stacks and environmental predictor datasets are in the required format.

3. **Trend Analysis in ArcGIS**:  
   - Import the NDVI time-series data into ArcGIS.
   - Apply the linear regression tool to generate trend maps, which can be used to detect significant vegetation changes over time.

---

### **How to Cite**
Please cite this repository in your work as:

> Author Name, *Ecology and Evolution of Fractional Vegetation Cover: A Spatiotemporal Analysis Using Machine Learning and Trend Detection*, GitHub Repository, Year.

---

### **License**
This project is licensed under the **MIT License** – see the [LICENSE](./LICENSE) file for details.

---

This README reflects the datasets, methods, and analyses used in your manuscript, ensuring that it’s aligned with open science practices and easy for others to follow and replicate.
