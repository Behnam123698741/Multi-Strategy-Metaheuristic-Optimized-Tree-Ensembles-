function adjusted = enforceBothConditionsFast(points, flood_prob, flood_thresh, minDist)
    adjusted = [];
    [rows, cols] = size(flood_prob);

    % ساخت kd-tree از نقاطی که تاکنون انتخاب شده
    kdTree = [];

    for k = 1:size(points,1)
        p = points(k,:);
        found = false;

        % جستجوی محدود (مثلاً فقط جابجایی در مرکز و چهار جهت اصلی)
        candidateOffsets = [0 0; -5 0; 5 0; 0 -5; 0 5];

        for idx = 1:size(candidateOffsets,1)
            new_p = p + candidateOffsets(idx,:);

            if any(new_p < 1) || new_p(1) > rows || new_p(2) > cols
                continue;
            end

            % شرط فاصله با kd-tree
            if isempty(adjusted)
                distOk = true; % اولین نقطه
            else
                % ساخت kd-tree اگر لازم است
                if isempty(kdTree) || size(adjusted,1) ~= kdTree.NumPoints
                    kdTree = KDTreeSearcher(adjusted);
                end
                % حداقل فاصله به نقاط قبلی
                [~, d] = knnsearch(kdTree, new_p, 'K', 1);
                distOk = d >= minDist;
            end
            if ~distOk, continue; end

            % شرط میانگین پنجره
            if ~isMeanAboveThreshold(new_p(1), new_p(2), flood_prob, flood_thresh)
                continue;
            end

            adjusted = [adjusted; new_p];
            found = true;
            break;
        end

        if ~found
            adjusted = [adjusted; p];
        end
    end
end
