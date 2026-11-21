function Par = DecodeVariables(x,Params)

% decodeVariable = x * (ub - lb) + lb

HPS = Params.HyperParameterSize;
inputSize = Params.inputSize;

if sum(x(1:inputSize))==0
    x(1:inputSize) = ones(1,inputSize);
end
Par.newInputSize = sum(x(1:inputSize));

Par.FSS = x(1:inputSize);

% Set Params for SVR
Par.MLS = round(1 + x(inputSize+1)*1e3);     % MinLeafSize
Par.MNS = round(1 + x(inputSize+2)*1e3);       % MaxNumSplits
Par.NVTS = round(1 + x(inputSize+3)*1e3);       % NumVariablesToSample
Par.NumModels = round(10 + x(inputSize+4)*300);
% Par.LearnRate = 1e-6 + x(inputSize +5);

end