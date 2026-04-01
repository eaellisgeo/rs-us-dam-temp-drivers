Code needed for this section was designed by: 
Kratzert, F., Nearing, G., Addor, N., Erickson, T., Gauch, M., Gilon, O., et al. (2023). Caravan - A global community dataset for large-sample hydrology. Scientific Data, 10(1), 61. https://doi.org/10.1038/s41597-023-01975-w

Notebooks and utility scripts should be downloaded directly at: https://github.com/kratzert/Caravan/tree/main/code

This project's (Ellis et al. ) edits and parameters have also been noted in the section Readme. The local processing notebook has been provided for reference on minor edits to naming and paths.

________________________________________________________________________________________________________________________________________________
This step uses Caravan to pull meteorological and climatological data. 

For Part 1 (File: Caravan_part1_Earth_Engine.ipynb), no edits were made beyond inserting filepaths. This section was run for GEE via Google Colab. This file is not included in this GitHub repository.
Part 1 Inputs: "HUC7_Basins_of_Interest.shp" (uploaded to GEE as an Asset); Selecting File Outputs and prefixes; Updates to my study times

For Part2 (File: Caravan_part2_local_postprocessing.ipynb), few edits were made beyond inserting filepaths. This section was run locally. 
A copy of this file,noted by "_Ellis_etal", is included for reference. Comments inserted throughout  to note where I have inserted Updates.

Inputs (P2): "Hydro7_Basins_Centroids.shp" (created these in ArcGIS -- from the HydroBasin file)

Outputs: "attributes_caravan_Dams_HA_Hydro7.csv"; "attributes_hydroatlas_Dams_HA_Hydro7.csv"; "attributes_other_Dams_HA_Hydro7.csv"
