function [Model,Results] = TrainUsingTCCMEEFO(TrainData,Params)

disp('Optimizing Model Hyperparameters and Feature Selection with TCCMEEFO ...')
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
    pop(i).Cost = CostFunction(pop(i).Position);
end

% Sort Population
Costs=[pop.Cost];
[~, SortOrder]=sort(Costs);

Prey = pop(SortOrder(1));
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

            % Update Prey, BX1, and BX2
            if pop(i).Cost<Prey.Cost
                Prey = pop(i);
                BX1  = pop(i);
            elseif pop(i).Cost>Prey.Cost && pop(i).Cost<BX2.Cost 
                BX2 = pop(i);
            end
        end
    end

    % --------------------------------------------------------------------%
    % EEFO Operations
    DirectVector=zeros(nPop,nVarSum);
    E0=4*sin(1-it/MaxIt);

    for i=1:nPop
        
        E=E0*log(1/rand); % Eq.(30)

        if nVarSum==1
            DirectVector(i,:)=1;
        else
            RandNum=ceil((MaxIt-it)/MaxIt*rand*(nVarSum-2)+2); %Eq.(6)
            RandDim=randperm(nVarSum);
            DirectVector(i,RandDim(1:RandNum))=1;
        end

        if E>1
            K=[1:i-1 i+1:nPop];
            j=K(randi(nPop-1));
            %Eq.(7),interacting
            if pop(j).Cost<pop(i).Cost
                if rand>0.5
                    newPopPos=pop(j).Position+randn*DirectVector(i,:).*( mean_pos(pop)-pop(i).Position);
                else
                    xr=rand(1,nVarSum).*(VarMax-VarMin)+VarMin;
                    newPopPos=pop(j).Position+1*randn*DirectVector(i,:).*( xr-pop(i).Position);
                end
            else
                if rand>0.5
                    newPopPos=pop(i).Position+randn*DirectVector(i,:).*(mean_pos(pop)-pop(j).Position);
                else
                    xr=rand(1,nVarSum).*(VarMax-VarMin)+VarMin;
                    newPopPos=pop(i).Position+randn*DirectVector(i,:).*( xr-pop(j).Position);
                end
            end
        else
            if rand<1/3
                % resting
                Alpha=2*(exp(1)-exp(it/MaxIt))*sin(2*pi*rand); % Eq.(15)
                rn=randi(nPop);
                rd=randi(nVarSum);
                Z=pop(rn).Position(rd)*ones(1,nVarSum);% Eq.(12)
                Ri=Z+Alpha.*abs(Z-Prey.Position);% Eq.(14)
                newPopPos=Ri+randn*(Ri-round(rand)*pop(i).Position);% Eq.(16)
            elseif rand>2/3
                % migrating
                rn=randi(nPop);
                rd=randi(nVarSum);
                Z=pop(rn).Position(rd)*ones(1,nVarSum);
                Alpha=2*(exp(1)-exp(it/MaxIt))*sin(2*pi*rand);
                Ri=Z+Alpha.*abs(Z-Prey.Position); % resting area
                Beta=2*(exp(1)-exp(it/MaxIt))*sin(2*pi*rand);%Eq.(21)
                Hr=Prey.Position+Beta*abs(mean_pos(pop)-Prey.Position);%Eq.(25) hunting area
                L=0.01*abs(levy(nVarSum)); %Eq.(26)
                newPopPos=-rand*Ri+rand*Hr-L.*(Hr-pop(i).Position);%Eq.(24)
            else
                %Hunting
                Beta=2*(exp(1)-exp(it/MaxIt))*sin(2*pi*rand);%Eq.(21)
                Hprey=Prey.Position+Beta*abs(mean_pos(pop)-Prey.Position);% Eq.(20) hunting area
                r4=rand;
                Eta=exp(r4*(1-it)/MaxIt)*(cos(2*pi*r4)); %Eq.(23)
                newPopPos=Hprey+Eta*(Hprey-round(rand)*pop(i).Position);%Eq.(22) hunting
            end
        end


        % check the boundaries
        FlagUb = newPopPos>VarMax;
        FlagLb = newPopPos<VarMin;

        newPopPos = (newPopPos.*(~(FlagUb+FlagLb))) ...
            + VarMax.*FlagUb + VarMin.*FlagLb;

        % Convert the position of grew wolves into binary ones using
        newPopPos(1:inputSize) = TransformationFunction(newPopPos(1:inputSize));

        % Evaluation
        [newPopFit, ~, newPopMDL] = CostFunction(newPopPos);

        if newPopFit<pop(i).Cost
            pop(i).Position = newPopPos;
            pop(i).Cost     = newPopFit;
            pop(i).MDL      = newPopMDL;

            % Update Prey, BX1, and BX2
            if pop(i).Cost<Prey.Cost
                Prey = pop(i);
                BX1  = pop(i);
            elseif pop(i).Cost>Prey.Cost && pop(i).Cost<BX2.Cost 
                BX2 = pop(i);
            end
        end
    end


    % --------------------------------------------------------------------%
    % two-phase mutation
    % mutation
    Xmutated1 = Prey.Position(1:inputSize);
    for mi = 1:nVar(1)
        r = rand();
        
        if r < Mp && Prey.Position(mi) == 1
            Xmutated1(mi) = 0;
            [fitness_mutated, ~, mdl_mutated] = CostFunction([Xmutated1, Prey.Position(inputSize+1:end)]);
            % Update Prey, BX1, and BX2
            if fitness_mutated<Prey.Cost
                Prey.Cost     = fitness_mutated;
                Prey.Position = [Xmutated1, Prey.Position(inputSize+1:end)];
                Prey.MDL      = mdl_mutated;
                BX1 = Prey;
            elseif fitness_mutated>Prey.Cost && fitness_mutated<BX2.Cost 
                BX2.Cost     = fitness_mutated;
                BX2.Position = [Xmutated1, Prey.Position(inputSize+1:end)];
                BX2.MDL      = mdl_mutated;
            end
        end
    end
    
    Xmutated2 = Prey.Position(1:inputSize);
    for i = 1:nVar(1)
        r = rand();
        
        if r < Mp && Prey.Position(mi) == 0
            Xmutated2(i) = 1;
            [fitness_mutated, ~, mdl_mutated] = CostFunction([Xmutated2, Prey.Position(inputSize+1:end)]);
            % Update Prey, BX1, and BX2
            if fitness_mutated<Prey.Cost
                Prey.Cost     = fitness_mutated;
                Prey.Position = [Xmutated2, Prey.Position(inputSize+1:end)];
                Prey.MDL      = mdl_mutated;
                BX1 = Prey;
            elseif fitness_mutated>Prey.Cost && fitness_mutated<BX2.Cost 
                BX2.Cost     = fitness_mutated;
                BX2.Position = [Xmutated2, Prey.Position(inputSize+1:end)];
                BX2.MDL      = mdl_mutated;
            end
        end
    end

    % Store NFE
    nfe(it)=NFE;
    % Store Best Cost Ever Found
    BestCosts(it) = Prey.Cost;
    
    % Store Best Mean Ever Found
    MeanCosts(it)=mean([pop.Cost]);

    search_history(:, it, :) = reshape([pop.Position],[sum(nVar),nPop])';
    fitness_history(:, it)   = [pop.Cost];
    % % % save Best Solution
    BESTSOLUTION(it) = Prey;

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

    nFSS = sum(Prey.Position(1:inputSize));
    % Show Iteration Information
    disp(['Iteration ',num2str(it),': FSS = ',num2str(nFSS)...
        ', Best Cost = ',num2str(BestCosts(it)), ', Stop Count = ',num2str(stop_cond)]);


end

Time = toc;

%% Results

BestSolution = Prey;

figure;
plot(1:MaxIt,BestCosts,'LineWidth',2);
% semilogy(nfe,BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');

[~,Out] = CostFunction(BestSolution.Position);
Model = Prey.MDL;
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