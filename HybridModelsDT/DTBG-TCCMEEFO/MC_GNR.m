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
load ResultsDTBTCCMEEFO_1
load TrainedDTBTCCMEEFO_1

%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = Results.Out.Par.FSS;
% FSS(1) = 1;
% FSS(end) = 1;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
%% Model Training
% Set Params for DT
MLS  = Results.Out.Par.MLS;     % MinLeafSize
MNS  = Results.Out.Par.MNS;       % MaxNumSplits
NVTS = Results.Out.Par.NVTS;       % NumVariablesToSample
NumModels = Results.Out.Par.NumModels;
% t= templateTree('MinLeafSize',MLS,'MaxNumSplits',MNS,'NumVariablesToSample',NVTS);
% % Create a DT regression model
TrainedDTB= fitrensemble(Ftr,Ttr,'Method','Bag',...
    'NumLearningCycles',100);

% TrainedDTB=TrainedDTB;
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
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];

figure;
%Draw objective space
semilogy(Results.BestCosts,'Color','r')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');
axis tight
grid on
box on
legend('FDA')


figure;
%Draw objective space
semilogy(Results.Vpops,'Color','r')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');
axis tight
grid on
box on
legend('FDA')

%% Output
HMOutput.TrainedMDL     = TrainedDTB;
HMOutput.Time           = Results.Time;
HMOutput.BestCosts      = Results.BestCosts;
HMOutput.MeanCosts      = Results.MeanCosts;
HMOutput.BestSolution   = Results.BestSolution;
HMOutput.FSS            = FSS;
HMOutput.IndexBand      = IndexBand;
HMOutput.HP             = [MLS, MNS, NVTS, NumModels];
HMOutput.SearchHistory  = Results.search_history;
HMOutput.FitnessHistory = Results.fitness_history;
HMOutput.CV             = [AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
                           AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R];
HMOutput.ECtr           = ECtr;
HMOutput.ECts           = ECts;
HMOutput.Vpops          = Results.Vpops;

Results.BESTSOLUTION(end).Position(1:numel(FSS)) = FSS;
HMOutput.BESTSOLUTION          = Results.BESTSOLUTION;

% HMOutput_DTBTCCMEEFO




a([1 2 6,7])
