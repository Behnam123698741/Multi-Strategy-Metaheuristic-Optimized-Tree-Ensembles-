% Collage 3+3+2 with ZERO gaps, NO resizing, small black tags a..h (no bg)
clear; clc;

% -------- انتخاب فولدر ورودی --------
inputFolder = uigetdir(pwd, 'Select folder containing images');
if inputFolder == 0
    error('No folder selected.');
end

% -------- جمع‌آوری فایل‌ها --------
exts = {'*.jpg','*.jpeg','*.png','*.tif','*.tiff','*.bmp','*.webp'};
files = [];
for k = 1:numel(exts)
    files = [files; dir(fullfile(inputFolder, exts{k}))]; %#ok<AGROW>
end
if isempty(files), error('No images found.'); end
names = {files.name};

% -------- انتخاب تصویر برای هر جایگاه (8 تا) --------
slotLabels = { ...
    'Row 1, Col 1 (a)','Row 1, Col 2 (b)','Row 1, Col 3 (c)', ...
    'Row 2, Col 1 (d)','Row 2, Col 2 (e)','Row 2, Col 3 (f)', ...
    'Row 3, Col 1 (g)','Row 3, Col 2 (h)' };

selectedIdx = zeros(1,8);
for s = 1:8
    [idx, ok] = listdlg( ...
        'PromptString', ['Select image for: ' slotLabels{s}], ...
        'SelectionMode','single', ...
        'ListString', names, ...
        'ListSize',[520 300]);
    if ~ok, error('Selection cancelled.'); end
    selectedIdx(s) = idx;
end

paths = arrayfun(@(i) fullfile(inputFolder, files(i).name), selectedIdx, 'UniformOutput', false);

% -------- خواندن تصاویر (بدون تغییر اندازه) --------
imgs = cell(1,8);
for s = 1:8
    I = imread(paths{s});
    if ndims(I) == 2
        I = repmat(I, 1, 1, 3); % به RGB برای خروجی یکدست
    elseif size(I,3) > 3
        I = I(:,:,1:3);
    end
    if ~isa(I,'uint8')
        % برای یکنواختی خروجی (اگر 16-bit باشد، می‌شود uint16 نگه داشت؛
        % ولی اکثر jpg/png معمولی uint8 هستند)
        I = im2uint8(I);
    end
    imgs{s} = I;
end

% -------- تعریف تگ‌ها (a..h) --------
tags = 'abcdefgh';

% -------- تعیین ابعاد هر سلول (بدون resize) --------
% هر ردیف/ستون اندازه‌اش برابر max همان ردیف/ستون می‌شود (بدون تغییر تصویر)
% موقع چسباندن: هر تصویر بالا-چپ سلول خودش قرار می‌گیرد، بقیه سفید می‌ماند.

% مپ جایگاه‌ها به (row,col) در یک شبکه 3x3 (سلول 9 خالی)
% 1:(1,1) 2:(1,2) 3:(1,3)
% 4:(2,1) 5:(2,2) 6:(2,3)
% 7:(3,1) 8:(3,2) 9:(3,3)=empty
rc = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2];

rowH = zeros(1,3);
colW = zeros(1,3);

for s = 1:8
    r = rc(s,1); c = rc(s,2);
    [h,w,~] = size(imgs{s});
    rowH(r) = max(rowH(r), h);
    colW(c) = max(colW(c), w);
end

% اگر ستون سوم ردیف سوم خالی است، colW(3) فقط از ردیف1 و 2 می‌آید که بالا حساب شده.

H = sum(rowH);
W = sum(colW);

% بوم سفید (بدون فاصله)
canvas = uint8(255 * ones(H, W, 3));

% -------- چسباندن تصاویر + تگ بدون بک‌گراند --------
x0 = [1, 1+colW(1), 1+colW(1)+colW(2)];
y0 = [1, 1+rowH(1), 1+rowH(1)+rowH(2)];

tagX = 6;   % فاصله از چپ (پیکسل)
tagY = 6;   % فاصله از بالا (پیکسل)
tagScale = 1; % کوچک؛ اگر کوچیک‌تر/بزرگ‌تر خواستید 1 یا 2

for s = 1:8
    r = rc(s,1); c = rc(s,2);
    I = imgs{s};

    % تگ را روی خود تصویر می‌کشیم (مشکی، بدون بکگراند)
    I = drawTinyTag(I, tags(s), tagX, tagY, tagScale);

    [h,w,~] = size(I);

    yy = y0(r);
    xx = x0(c);

    canvas(yy:yy+h-1, xx:xx+w-1, :) = I;
