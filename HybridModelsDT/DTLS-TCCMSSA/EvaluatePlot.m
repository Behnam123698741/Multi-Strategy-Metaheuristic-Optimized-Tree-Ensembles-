function Results = EvaluatePlot(Y,Yhat,p,ModelName,DataName)

Ym    = mean(Y);
Yhatm = mean(Yhat);

Ystd    = std(Y);
Yhatstd = std(Yhat);


% Mean Squared Error
MSE = mean((Yhat - Y).^2);

% Root Mean Squared Error
RMSE = (mean((Yhat - Y).^2))^0.5;

% Normal Root Mean Squared Error
NRMSE = RMSE/Yhatstd;

% Relative Squared Error
RSE = sum((Yhat - Y).^2)/sum((ones(size(Y))*mean(Y) - Y).^2);

% Mean Absolute Error
MAE = mean(abs(Yhat - Y));

% Mean Absolute Percentage Error
MAPE = mean(abs((Yhat - Y) ./ Y));

% Nash-Sutcliffe Coefficient Efficiency 
NSE = 1 - ((sum((Yhat - Y).^2))/(sum((Y - Ym).^2)));

% Error of Peak Discharge 
SMAPE = mean(((sum(abs(Yhat - Y))) / ((sum(abs(Y))+abs(Yhat))/2)));

% R² score, the coefficient of determination
R2 = 1 - RSE;

% Adjusted R-Squared
n=numel(Y);
AdjR2 = 1-(1-R2)*((n-1)/(n-p-1));

% Explained variance score
EVS = 1 - std(Yhat - Y)/std(Y);

% Pearson Correlation
PearsonCorrelation = corrcoef(Y,Yhat);
R = PearsonCorrelation(1,2);

% 
E = 1 - (sum(abs(Yhat - Y)) / sum(abs(Y - Ym)));

WHD = sum((abs(Yhat - Y)) ./ (max(abs(Yhat), abs(Y))));

% WHD = sum((abs(Yhat - Y)) ./ (max(Yhat, Y)));


IA = 1 - ((sum((Yhat - Y).^2)) / (sum((abs(Y-Ym) + abs(Yhat-Yhatm)).^2)));

MdAE = median(abs(Yhat - Y));

% Kling-Gupta Efficiency
KGE = 1 - ((R-1).^2 + ((Yhatstd/Ystd) - 1).^2 + ((Yhatm/Ym) - 1).^2)^0.5;



% Store Results
Results.ModelName = [ModelName,' Regression Model'];
Results.DataName = [DataName,' Data'];
Results.RMSE = RMSE;
Results.NRMSE = NRMSE;
Results.MSE = MSE;
Results.MAE = MAE;
Results.MAPE = MAPE;
Results.NSE = NSE;
Results.SMAPE = SMAPE;
Results.RSE = RSE;
Results.R2 = R2;
Results.AdjR2 = AdjR2;
Results.R = R;
Results.EVS = EVS;
Results.E = E;
Results.WHD = WHD;
Results.IA = IA;
Results.MdAE = MdAE;
Results.KGE = KGE;
Results.Y = Y;
Results.Yhat = Yhat;
Results.Error = Y - Yhat;





figure;
subplot(2,2,[1 2]),
t = 1:numel(Y);
plot(t,Y,t,Yhat,'--','LineWidth',1.5)
grid on
legend('Y-Actual','Y-Predict','FontSize',12, 'FontName','Times New Roman');
title(['Curve Fitting: ', ModelName, ' for ',DataName, ' Data'],'FontSize',12, 'FontName','Times New Roman')
subplot(2,2,[3 4]),hist(Y-Yhat,20)
title(['Hist Error, RMSE = ',num2str(RMSE)],'FontSize',12, 'FontName','Times New Roman');
set(gca,'FontSize',12, 'FontName','Times New Roman')
grid on
figure, plotregression(Y,Yhat,ModelName);
 xlabel(['Targets, Regression for ',DataName,' Data'],'FontSize',12, 'FontName','Times New Roman')

 set(gca,'FontSize',12, 'FontName','Times New Roman')
grid on
disp(Results);
end
