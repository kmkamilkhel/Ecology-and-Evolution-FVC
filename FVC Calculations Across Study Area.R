# Clean environment
rm(list = ls(all = TRUE))
graphics.off()
gc()

# Load required libraries
library(terra)

# Function to calculate FVC for a region
calculate_fvc <- function(ndvi_folder, output_folder, start_date = "2000-03-01") {
  
  # Load NDVI rasters
  ndvi_list <- list.files(path = ndvi_folder, pattern = "tif$", full.names = TRUE)
  ndvi_spatraster <- rast(lapply(ndvi_list, terra::rast))
  
  # Assign dates to layers
  year_dates <- seq.Date(from = as.Date(start_date), by = "year", length.out = nlyr(ndvi_spatraster))
  time(ndvi_spatraster) <- year_dates
  
  # Calculate global min/max NDVI
  overall_stats <- global(ndvi_spatraster, fun = c('min', 'max'), na.rm = TRUE)
  NDVI_min_global <- overall_stats[1, "min"]
  NDVI_max_global <- overall_stats[1, "max"]
  
  # Function to compute FVC
  calculate_FVC_global <- function(ndvi_layer) {
    fvc_layer <- ((ndvi_layer - NDVI_min_global) / (NDVI_max_global - NDVI_min_global))^2
    clamp(fvc_layer, lower = 0, upper = 1)
  }
  
  # Apply FVC calculation
  fvc_spatraster <- app(ndvi_spatraster, calculate_FVC_global)
  
  # Save FVC rasters
  names(fvc_spatraster) <- paste0("FVC_", names(fvc_spatraster))
  for (i in 1:nlyr(fvc_spatraster)) {
    writeRaster(fvc_spatraster[[i]], paste0(output_folder, "/", names(fvc_spatraster)[i], ".tif"), overwrite = TRUE)
  }
}

# Example usage for a region
calculate_fvc(
  ndvi_folder = "E:/Path/to/KpkAnnualsTiff/",
  output_folder = "E:/Path/to/FVC_Results_KPK/"
)
