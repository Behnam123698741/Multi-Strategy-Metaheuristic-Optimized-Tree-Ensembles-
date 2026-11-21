% 
% MLP Optimized (FSS) and MSAECO (Find Optimal Hyper Parameters)
% 
clc
clear
close all
warning off

%% Data Loading
load ../../DatasetUsed/DatasetFlood

%% Model Loading
load ../../Outputs/FloodBS/HMOutput_DTLSTCCMEEFO

a = [HMOutput.CV, HMOutput.FSS];

%% --------------------------------------------------------------------- %%
%% --------------------------------------------------------------------- %%
%% Model Loading
load ../../Outputs/FloodBS/HMOutput_DTLSTCCMSSA

a = [a; HMOutput.CV, HMOutput.FSS];

%% --------------------------------------------------------------------- %%
%% --------------------------------------------------------------------- %%
%% Model Loading
load ../../Outputs/FloodBS/HMOutput_DTBTCCMEEFO

a = [a; HMOutput.CV, HMOutput.FSS];

%% --------------------------------------------------------------------- %%
%% --------------------------------------------------------------------- %%
%% Model Loading
load ../../Outputs/FloodBS/HMOutput_DTBTCCMSSA

a = [a; HMOutput.CV, HMOutput.FSS];


as = abs(a(:,1:5)-a(:,6:10)) ./ a(:,6:10);




















