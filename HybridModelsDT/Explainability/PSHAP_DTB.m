%
% Shapely Additive exPlanation
% 2  
clc
clear
close all
warning off

%% Data Loading
load ../../DatasetUsed/DatasetFlood

%% Preparing Data For Compute Importance Feature
load ../../Outputs/FloodBS/HMOutput_DTBTCCMEEFO
FSS = HMOutput.FSS;
IndexBand = find(FSS);

Features = Dataset.Ftr(:,IndexBand);
Target   = Dataset.Ttr;

[n,d]=size(Features);
m=d+1;

x_train = [Features, Target];
%% Load Explainer
load explainerDTBTCCMEEFO
my_shap=explainer.Shapley.Predictor;
my_shap=table2array(explainer.Shapley);
my_shap(:,1)=[];
tmp = str2double(my_shap);
SHAP_Values = tmp';

%% Preparing Data For Compute Importance Feature

nSample = size(SHAP_Values,1);
predictors = {'Precipitation', 'Porosity', 'Permeability', 'ED_Roades', 'DrainageDensity',...
                      'ED_Rivers', 'SPI', 'TWI', 'LULC', 'NDVI', 'Clay', 'Bulk Density', ...
                      'CoarseFragments', 'Sand', 'Silt', 'WC10KPa', 'WC33KPa', 'WC1500KPa', ...
                      'Elevation', 'Slope', 'Aspect', 'Plan', 'Profile'};
predictors = predictors(IndexBand);
shap = SHAP_Values;

figure
set(gcf,'position',[339.4,140.2,852,502.4])

% Sort the predictors by mean(abs(shap))
[sortedMeanAbsShapValues,sortedPredictorIndices]=sort(mean(abs(shap)));
% Loop over the predictors, plot a row of points for each predictor using
% the scatter function with "density" jitter.
% The multiple calls to scatter are needed so that the jitter is normalized
% per-row, rather than globally over all the rows.
for p=1:d
   scatter(shap(:,sortedPredictorIndices(p)), ... % x-value of each point is the shapley value
           p*ones(n,1), ... % y-value of each point is an integer corresponding to a predictor (to be jittered below)
           [], ... % Marker size for each data point, taking the default here
           normalize(x_train(:,sortedPredictorIndices(p)),'range',[1 256]), ... % Colors based on feature values
           'filled', ... % Fills the circles representing data points
           'YJitter','density', ... % YJitter according to the density of the points in this row
           'YJitterWidth',0.5)
   if (p==1) hold on; end
end


xlabel('Shapley Value (impact on model output)', 'FontSize',12, 'FontName','Times New Roman')
yticks([1:d]);
yticklabels(predictors(sortedPredictorIndices));
% Set colormap as desired 
% colormap(CoolBlueToWarmRedColormap); % This colormap is like the one used in many Shapley summary plots
colormap(cool); % This is the default colormap
cb= colorbar('Ticks', [1 255], 'TickLabels', {'Low', 'High'});
cb.Label.String = "Feature Value";
cb.Label.FontSize = 12;
cb.Label.FontName = 'Times New Roman';
cb.Label.Rotation = 270;


set(gca, 'YGrid', 'on');
xline(0, 'LineWidth', 1);
set(gca,'FontSize',12, 'FontName','Times New Roman');
title('(b)', 'FontSize',15, 'FontName','Times New Roman', 'FontWeight','bold');
hold off;




load SF
% MeanSHAP = FSS;
% MeanSHAP(IndexBand) = mean(abs(shap));
% 
% IndexBand = find(SF(:, 1));
% my_shap = SF(:, 1);
% my_shap(IndexBand) = MeanSHAP;
% my_shap = my_shap';


Mdl = HMOutput.TrainedMDL;
[impGain,predAssociation] = predictorImportance(Mdl);
IMP = FSS;
IMP(IndexBand) = impGain;

IndexBand = find(SF(:, 1));
my_imp = SF(:, 1);
my_imp(IndexBand) = IMP';
my_imp = my_imp';
my_imp = my_imp* 1000;
% my_imp(23) = my_imp(23)/10;

my_imp = my_imp ./ sum(my_imp);