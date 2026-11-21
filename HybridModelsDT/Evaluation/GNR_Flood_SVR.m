% 
% SVR Optimized (FSS) and MSAECO (Find Optimal Hyper Parameters)
% 
clc
clear
close all
warning off

%% Data Loading
load ../DatasetUsed/DatasetFlood

%% Model Loading
load ../Outputs/MSA/HMOutput_MLPMSATECO_Flood

%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = HMOutput.FSS;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(HMOutput.TrainedMDL,Ftr);
TPts = predict(HMOutput.TrainedMDL,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Optimized-SVR ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];

%% --------------------------------------------------------------------- %%
%% --------------------------------------------------------------------- %%
%% Model Loading
load ../Outputs/MSA/HMOutput_SVRMSATHHO_Flood

%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = HMOutput.FSS;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(HMOutput.TrainedMDL,Ftr);
TPts = predict(HMOutput.TrainedMDL,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Optimized-SVR ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all
a = [a; AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];

%% --------------------------------------------------------------------- %%
%% --------------------------------------------------------------------- %%
%% Model Loading
load ../Outputs/MSA/HMOutput_SVRTECO_Flood

%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = HMOutput.FSS;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(HMOutput.TrainedMDL,Ftr);
TPts = predict(HMOutput.TrainedMDL,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Optimized-SVR ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [a;AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];

%% --------------------------------------------------------------------- %%
%% --------------------------------------------------------------------- %%
%% Model Loading
load ../Outputs/MSA/HMOutput_SVRTHHO_Flood

%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = HMOutput.FSS;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(HMOutput.TrainedMDL,Ftr);
TPts = predict(HMOutput.TrainedMDL,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Optimized-SVR ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [a; AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];






as = abs(a(:,1:5)-a(:,6:10)) ./ a(:,6:10);





















