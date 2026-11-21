function [z,Out,MDL] = CostDT(x,Data)
warning off

global NFE;
if isempty(NFE)
    NFE=0;
end
NFE=NFE+1;


%% Decode the Decision Variables
Par = DecodeVariables(x,Data.Params);

% Set Params for DT
MLS  = Par.MLS;     % MinLeafSize
MNS  = Par.MNS;       % MaxNumSplits
NVTS = Par.NVTS;       % NumVariablesToSample
NumModels = Par.NumModels;
t= templateTree('MinLeafSize',MLS,'MaxNumSplits',MNS,'NumVariablesToSample',NVTS);

% Read Data
FSS = Par.FSS;
IndexBand = find(FSS);
X = Data.Features;
X = X(:,IndexBand);
Y = Data.Target;

CVI = Data.CVI;
K = Data.K;
V = inf;
Cost = zeros(1,K);

% Main Loop For Train with K-fold Cross Validation
for i = 1:K
    
    Xtrain = X(CVI~=i,:);
    YTrain = Y(CVI~=i);
    
    % Create a DT regression model
    mdl= fitrensemble(Xtrain,YTrain,'Method','Bag',...
    'NumLearningCycles',NumModels, 'Learners',t);
    
    Xvalid = X(CVI==i,:);
    Yvalid = Y(CVI==i);
    
    % Prediction
    Yhat = predict(mdl,Xvalid);
    Cost(i) = (mean((Yhat - Yvalid).^2))^0.5; % RMSE
    
    
    if Cost(i)<V
        V = Cost(i);
        MDL = mdl;
    end
end

if sum(FSS)>=9
    % RMSE Calculate for Validation Data
    RMSE = 0.95*mean(Cost)+0.05*(sum(FSS)/numel(FSS));
else
    RMSE=inf;
end
% RMSE = 0.95*mean(Cost)+0.05*(sum(FSS)/numel(FSS));



% Objective Function
z = RMSE;

% Store Results
Out.RMSE = RMSE;
Out.Par = Par;

Out.Model = MDL;

end