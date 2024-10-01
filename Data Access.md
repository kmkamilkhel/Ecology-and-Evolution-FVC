Google Earth Engine Script for Landsat NDVI Calculation and Cloud Correction
This script automates the process of downloading Landsat imagery for a given study area, applying cloud correction, calculating NDVI, and exporting the processed data for further analysis. The code works with Landsat 5, 7, and 8 data, covering the time period from 2000 to 2023.

Features:
Study Area Integration:

The script allows you to load your study area either from a Google Earth Engine asset or from a publicly accessible GeoJSON file hosted on Google Drive or another platform.
The study area is filtered so that only relevant data within the area is downloaded and processed.
Preprocessing:

Cloud Masking: Uses the Landsat QA pixel band to mask out clouds and cloud shadows, ensuring cleaner NDVI calculations.
NDVI Calculation: NDVI is calculated using the NIR and Red bands (e.g., B5 and B4 for Landsat 8).
Multi-Sensor Support:

The script handles data from Landsat 5, 7, and 8, merging the processed data into a single collection for easy analysis.
Data Export:

The resulting NDVI data is exported to Google Drive as a GeoTIFF image. The export settings (region, scale, etc.) are fully customizable.
NDVI Time-Series Visualization:

A time-series chart of NDVI is generated, showing how vegetation has changed over time across the study area.
Usage:
Study Area:

Update the studyArea variable to load your shapefile or GeoJSON of the area. This can be done by either uploading the shapefile to Google Earth Engine as an asset or linking to a GeoJSON file.
Date Range:

The date range can be modified to focus on a different time period (currently set to 2000-2023).
Export:

The processed NDVI image is exported to Google Drive. You can adjust the scale, region, and output format as needed.
How to Run:
Log in to your Google Earth Engine account.
Paste the provided code into the GEE Code Editor.
Adjust the study area and time range to match your needs.
Run the script to process and export NDVI data for your study area.
Applications:
This script is ideal for vegetation monitoring, long-term environmental analysis, and land cover change detection using NDVI as a proxy for vegetation health.