end

% -------- ذخیره خروجی (پیشنهاد: PNG برای حفظ کیفیت) --------
[outFile, outPath] = uiputfile({'*.png';'*.jpg'}, 'Save collage (PNG recommended)', fullfile(inputFolder, 'collage.png'));
if isequal(outFile,0)
    disp('Not saved (user cancelled).');
else
    outFull = fullfile(outPath, outFile);

    if endsWith(lower(outFull), '.jpg') || endsWith(lower(outFull), '.jpeg')
        % توجه: JPG کیفیت را ذاتاً کمی تغییر می‌دهد (فشرده‌سازی)
        imwrite(canvas, outFull, 'jpg', 'Quality', 100);
    else
        imwrite(canvas, outFull, 'png'); % بدون افت کیفیت
    end
    disp(['Saved: ' outFull]);
end

% -------- نمایش سریع --------
figure('Color','w'); imshow(canvas); title('Final collage (no resizing, zero gaps)');

% ===================== Helper: tiny bitmap font tag ======================
function I = drawTinyTag(I, ch, x, y, scale)
% Draw small 5x7 bitmap lowercase letters a..h, black, no background.
% x,y are 1-based pixel coords in image where the top-left of glyph starts.

    glyph = tinyGlyph5x7(ch); % 7x5 logical
    if isempty(glyph), return; end

    if scale > 1
        glyph = kron(glyph, true(scale)); %#ok<KRON>
    end

    [H,W,~] = size(I);
    gh = size(glyph,1);
    gw = size(glyph,2);

    % Clip to image bounds
    x1 = max(1, x);
    y1 = max(1, y);
    x2 = min(W, x + gw - 1);
    y2 = min(H, y + gh - 1);

    if x1 > x2 || y1 > y2, return; end

    % corresponding glyph region
    gx1 = 1 + (x1 - x);
    gy1 = 1 + (y1 - y);
    gx2 = gx1 + (x2 - x1);
    gy2 = gy1 + (y2 - y1);

    mask = glyph(gy1:gy2, gx1:gx2);

    % paint black where mask=1
    for c = 1:3
        plane = I(y1:y2, x1:x2, c);
        plane(mask) = 0;
        I(y1:y2, x1:x2, c) = plane;
    end
end

function g = tinyGlyph5x7(ch)
% returns 7x5 logical bitmap for a..h
% You can extend this map if you want more letters.

    z = false(7,5);
    switch lower(ch)
        case 'a'
            g = [0 1 1 1 0;
                 1 0 0 0 1;
                 1 0 0 0 1;
                 1 1 1 1 1;
                 1 0 0 0 1;
                 1 0 0 0 1;
                 1 0 0 0 1] > 0;
        case 'b'
            g = [1 1 1 1 0;
                 1 0 0 0 1;
                 1 0 0 0 1;
                 1 1 1 1 0;
                 1 0 0 0 1;
                 1 0 0 0 1;
                 1 1 1 1 0] > 0;
        case 'c'
            g = [0 1 1 1 1;
                 1 0 0 0 0;
                 1 0 0 0 0;
                 1 0 0 0 0;
                 1 0 0 0 0;
                 1 0 0 0 0;
                 0 1 1 1 1] > 0;
        case 'd'
            g = [1 1 1 0 0;
                 1 0 0 1 0;
                 1 0 0 0 1;
                 1 0 0 0 1;
                 1 0 0 0 1;
                 1 0 0 1 0;
                 1 1 1 0 0] > 0;
        case 'e'
            g = [1 1 1 1 1;
                 1 0 0 0 0;
                 1 0 0 0 0;
                 1 1 1 1 0;
                 1 0 0 0 0;
                 1 0 0 0 0;
                 1 1 1 1 1] > 0;
        case 'f'
            g = [1 1 1 1 1;
                 1 0 0 0 0;
                 1 0 0 0 0;
                 1 1 1 1 0;
                 1 0 0 0 0;
                 1 0 0 0 0;
                 1 0 0 0 0] > 0;
        case 'g'
            g = [0 1 1 1 1;
                 1 0 0 0 0;
                 1 0 0 0 0;
                 1 0 1 1 1;
                 1 0 0 0 1;
                 1 0 0 0 1;
                 0 1 1 1 0] > 0;
        case 'h'
            g = [1 0 0 0 1;
                 1 0 0 0 1;
                 1 0 0 0 1;
                 1 1 1 1 1;
                 1 0 0 0 1;
                 1 0 0 0 1;
                 1 0 0 0 1] > 0;
        otherwise
            g = z;
    end
end
