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

Params.stop_cond_numBreak = 20;
Params.stop_cond_valBreak = 1e-4;

TrainData.Params = Params;

%% Train Network using MetaA
% [TrainedDTB,Results] = TrainUsingTCCMEEFO(TrainData,Params);
% save('TrainedDTLSTCCMEEFO_1.mat','TrainedDTB') 
% save('ResultsDTLSTCCMEEFO_1.mat','Results') 

[TrainedDTB,Results] = TrainUsingTCCMEEFO(TrainData,Params);
save('TrainedDTLSTCCMEEFO_2.mat','TrainedDTB') 
save('ResultsDTLSTCCMEEFO_2.mat','Results') 

[TrainedDTB,Results] = TrainUsingTCCMEEFO(TrainData,Params);
save('TrainedDTLSTCCMEEFO_3.mat','TrainedDTB') 
save('ResultsDTLSTCCMEEFO_3.mat','Results') 

[TrainedDTB,Results] = TrainUsingTCCMEEFO(TrainData,Params);
save('TrainedDTLSTCCMEEFO_4.mat','TrainedDTB') 
save('ResultsDTLSTCCMEEFO_4.mat','Results') 

[TrainedDTB,Results] = TrainUsingTCCMEEFO(TrainData,Params);
save('TrainedDTLSTCCMEEFO_.mat','TrainedDTB') 
save('ResultsDTLSTCCMEEFO_55.mat','Results') 












