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
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(TrainedDTB,Ftr);
TPts = predict(TrainedDTB,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Trained-Model ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];
%% --------------------------------------------------------------------- %%
load ResultsDTBTCCMEEFO_2
load TrainedDTBTCCMEEFO_2
%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = Results.Out.Par.FSS;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(TrainedDTB,Ftr);
TPts = predict(TrainedDTB,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Trained-Model ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [a;AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];
%% --------------------------------------------------------------------- %%
load ResultsDTBTCCMEEFO_3
load TrainedDTBTCCMEEFO_3
%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = Results.Out.Par.FSS;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(TrainedDTB,Ftr);
TPts = predict(TrainedDTB,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Trained-Model ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [a;AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];
%% --------------------------------------------------------------------- %%
load ResultsDTBTCCMEEFO_4
load TrainedDTBTCCMEEFO_4
%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = Results.Out.Par.FSS;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(TrainedDTB,Ftr);
TPts = predict(TrainedDTB,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Trained-Model ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [a;AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];
%% --------------------------------------------------------------------- %%
load ResultsDTBTCCMEEFO_5
load TrainedDTBTCCMEEFO_5
%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = Results.Out.Par.FSS;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(TrainedDTB,Ftr);
TPts = predict(TrainedDTB,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Trained-Model ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [a;AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];
%% --------------------------------------------------------------------- %%
load ResultsDTBTCCMEEFO_6
load TrainedDTBTCCMEEFO_6
%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = Results.Out.Par.FSS;
IndexBand = find(FSS);
p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
TPtr = predict(TrainedDTB,Ftr);
TPts = predict(TrainedDTB,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'Trained-Model ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [a;AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];






























