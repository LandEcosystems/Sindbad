"""
    DataLoaders

The `DataLoaders` module provides tools for handling and processing SINDBAD-related input data and processing. It supports reading, cleaning, masking, and managing data for SINDBAD experiments, with a focus on spatial and temporal dimensions.

# Purpose:
This module is designed to streamline the ingestion and preprocessing of input data for SINDBAD experiments. 

# Dependencies:
## Related (SINDBAD ecosystem)
- `UtilKit`: Utility functions for handling NamedTuples, printing, and shared helpers.

## External (third-party)
- `AxisKeys`: Labeled multidimensional arrays (`KeyedArray`).
- `DimensionalData`: Dimension-aware indexing/slicing.
- `FillArrays`: Efficient filled-array representations.
- `NCDatasets`: NetCDF reader/writer.
- `YAXArrays`, `YAXArrayBase`: Multidimensional array/cube abstractions used for IO and spatial data.
- `Zarr`: Chunked/compressed array storage for large datasets.

## Internal (within `Sindbad`)
- `Sindbad.Setup`
- `Sindbad.Types`
- `SindbadTEM`

# Included Files:
1. **`utilsData.jl`**:
   - Contains utility functions for data preprocessing, including cleaning, masking, and checking bounds.

2. **`spatialSubset.jl`**:
   - Implements spatial operations, such as extracting subsets of data based on spatial dimensions.

3. **`getForcing.jl`**:
   - Provides functions for extracting and processing forcing data, such as environmental drivers, for SINDBAD experiments.

4. **`getObservation.jl`**:
   - Implements utilities for reading and processing observational data, enabling model validation and performance evaluation.

# Notes:
- The module uses `NCDatasets`, `YAXArrays`, and `Zarr` directly; it does not re-export them.
- Designed to handle large datasets efficiently, leveraging chunked and compressed data formats like NetCDF and Zarr.
- Ensures compatibility with SINDBAD's experimental framework by integrating spatial and temporal data management tools.

"""
module DataLoaders
   using SindbadTEM
   using ..Setup
   using ..Types
   using UtilKit
   using AxisKeys: KeyedArray, AxisKeys
   using FillArrays
   using Dates
   using DimensionalData
   using NCDatasets: NCDataset
   import NCDatasets
   import YAXArrayBase
   using YAXArrays: YAXArrays, Cube, YAXArray
   using YAXArrays.DAT: InDims
   using Zarr

   include("utilsData.jl")
   include("spatialSubset.jl")
   include("getForcing.jl")
   include("getObservation.jl")
   
end # module DataLoaders
