% 
% SVR TMGWO (FSS) and GWO (Find Optimal Hyper Parameters)
% 
clc
clear
close all
warning off

%% Data Loading
load ../../DatasetUsed/DatasetR13S

load ResultsTGWO_R13S_4
load TrainedSVRTGWO_R13S_4
%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;
%% Prediction
FSS = Results.Out.FSS;
IndexBand = find(FSS);

p = numel(IndexBand);
Ftr = Ftr(:,IndexBand);
Fts = Fts(:,IndexBand);
%%
TrainedSVR = Results.Out.Model;
%% Prediction
TPtr = predict(TrainedSVR,Ftr);
TPts = predict(TrainedSVR,Fts);
TPtr = minmaxMFcn(TPtr);
TPts = minmaxMFcn(TPts);
%% Evalute
ModelName = 'SVR-GAGWO ';
ECtr = EvaluatePlot(Ttr,TPtr,p,ModelName,'Train ');
ECts = EvaluatePlot(Tts,TPts,p,ModelName,'Test ');
[Xtr,Ytr,Ttr,AUCtr,OPTROCPTtr] = perfcurve(Ttr,TPtr,1);
[Xts,Yts,Tts,AUCts,OPTROCPTts] = perfcurve(Tts,TPts,1);
close all

a = [AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
     AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R,FSS];


% load ResultsTGWO_R3S_4
% Results.BestCosts = Results.BestCosts;


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
HMOutput.TrainedMDL     = TrainedSVR;
HMOutput.Time           = Results.Time;
HMOutput.BestCosts      = Results.BestCosts;
HMOutput.MeanCosts      = Results.MeanCosts;
HMOutput.BestSolution   = Results.BestSolution;
HMOutput.FSS            = FSS;
HMOutput.IndexBand      = IndexBand;
HMOutput.HP             = [Results.Out.Epsilon, Results.Out.KS, Results.Out.BC, Results.BestSolution.Position(25)];
HMOutput.SearchHistory  = Results.search_history;
HMOutput.FitnessHistory = Results.fitness_history;
HMOutput.CV             = [AUCtr, ECtr.RMSE, ECtr.R2, ECtr.AdjR2, ECtr.R, ...
                           AUCts, ECts.RMSE, ECts.R2, ECts.AdjR2, ECts.R];
HMOutput.ECtr           = ECtr;
HMOutput.ECts           = ECts;
HMOutput.Vpops          = Results.Vpops;

HMOutput.BESTSOLUTION          = Results.BESTSOLUTION;


% HMOutput_R13S_SVRTGWO

sum(FSS)





