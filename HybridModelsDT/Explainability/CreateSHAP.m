%
% Shapely Additive exPlanation
% 
clc
clear
close all
warning off

%% Load Data
load ../../DatasetUsed/DatasetFlood

%% Load Trained Models
load ../../Outputs/FloodBS/HMOutput_DTLSTCCMEEFO
% load ../../Outputs/FloodBS/HMOutput_DTBTCCMEEFO

%% Preparing Data For Compute Importance Feature
FSS = HMOutput.FSS;
IndexBand = find(FSS);

Features = Dataset.Ftr(:,IndexBand);
Target   = Dataset.Ttr;

%% Define Regression Model
blackbox = @(x)predict(x);

%% Calculate SHAP


explainer = shapley(blackbox,Features,'QueryPoints',Features(1:3,:));


save('explainerDTLSTCCMEEFO.mat','explainer') 
% save('explainerDTBTCCMEEFO.mat','explainer') 





















