function [Model,Results] = TrainUsingTCCMSSA(TrainData,Params)

disp('Optimizing Model Hyperparameters and Feature Selection with TCCMSSA ...')
%% Problem Definition
global NFE;

% Objective Function
CostFunction = @(x) CostDT(x,TrainData);

nVar = Params.nVar;
inputSize = Params.inputSize;
nVarSum = sum(nVar);

VarMin = Params.VarMin;
VarMax = Params.VarMax;

%% MA Parameters
MaxIt=Params.MaxIt;      % Maximum Number of Iterations

stop_cond=0;
stop_cond_numBreak = Params.stop_cond_numBreak;
stop_cond_valBreak = Params.stop_cond_valBreak;

nPop=Params.nPop;        % Population Size

%% Two-phase mutation
Mp = 0.5;

%% Initialization
tic

empty_pop.Position = [];
empty_pop.Cost     = inf;
empty_pop.MDL      = [];

pop = repmat(empty_pop,nPop,1);

for i = 1:nPop
    % Initialize Position
    pop(i).Position = [randi([0 1],1,nVar(1)), unifrnd(VarMin,VarMax,[1,nVar(2)])];

    % Evaluation
    [pop(i).Cost, ~, pop(i).MDL]= CostFunction(pop(i).Position);
end

% Sort Population
Costs=[pop.Cost];
[~, SortOrder]=sort(Costs);

Food = pop(SortOrder(1));
BX1 = pop(SortOrder(1));
BX2 = pop(SortOrder(2));

% Array to Hold Best Cost Values
BestCosts = zeros(MaxIt,1);

% Array to Hold Mean Cost Values
MeanCosts = zeros(MaxIt,1);

% Array to Hold Number of Function Evaluations
nfe=zeros(MaxIt,1);

% % Save Search History
search_history = zeros(nPop, MaxIt, sum(nVar));
fitness_history = zeros(nPop, MaxIt);

BESTSOLUTION.Position = [];
BESTSOLUTION.Cost = inf;
BESTSOLUTION.MDL = [];

%% EEFO Main Loop
tic
NFE = 0;

l=2; % start from the second iteration since the first iteration
     % was dedicated to calculating the fitness of salps
