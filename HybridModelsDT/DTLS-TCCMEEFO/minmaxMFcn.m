function NFeatures = minmaxMFcn(Features)

    [nRow, nCol] = size(Features);
    
    min_value = min(Features);
    max_value = max(Features);  
    
    min_values = repmat(min_value, [nRow 1]);
    max_values = repmat(max_value, [nRow 1]);
    
    NFeatures = (Features-min_values) ./ (max_values-min_values);

end