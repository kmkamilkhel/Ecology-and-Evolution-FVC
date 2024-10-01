// Load the study area from a shapefile 
var studyArea = ee.FeatureCollection("users/your_username/studyArea"); 

// date ranges
var startDate = '2000-01-01';
var endDate = '2023-12-31';

// Function to mask clouds using the QA pixel band (for Landsat 5, 7, and 8)
function maskLandsatClouds(image) {
  var qa = image.select('QA_PIXEL'); // Select the QA_PIXEL band
  
  // Create a mask for cloud-free pixels based on cloud confidence
  var cloudMask = qa.bitwiseAnd(1 << 3).eq(0)  
    .and(qa.bitwiseAnd(1 << 5).eq(0));        
  
  return image.updateMask(cloudMask);
}

// Function to calculate NDVI
function calculateNDVI(image) {
  var ndvi = image.normalizedDifference(['B5', 'B4']).rename('NDVI'); // Landsat 8
  return image.addBands(ndvi);
}

// Function to process Landsat collection
function processLandsatCollection(collection, bandNames) {
  return collection
    .filterBounds(studyArea) 
    .filterDate(startDate, endDate) 
    .map(maskLandsatClouds) 
    .map(calculateNDVI) 
    .select(bandNames.concat('NDVI')); 
}

// Load Landsat collections
var landsat5 = ee.ImageCollection('LANDSAT/LT05/C02/T1_L2');
var landsat7 = ee.ImageCollection('LANDSAT/LE07/C02/T1_L2');
var landsat8 = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2');

// Process each Landsat collection
var landsat5Processed = processLandsatCollection(landsat5, ['B3', 'B4', 'B5', 'QA_PIXEL']); // Landsat 5
var landsat7Processed = processLandsatCollection(landsat7, ['B3', 'B4', 'B5', 'QA_PIXEL']); // Landsat 7
var landsat8Processed = processLandsatCollection(landsat8, ['B4', 'B5', 'B6', 'QA_PIXEL']); // Landsat 8

// Merge all Landsat collections
var allLandsat = landsat5Processed.merge(landsat7Processed).merge(landsat8Processed);

// Print the collection to the console to check
print('Landsat Collection:', allLandsat);

// Export 
Export.image.toDrive({
  image: allLandsat.median().select('NDVI'),
  description: 'NDVI_Composite',
  scale: 30,
  region: studyArea,
  maxPixels: 1e13
});

// Time-series chart to visualize NDVI
var ndviChart = ui.Chart.image.series({
  imageCollection: allLandsat.select('NDVI'),
  region: studyArea,
  reducer: ee.Reducer.mean(),
  scale: 30,
  xProperty: 'system:time_start'
})
  .setOptions({
    title: 'NDVI Time Series',
    vAxis: {title: 'NDVI'},
    hAxis: {title: 'Date'}
  });

print(ndviChart);
