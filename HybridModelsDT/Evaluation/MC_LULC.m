% 
clc
clear
close all
warning off

%% 
FLULC = geotiffread('DataCode/NLULC.tif');FLULC = double(FLULC);

LULC = zeros(size(FLULC));

idx = find(FLULC==11);

Area = numel(idx);
LULC(idx) = 1;


MLP_Fire      = geotiffread('DataCode/FCM_MLPMSATHHO_Fire1.tif'); MLP_Fire = double(MLP_Fire);
MLP_Flood     = geotiffread('DataCode/FCM_MLPMSAHHO_Flood1.tif'); MLP_Flood = double(MLP_Flood);
MLP_Ladslide  = geotiffread('DataCode/FCM_MLPMSATECO_LS1.tif'); MLP_Ladslide = double(MLP_Ladslide);
MLP_LS        = geotiffread('DataCode/FCM_MLPMSATHHO_Landslide1.tif');MLP_LS = double(MLP_LS);

SVR_Fire      = geotiffread('DataCode/RFCM_SVRMSATHHO_Fire1.tif'); SVR_Fire = double(SVR_Fire);
SVR_Flood     = geotiffread('DataCode/RFCM_SVRMSATECO_Flood1.tif'); SVR_Flood = double(SVR_Flood);
SVR_Ladslide  = geotiffread('DataCode/RFCM_SVRMSATHHO_Landslide1.tif'); SVR_Ladslide = double(SVR_Ladslide);
SVR_LS        = geotiffread('DataCode/RFCM_SVRMSATECO_LS1.tif');SVR_LS = double(SVR_LS);


a1 = [];
for i=1:5
    cnt = zeros(size(LULC));
    idx = find(MLP_Fire==i);
    cnt(idx) = 1;
    a1 = [a1, sum(sum(cnt .* LULC))];
end
a_MLP = a1;


a1 = [];
for i=1:5
    cnt = zeros(size(LULC));
    idx = find(MLP_Flood==i);
    cnt(idx) = 1;
    a1 = [a1, sum(sum(cnt .* LULC))];
end
a_MLP = [a_MLP; a1];

a1 = [];
for i=1:5
    cnt = zeros(size(LULC));
    idx = find(MLP_Ladslide==i);
    cnt(idx) = 1;
    a1 = [a1, sum(sum(cnt .* LULC))];
end
a_MLP = [a_MLP; a1];


a1 = [];
for i=1:5
    cnt = zeros(size(LULC));
    idx = find(MLP_LS==i);
    cnt(idx) = 1;
    a1 = [a1, sum(sum(cnt .* LULC))];
end
a_MLP = [a_MLP; a1];


a_MLP = [a_MLP, ((a_MLP./Area)*100)];


%%
a1 = [];
for i=1:5
    cnt = zeros(size(LULC));
    idx = find(SVR_Fire==i);
    cnt(idx) = 1;
    a1 = [a1, sum(sum(cnt .* LULC))];
end
a_SVR = a1;


a1 = [];
for i=1:5
    cnt = zeros(size(LULC));
    idx = find(SVR_Flood==i);
    cnt(idx) = 1;
    a1 = [a1, sum(sum(cnt .* LULC))];
end
a_SVR = [a_SVR; a1];

a1 = [];
for i=1:5
    cnt = zeros(size(LULC));
    idx = find(SVR_Ladslide==i);
    cnt(idx) = 1;
    a1 = [a1, sum(sum(cnt .* LULC))];
end
a_SVR = [a_SVR; a1];


a1 = [];
for i=1:5
    cnt = zeros(size(LULC));
    idx = find(SVR_LS==i);
    cnt(idx) = 1;
    a1 = [a1, sum(sum(cnt .* LULC))];
end
a_SVR = [a_SVR; a1];


a_SVR = [a_SVR, ((a_SVR./Area)*100)];


a = [a_MLP(:,6:end); a_SVR(:,6:end)];

