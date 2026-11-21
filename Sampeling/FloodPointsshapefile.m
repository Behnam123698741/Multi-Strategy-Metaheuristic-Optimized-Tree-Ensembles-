% --- مرحله 1: خواندن تصویرها و رفرنس ژئویی ---
load('frequencymap.mat')
[~, R] = readgeoraster('DEMh.tif');

% --- مرحله 2: استخراج نقاط غیرسیلابی با تعداد مشخص ---
FloodPoints = sampleFloodByDensityAndGrid(frequencymap, 0.4, 0.7, 11, 1500, 100);    
% --- مرحله 3: تبدیل مختصات پیکسلی به مختصات ژئویی (X, Y) ---
rows = FloodPoints(:,1);
cols = FloodPoints(:,2);
[lat, lon] = intrinsicToGeographic(R, cols, rows);  % توجه: اول ستون بعد ردیف!

% --- مرحله 4: ساخت ساختار برای ذخیره shapefile ---
S = struct([]);
for i = 1:length(lat)
    S(i).Geometry = 'Point';
    S(i).X = lon(i);   % longitude
    S(i).Y = lat(i);   % latitude
    S(i).ID = i;
end

% --- مرحله 5: ذخیره به عنوان فایل Shapefile ---
shapewrite(S, 'flood_points.shp');

disp('✅ ذخیره shapefile با موفقیت انجام شد.');