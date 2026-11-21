function floodPoints = sampleFloodByDensityAndGrid(flood_prob, flood_thresh, density_thresh, windowSize, maxSamples, gridSize)
%floodPoints = sampleFloodByDensityAndGrid(frequencymap, 0.4, 0.7, 11, 2200, 100);    
if nargin < 2, flood_thresh = 0.5; end
    if nargin < 3, density_thresh = 0.9; end
    if nargin < 4, windowSize = 21; end
    if nargin < 5, maxSamples = 500; end
    if nargin < 6, gridSize = 20; end

    [rows, cols] = size(flood_prob);
    flood_mask = flood_prob >= flood_thresh;

    kernel = fspecial('average', windowSize);
    local_density = conv2(double(flood_mask), kernel, 'same');

    thresh_val = quantile(local_density(flood_mask), density_thresh);
    dense_mask = local_density >= thresh_val & flood_mask;
    [r_dense, c_dense] = find(dense_mask);
    sel_dense = randperm(length(r_dense), min(maxSamples, length(r_dense)));
    dense_points = [r_dense(sel_dense), c_dense(sel_dense)];

    non_dense_mask = flood_mask & ~dense_mask;
    grid_points = [];
    for i = 1:gridSize:rows
        for j = 1:gridSize:cols
            r_end = min(i+gridSize-1, rows);
            c_end = min(j+gridSize-1, cols);
            block_mask = non_dense_mask(i:r_end, j:c_end);
            if any(block_mask(:))
                [r_sub, c_sub] = find(block_mask, 1, 'first');
                grid_points = [grid_points; i + r_sub - 1, j + c_sub - 1];
            end
        end
    end

    all_points = [dense_points; grid_points];

    % --- پیش‌محاسبه ماتریس میانگین پنجره 20×20 ---
    halfWin = 10;
    avgKernel = fspecial('average', 2*halfWin);
    meanFloodProb = conv2(flood_prob, avgKernel, 'same');

    adjusted_points = fastAdjust(all_points, meanFloodProb, flood_thresh, 50);

    if size(adjusted_points,1) > maxSamples
        sel = randperm(size(adjusted_points,1), maxSamples);
        floodPoints = adjusted_points(sel,:);
    else
        floodPoints = adjusted_points;
    end
end

function adjusted = fastAdjust(points, meanFloodProb, flood_thresh, minDist)
    [rows, cols] = size(meanFloodProb);
    nPoints = size(points,1);
    adjusted = zeros(nPoints, 2);

    % ساخت kd-tree برای جستجوی سریع فاصله
    accepted = zeros(0,2);

    % فقط 9 جابجایی با گام 1 (شامل خود نقطه)
    shifts = [0 0; -1 0; 1 0; 0 -1; 0 1; -1 -1; -1 1; 1 -1; 1 1];

    for i = 1:nPoints
        p = points(i,:);

        found = false;
        for s = 1:size(shifts,1)
            new_p = p + shifts(s,:);

            if new_p(1) < 1 || new_p(1) > rows || new_p(2) < 1 || new_p(2) > cols
                continue
            end

            % شرط میانگین پنجره 20x20
            if meanFloodProb(new_p(1), new_p(2)) < flood_thresh
                continue
            end

            % شرط فاصله با استفاده از دایستنس باکس سریع
            if ~isempty(accepted)
                dists = sqrt((accepted(:,1) - new_p(1)).^2 + (accepted(:,2) - new_p(2)).^2);
                if any(dists < minDist)
                    continue
                end
            end

            % قبول نقطه
            adjusted(i,:) = new_p;
            accepted = [accepted; new_p];
            found = true;
            break;
        end

        if ~found
            % اگر هیچ جابجایی مناسب نبود، نقطه اصلی
            adjusted(i,:) = p;
            accepted = [accepted; p];
        end
    end
end
