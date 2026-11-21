% Batch crop using ROI from the first image, then save as JPG
clear; clc;

% -------- تنظیم مسیرها --------
inputFolder  = uigetdir(pwd, 'Select INPUT folder (images)');
if inputFolder == 0
    error('No input folder selected.');
end

outputFolder = fullfile(inputFolder, 'cropped_output');
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% -------- خواندن لیست تصاویر --------
exts = {'*.jpg','*.jpeg','*.png','*.tif','*.tiff','*.bmp','*.webp'};
files = [];
for k = 1:numel(exts)
    files = [files; dir(fullfile(inputFolder, exts{k}))]; %#ok<AGROW>
end

if isempty(files)
    error('No image files found in the selected folder.');
end

% -------- انتخاب ROI روی اولین تصویر --------
firstPath = fullfile(inputFolder, files(1).name);
I0 = imread(firstPath);

hFig = figure('Name','Select ROI on first image, then double-click inside the box');
imshow(I0);

% روش جدیدتر (R2018b+): drawrectangle
try
    roi = drawrectangle('Color','g');
    % منتظر بمان تا کاربر ROI را نهایی کند (double-click)
    customWait(roi);
    rect = round(roi.Position);  % [x y w h]
catch
    % روش قدیمی‌تر: imcrop با انتخاب ماوس
    disp('drawrectangle not available. Using imcrop selection...');
    [~, rect] = imcrop(I0);
    rect = round(rect);
end

close(hFig);

% اطمینان از معتبر بودن ناحیه
if any(isnan(rect)) || numel(rect) ~= 4 || rect(3) <= 1 || rect(4) <= 1
    error('Invalid ROI selected.');
end

% -------- اعمال Crop روی همه تصاویر و ذخیره --------
for i = 1:numel(files)
    inName = files(i).name;
    inPath = fullfile(inputFolder, inName);

    I = imread(inPath);

    % اگر بعضی تصاویر اندازه‌شان فرق داشت، ROI را محدود می‌کنیم که خارج نزند
    [H, W, ~] = size(I);
    x = max(1, rect(1));
    y = max(1, rect(2));
    w = rect(3);
    h = rect(4);

    if x+w-1 > W
        w = W - x + 1;
    end
    if y+h-1 > H
        h = H - y + 1;
    end

    if w < 2 || h < 2
        warning('Skipping %s because ROI is out of bounds for its size.', inName);
        continue;
    end

    Ic = imcrop(I, [x y w h]);

    % نام خروجی: همان نام فایل ولی jpg
    [~, base, ~] = fileparts(inName);
    outPath = fullfile(outputFolder, base + ".jpg");

    % ذخیره به jpg
    imwrite(Ic, outPath, 'jpg', 'Quality', 95);
end

disp('Done! Cropped images saved in:');
disp(outputFolder);

% -------- تابع کمکی برای صبر کردن تا پایان انتخاب ROI --------
function customWait(roi)
    l = addlistener(roi, 'ROIClicked', @clickCallback);
    uiwait;
    delete(l);

    function clickCallback(~, evt)
        if strcmp(evt.SelectionType, 'double')
            uiresume;
        end
    end
end
