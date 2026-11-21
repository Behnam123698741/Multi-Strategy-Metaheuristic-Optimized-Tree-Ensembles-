% 
% SVR TMGWO (FSS) and GWO (Find Optimal Hyper Parameters)
% 
clc
clear
close all
warning off

%% Data Loading
load ../../DatasetUsed/DatasetFlood

%% Load Models

%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = ones(1,size(Ftr,2));
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
%% Model Training
% Set Params for DT

% t= templateTree('MinLeafSize',MLS,'MaxNumSplits',MNS,'NumVariablesToSample',NVTS);
% % Create a DT regression model
% TrainedDTB= fitrensemble(Ftr,Ttr,'Method','Bag',...
%     'NumLearningCycles',NumModels, 'Learners',t);

% t= templateTree('MinLeafSize',MLS,'MaxNumSplits',MNS,'NumVariablesToSample',NVTS);
% Create a DT regression model
TrainedDTB= fitrensemble(Ftr,Ttr,'Method','Bag',...
    'NumLearningCycles',200);


%% Prediction
TPtr = predict(TrainedDTB,Ftr);
TPts = predict(TrainedDTB,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'DTB-GAGWO ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R]



%% Output




a([1 2 6,7])

