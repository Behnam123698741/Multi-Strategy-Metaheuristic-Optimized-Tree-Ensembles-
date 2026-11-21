% 
% SVR
% 
clc
clear
close all
warning off

%% Data Loading
load ../../DatasetUsed/DatasetFlood


XYtr = Dataset.XYtr;
Ftr  = Dataset.Ftr;
Ttr  = Dataset.Ttr;

XYts = Dataset.XYts;
Fts  = Dataset.Fts;
Tts  = Dataset.Tts;

Data = [ones(size(Ttr)), XYtr, Ftr, Ttr
       2*ones(size(Tts)), XYts, Fts, Tts];

%% 
load ../../Outputs/FloodBS/HMOutput_DTLSTCCMEEFO
Predicted = [HMOutput.ECtr.Yhat; HMOutput.ECts.Yhat];

load ../../Outputs/FloodBS/HMOutput_DTLSTCCMSSA
tmp = [HMOutput.ECtr.Yhat; HMOutput.ECts.Yhat];
Predicted = [Predicted, tmp];

load ../../Outputs/FloodBS/HMOutput_DTBTCCMEEFO
tmp = [HMOutput.ECtr.Yhat; HMOutput.ECts.Yhat];
Predicted = [Predicted, tmp];

load ../../Outputs/FloodBS/HMOutput_DTBTCCMSSA
tmp = [HMOutput.ECtr.Yhat; HMOutput.ECts.Yhat];
Predicted = [Predicted, tmp];

Output = [Data, Predicted];


filename = 'Output.xlsx';
xlswrite(filename,Output)



















