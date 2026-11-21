function nonFloodPoints = sampleNonFloodByDensityAndGrid(flood_prob, region_mask, flood_thresh, density_thresh, windowSize, maxSamples, gridSize)
%nonFloodPoints = sampleNonFloodByDensityAndGrid(nonfloodprob, Mask, 0, 0.7,11,2200,100);
    if nargin < 3, flood_thresh = 0.1; end
    if nargin < 4, density_thresh = 0.9; end
    if nargin < 5, windowSize = 21; end
    if nargin < 6, maxSamples = 500; end
    if nargin < 7, gridSize = 20; end

    [rows, cols] = size(flood_prob);
    flood_prob(isnan(flood_prob)) = 0;
    A = imfill(flood_prob > flood_thresh, 'holes');
    nonFlood_mask = imcomplement(A) & region_mask;

    avgKernel = fspecial('average', 20);
    meanFloodProb = conv2(flood_prob, avgKernel, 'same');
    buffer_radius = 50;

    valid_points = [];
    attempts = 0;
    maxAttempts = 10;  % حداکثر تعداد تلاش برای رسیدن به تعداد مطلوب

    while size(valid_points, 1) < maxSamples && attempts < maxAttempts
        attempts = attempts + 1;

        % محاسبه چگالی محلی
        kernel = fspecial('average', windowSize);
        local_density = conv2(double(nonFlood_mask), kernel, 'same');

        % انتخاب نقاط پرتراکم
        thresh_val = quantile(local_density(nonFlood_mask), density_thresh);
        dense_mask = local_density >= thresh_val & nonFlood_mask;
        [r_dense, c_dense] = find(dense_mask);
        sel_dense = randperm(length(r_dense), min(maxSamples*3, length(r_dense)));  % 3 برابر

        dense_points = [r_dense(sel_dense), c_dense(sel_dense)];

        % انتخاب نقاط از گرید
        non_dense_mask = nonFlood_mask & ~dense_mask;
        grid_points = [];
        for i = 1:gridSize:rows
            for j = 1:gridSize:cols
                r_end = min(i + gridSize - 1, rows);
                c_end = min(j + gridSize - 1, cols);
                block_mask = non_dense_mask(i:r_end, j:c_end);
                if any(block_mask(:))
                    [r_sub, c_sub] = find(block_mask, 1, 'first');
                    grid_points = [grid_points; i + r_sub - 1, j + c_sub - 1];
                end
            end
        end

        all_points = [dense_points; grid_points];

        % تنظیم با فاصله حداقلی
        adjusted_points = fastAdjustNonFlood(all_points, meanFloodProb, flood_thresh, 50);

        % فیلتر شعاعی
        for k = 1:size(adjusted_points, 1)
            if size(valid_points, 1) >= maxSamples
                break;
            end

            r = adjusted_points(k, 1);
            c = adjusted_points(k, 2);
            r1 = max(1, r - buffer_radius);
            r2 = min(rows, r + buffer_radius);
            c1 = max(1, c - buffer_radius);
            c2 = min(cols, c + buffer_radius);
            local_patch = nonFlood_mask(r1:r2, c1:c2);

            if all(local_patch(:))
                % بررسی تکراری نبودن
                if isempty(valid_points) || ~ismember([r c], valid_points, 'rows')
                    valid_points = [valid_points; r, c];
                end
            end
        end
    end

    % در نهایت تعداد نهایی
    if size(valid_points, 1) > maxSamples
        sel = randperm(size(valid_points, 1), maxSamples);
        nonFloodPoints = valid_points(sel, :);
    else
        nonFloodPoints = valid_points;
    end
end


function adjusted = fastAdjustNonFlood(points, meanFloodProb, flood_thresh, minDist)
    [rows, cols] = size(meanFloodProb);
    nPoints = size(points, 1);
    adjusted = zeros(nPoints, 2);
    accepted = zeros(0, 2);  % نقاط پذیرفته شده

    % فقط 9 جابه‌جایی ممکن (نقطه خودش + همسایه‌ها)
    shifts = [0 0; -1 0; 1 0; 0 -1; 0 1; -1 -1; -1 1; 1 -1; 1 1];

    for i = 1:nPoints
        p = points(i, :);
        found = false;

        for s = 1:size(shifts, 1)
            new_p = p + shifts(s, :);
            if new_p(1) < 1 || new_p(1) > rows || new_p(2) < 1 || new_p(2) > cols
                continue
            end

            % بررسی احتمال سیلاب
            if meanFloodProb(new_p(1), new_p(2)) > flood_thresh
                continue
            end

            % بررسی فاصله از نقاط قبلی
            if ~isempty(accepted)
                dists = sqrt((accepted(:, 1) - new_p(1)).^2 + (accepted(:, 2) - new_p(2)).^2);
                if any(dists < minDist)
                    continue
                end
            end

            adjusted(i, :) = new_p;
            accepted = [accepted; new_p];
            found = true;
            break
        end

        if ~found
            adjusted(i, :) = p;
            accepted = [accepted; p];
        end
    end
end
