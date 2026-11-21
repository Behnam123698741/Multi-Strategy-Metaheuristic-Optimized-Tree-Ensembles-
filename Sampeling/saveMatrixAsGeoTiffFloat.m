function outFile = saveMatrixAsGeoTiffFloat(refFile, dataMatrix, outFile, varargin)
% saveMatrixAsGeoTiffFloat
% Saves a non-georeferenced matrix as a Float32 GeoTIFF using a reference GeoTIFF.
%
% INPUTS:
%   refFile    : path to reference GeoTIFF (georeferenced)
%   dataMatrix : non-georeferenced matrix (e.g., frequencymap)
%   outFile    : output GeoTIFF path (e.g., "frequencymap_float_georef.tif")
%
% OPTIONAL (Name-Value):
%   "ResampleMethod" : "bilinear" (default) | "nearest" | "bicubic"
%   "NoDataValue"    : numeric value to write instead of NaN (default: [])
%   "Verbose"        : true/false (default: true)
%
% OUTPUT:
%   outFile : output filepath (same as input outFile)
%
% Example:
%   out = saveMatrixAsGeoTiffFloat("JRC_PermanentWater_Khozestan.tif", frequencymap, ...
%                                 "frequencymap_float_georef.tif", ...
%                                 "ResampleMethod","bilinear","NoDataValue",-9999);

% -------------------------
% Parse inputs
% -------------------------
p = inputParser;
p.addRequired("refFile", @(x) isstring(x) || ischar(x));
p.addRequired("dataMatrix", @(x) isnumeric(x) && ismatrix(x));
p.addRequired("outFile", @(x) isstring(x) || ischar(x));

p.addParameter("ResampleMethod", "bilinear", @(x) isstring(x) || ischar(x));
p.addParameter("NoDataValue", [], @(x) isempty(x) || (isnumeric(x) && isscalar(x)));
p.addParameter("Verbose", true, @(x) islogical(x) && isscalar(x));

p.parse(refFile, dataMatrix, outFile, varargin{:});
opt = p.Results;

refFile = string(opt.refFile);
outFile = string(opt.outFile);

% -------------------------
% Read reference GeoTIFF
% -------------------------
[refImg, Rref] = readgeoraster(refFile);
infoRef = geotiffinfo(refFile);

if opt.Verbose
    fprintf("Reference file: %s\n", refFile);
    fprintf("Reference raster size: %d x %d\n", size(refImg,1), size(refImg,2));
    fprintf("Reference class: %s\n", class(refImg));
end

% -------------------------
% Validate and resize matrix if needed
% -------------------------
freq = dataMatrix;

% Ensure 2D
if ~ismatrix(freq)
    error("dataMatrix must be a 2D matrix.");
end

% If reference is multi-band, take size from first band
refSize = [size(refImg,1), size(refImg,2)];

if ~isequal(size(freq), refSize)
    if opt.Verbose
        fprintf("Input matrix size: %d x %d (will be resampled to %d x %d) using %s\n", ...
            size(freq,1), size(freq,2), refSize(1), refSize(2), opt.ResampleMethod);
    end
    freq = imresize(freq, refSize, opt.ResampleMethod);
end

% -------------------------
% Convert to Float32
% -------------------------
freqFloat = single(freq);

% Apply NoData if requested
if ~isempty(opt.NoDataValue)
    nodata = single(opt.NoDataValue);
    freqFloat(isnan(freqFloat)) = nodata;
end

% -------------------------
% Write GeoTIFF
% -------------------------
geoKeys = infoRef.GeoTIFFTags.GeoKeyDirectoryTag;

geotiffwrite(outFile, freqFloat, Rref, ...
    "GeoKeyDirectoryTag", geoKeys);

if opt.Verbose
    fprintf("Saved GeoTIFF (Float32): %s\n", outFile);
end
end
%%%%%%
%refFile = "JRC_PermanentWater_Khozestan.tif";
%freq = frequencymap;

%outFile = "frequencymap_float_georef.tif";

%saveMatrixAsGeoTiffFloat(refFile, freq, outFile, ...
    %"ResampleMethod", "bilinear", ...
    %"NoDataValue", -9999, ...
   % "Verbose", true);
