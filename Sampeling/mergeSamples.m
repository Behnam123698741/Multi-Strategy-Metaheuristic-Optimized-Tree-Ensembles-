function [floodPoints, nonFloodPoints] = mergeSamples(flood_prob, alpha)
% ترکیب نمونه‌ها از دو روش: خوشه‌ای و گریدی
%
% Inputs:
%   flood_prob : ماتریس احتمال
%   alpha      : وزن ترکیب بین ۰ تا ۱ (مثلاً ۰.۷ یعنی ۷۰٪ خوشه‌ای)
%
% Outputs:
%   floodPoints      : نقاط flood نهایی
%   nonFloodPoints   : نقاط non-flood نهایی

    if nargin < 2
        alpha = 0.7;
    end

    % دریافت نمونه‌ها
    [fp_grid, nfp_grid] = sampleGridPoints(flood_prob);
    [fp_clust, nfp_clust] = sampleFloodClusters(flood_prob);

    % تعداد ترکیبی
    Nf = round(alpha * size(fp_clust,1) + (1 - alpha) * size(fp_grid,1));
    Nnf = round(alpha * size(nfp_clust,1) + (1 - alpha) * size(nfp_grid,1));

    % ترکیب نمونه‌ها
    sel_flood = [fp_clust; fp_grid];
    sel_flood = sel_flood(randperm(size(sel_flood,1)), :);
    floodPoints = sel_flood(1:min(Nf, size(sel_flood,1)), :);

    sel_nonflood = [nfp_clust; nfp_grid];
    sel_nonflood = sel_nonflood(randperm(size(sel_nonflood,1)), :);
    nonFloodPoints = sel_nonflood(1:min(Nnf, size(sel_nonflood,1)), :);
end