for it = 1:MaxIt

    % --------------------------------------------------------------------%
    % Communication and collaboration strategy (CC)
    for i = 1:nPop

        popPositionCC = pop(i).Position + (1-rand) .* ((BX1.Position+BX2.Position)/2);

        % check the boundaries
        FlagUb = popPositionCC>VarMax;
        FlagLb = popPositionCC<VarMin;

        popPositionCC = (popPositionCC.*(~(FlagUb+FlagLb))) ...
            + VarMax.*FlagUb + VarMin.*FlagLb;

        % Transformation Function 
        popPositionCC(1:inputSize) = TransformationFunction(popPositionCC(1:inputSize));

        % Evaluation
        [popCostCC, ~, popCostMDL] = CostFunction(popPositionCC);

        % Greedy Selection
        if popCostCC<pop(i).Cost
            pop(i).Position = popPositionCC;
            pop(i).Cost     = popCostCC;
            pop(i).MDL      = popCostMDL;

            % Update Food, BX1, and BX2
            if pop(i).Cost<Food.Cost
                Food = pop(i);
                BX1  = pop(i);
            elseif pop(i).Cost>Food.Cost && pop(i).Cost<BX2.Cost 
                BX2 = pop(i);
            end
        end
    end

    % --------------------------------------------------------------------%
    % SSA Operations
    c1 = 2*exp(-(4*l/MaxIt)^2); % Eq. (3.2) in the paper

    for i=1:nPop     
        if i<=nPop/2
            for j=1:1:nVar
                c2=rand();
                c3=rand();
                % Eq. (3.1) in the paper
                if c3<0.5 
                    pop(i).Position(j)=Food.Position(j)+c1*((VarMax-VarMin)*c2+VarMin);
                else
                    pop(i).Position(j)=Food.Position(j)-c1*((VarMax-VarMin)*c2+VarMin);
                end
            end
            
        elseif i>nPop/2 && i<nPop+1
            point1 = pop(i-1).Position;
            point2 = pop(i).Position;

            pop(i).Position=(point1+point2)/2; % % Eq. (3.4) in the paper
        end
    end

    for i=1:nPop

        % check the boundaries
        FlagUb = pop(i).Position>VarMax;
        FlagLb = pop(i).Position<VarMin;

        pop(i).Position = (pop(i).Position.*(~(FlagUb+FlagLb))) ...
            + VarMax.*FlagUb + VarMin.*FlagLb;

        % Convert the position of grew wolves into binary ones using
        pop(i).Position(1:inputSize) = TransformationFunction(pop(i).Position(1:inputSize));
        
        % Evaluation
        [pop(i).Cost, ~, pop(i).MDL] = CostFunction(pop(i).Position);        
        % Update Food, BX1, and BX2
        if pop(i).Cost<Food.Cost
            Food = pop(i);
            BX1  = pop(i);
        elseif pop(i).Cost>Food.Cost && pop(i).Cost<BX2.Cost 
            BX2 = pop(i);
        end
    end
    l = l + 1;

    % --------------------------------------------------------------------%
    % two-phase mutation
    % mutation
    Xmutated1 = Food.Position(1:inputSize);
    for mi = 1:nVar(1)
        r = rand();
        
        if r < Mp && Food.Position(mi) == 1
            Xmutated1(mi) = 0;
            [fitness_mutated, ~, mdl_mutated] = CostFunction([Xmutated1, Food.Position(inputSize+1:end)]);
            % Update Food, BX1, and BX2
            if fitness_mutated<Food.Cost
                Food.Cost     = fitness_mutated;
                Food.Position = [Xmutated1, Food.Position(inputSize+1:end)];
                Food.MDL      = mdl_mutated;
                BX1 = Food;
            elseif fitness_mutated>Food.Cost && fitness_mutated<BX2.Cost 
                BX2.Cost     = fitness_mutated;
                BX2.Position = [Xmutated1, Food.Position(inputSize+1:end)];
                BX2.MDL      = mdl_mutated;
            end
        end
    end
    
    Xmutated2 = Food.Position(1:inputSize);
    for i = 1:nVar(1)
        r = rand();
        
        if r < Mp && Food.Position(mi) == 0
            Xmutated2(i) = 1;
            [fitness_mutated, ~, mdl_mutated] = CostFunction([Xmutated2, Food.Position(inputSize+1:end)]);
            % Update Food, BX1, and BX2
            if fitness_mutated<Food.Cost
                Food.Cost     = fitness_mutated;
                Food.Position = [Xmutated2, Food.Position(inputSize+1:end)];
                Food.MDL      = mdl_mutated;
                BX1 = Food;
            elseif fitness_mutated>Food.Cost && fitness_mutated<BX2.Cost 
                BX2.Cost     = fitness_mutated;
                BX2.Position = [Xmutated2, Food.Position(inputSize+1:end)];
                BX2.MDL      = mdl_mutated;
            end
        end
    end

    % Store NFE
    nfe(it)=NFE;
    % Store Best Cost Ever Found
    BestCosts(it) = Food.Cost;
    
    % Store Best Mean Ever Found
    MeanCosts(it)=mean([pop.Cost]);

    search_history(:, it, :) = reshape([pop.Position],[sum(nVar),nPop])';
    fitness_history(:, it)   = [pop.Cost];
    % % % save Best Solution
    BESTSOLUTION(it) = Food;

    % Store Vpop
    Vpops(it) = Calc_DM(pop);

    % Stop Condition
    if it>2
        if abs(BestCosts(it-1)-BestCosts(it))<stop_cond_valBreak
            stop_cond = stop_cond+1;
        else
            stop_cond=0;
        end
    end
    if stop_cond>=stop_cond_numBreak
        break;
    end

    nFSS = sum(Food.Position(1:inputSize));
    % Show Iteration Information
    disp(['Iteration ',num2str(it),': FSS = ',num2str(nFSS)...
        ', Best Cost = ',num2str(BestCosts(it)), ', Stop Count = ',num2str(stop_cond)]);


end

Time = toc;

%% Results

BestSolution = Food;

figure;
plot(1:MaxIt,BestCosts,'LineWidth',2);
% semilogy(nfe,BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');

[~,Out] = CostFunction(BestSolution.Position);
Model = Food.MDL;
Results.Out = Out;
Results.Time = Time;
Results.BestCosts    = BestCosts;
Results.MeanCosts    = MeanCosts;
Results.BestSolution = BestSolution;
Results.nfe = nfe;

Results.BX2 = BX2;

Results.search_history = search_history;
Results.fitness_history = fitness_history;

Results.BESTSOLUTION = BESTSOLUTION;
Results.Vpops = Vpops;

end