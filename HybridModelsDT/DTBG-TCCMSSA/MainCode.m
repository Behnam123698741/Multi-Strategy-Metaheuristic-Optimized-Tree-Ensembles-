% 
% TCCMEEFO (Find Optimal Hyper Parameters and FSS)
% 
clc
clear
close all
warning off

%% Data Loading
load ../../DatasetUsed/DatasetFlood

%% Manage Data
Ftr = Dataset.Ftr;
Fts = Dataset.Fts;
Ttr = Dataset.Ttr;
Tts = Dataset.Tts;

TrainData.Features = Ftr;
TrainData.Target = Ttr;
%% Apply k-fold CrossVal
TrNum = numel(Ttr);
K = 3;
CVI = crossvalind('kfold',TrNum,K);
TrainData.CVI = CVI;
TrainData.K = K;

%% Set EA Parameters
Params.MaxIt = 200;
Params.nPop = 100;

inputSize = size(Ftr,2);
Params.inputSize = inputSize;
Params.HyperParameterSize = 4;
Params.nVar = [inputSize, 4];

Params.VarMin = 0;
Params.VarMax = 1;

Params.stop_cond_numBreak = 30;
Params.stop_cond_valBreak = 1e-4;

TrainData.Params = Params;

%% Train Network using MetaA
[TrainedDTB,Results] = TrainUsingTCCMSSA(TrainData,Params);
save('TrainedDTBTCCMSSA_1.mat','TrainedDTB') 
save('ResultsDTBTCCMSSA_1.mat','Results') 

[TrainedDTB,Results] = TrainUsingTCCMSSA(TrainData,Params);
save('TrainedDTBTCCMSSA_2.mat','TrainedDTB') 
save('ResultsDTBTCCMSSA_2.mat','Results') 

[TrainedDTB,Results] = TrainUsingTCCMSSA(TrainData,Params);
save('TrainedDTBTCCMSSA_3.mat','TrainedDTB') 
save('ResultsDTBTCCMSSA_3.mat','Results') 

[TrainedDTB,Results] = TrainUsingTCCMSSA(TrainData,Params);
save('TrainedDTBTCCMSSA_4.mat','TrainedDTB') 
save('ResultsDTBTCCMSSA_4.mat','Results') 

[TrainedDTB,Results] = TrainUsingTCCMSSA(TrainData,Params);
save('TrainedDTBTCCMSSA_5.mat','TrainedDTB') 
save('ResultsDTBTCCMSSA_5.mat','Results') 












