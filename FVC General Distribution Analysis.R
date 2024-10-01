# Clean up the environment
rm(list = ls(all=TRUE))
graphics.off()
gc()

# Load required libraries
library(terra)
library(exactextractr)
library(sf)
library(ggplot2)
library(ggspatial)

# Set working directory (adjust based on your structure)
setwd("E:/Path/to/Analysis/FVC_Distribution/")

# Function to process FVC data and perform classification
process_fvc <- function(fvc_folder, output_mean_tif, output_sd_tif, shp_file, output_csv, output_shp) {
  
  # Load the rasters from the given folder
  fvc_list <- list.files(path = fvc_folder, pattern = "tif$", full.names = TRUE)
  rasters <- lapply(fvc_list, terra::rast)
  fvc_spatraster <- rast(rasters)
  
  # Calculate mean and standard deviation
  mean_fvc <- mean(fvc_spatraster, na.rm = TRUE)
  sd_fvc <- app(fvc_spatraster, fun = sd, na.rm = TRUE)
  
  # Classification functions for mean and SD
  classify_mean <- function(x) {
    ifelse(x < 0.2, 1, ifelse(x < 0.4, 2, ifelse(x < 0.6, 3, ifelse(x < 0.8, 4, 5))))
  }
  
  classify_sd <- function(x) {
    ifelse(x < 0.05, 1, ifelse(x < 0.10, 2, ifelse(x < 0.15, 3, ifelse(x < 0.20, 4, 5))))
  }
  
  # Apply classification
  mean_fvc_class <- app(mean_fvc, classify_mean)
  sd_fvc_class <- app(sd_fvc, classify_sd)
  
  # Save the classified rasters
  writeRaster(mean_fvc_class, output_mean_tif, overwrite = TRUE)
  writeRaster(sd_fvc_class, output_sd_tif, overwrite = TRUE)
  
  # Load shapefile
  region_shp <- vect(shp_file)
  region_sf <- st_as_sf(region_shp)
  
  # Extract mean FVC per district
  mean_fvc_raster <- raster(mean_fvc) # Convert to RasterLayer for exactextractr
  fvc_stats <- exact_extract(mean_fvc_raster, region_sf, fun = 'mean', progress = FALSE)
  
  # Assign extracted values to shapefile and save
  region_sf$mean_fvc <- unlist(fvc_stats)
  region_fvc_subset <- region_sf[, c('ADM2_EN', 'mean_fvc')]
  
  # Save results
  write.csv(st_drop_geometry(region_fvc_subset), output_csv, row.names = FALSE)
  st_write(region_fvc_subset, output_shp, delete_layer = TRUE)
  
  # Plot
  ggplot(data = region_sf) +
    geom_sf(aes(fill = mean_fvc), color = NA) +
    scale_fill_viridis_c(option = "C", name = "Mean FVC (%)") +
    labs(title = "Mean Fractional Vegetation Cover (FVC) by District") +
    theme_classic(base_size = 14) +
    theme(legend.position = "right",
          text = element_text(face = "bold", color = "black"),
          plot.title = element_text(hjust = 0.5)) +
    annotation_north_arrow(location = "tl", which_north = "true", 
                           pad_x = unit(0.05, "in"), pad_y = unit(0.05, "in"), 
                           style = north_arrow_fancy_orienteering)
}

# Example usage for a specific region
process_fvc(
  fvc_folder = "E:/Path/to/FVC_Results_KPK/",
  output_mean_tif = "fvcClasses4PlotKPK.tif",
  output_sd_tif = "SdClasses4PlotKPK.tif",
  shp_file = "E:/Path/to/KPKDistricts.shp",
  output_csv = "kpk_fvc_subset.csv",
  output_shp = "kpk_fvc_subset.shp"
)
