% 
% SVR
% 
clc
clear
close all
warning off

%% Model Loading
Convergence = [];
HP = [];

load ../../Outputs/FloodBS/HMOutput_DTLSTCCMEEFO
yDTLSTCCMEEFO = getXYCP(HMOutput.BestCosts);
HP = [HP; HMOutput.HP];

load ../../Outputs/FloodBS/HMOutput_DTLSTCCMSSA
yDTLSTCCMSSA = getXYCP(HMOutput.BestCosts);
HP = [HP; HMOutput.HP];

load ../../Outputs/FloodBS/HMOutput_DTBTCCMEEFO
yDTBTCCMEEFO = getXYCP(HMOutput.BestCosts);
HP = [HP; HMOutput.HP];

load ../../Outputs/FloodBS/HMOutput_DTBTCCMSSA
yDTBTCCMSSSA = getXYCP(HMOutput.BestCosts);
HP = [HP; HMOutput.HP];

%% 
MaxIt = 200;
x = 1:MaxIt;

%% MLP 
figure
set(gcf,'position',[451.4,224.2,652,436.8])

semilogy(yDTLSTCCMEEFO, 'LineWidth', 1.3);hold on
semilogy(yDTLSTCCMSSA, 'LineWidth', 1.3);hold on

semilogy(yDTBTCCMEEFO, 'LineWidth', 1.3);hold on
semilogy(yDTBTCCMSSSA, 'LineWidth', 1.3);hold on


semilogy(ones(MaxIt,1)*0.26, 'LineWidth', 0.001,'Color','#0072BD');hold on
semilogy(ones(MaxIt,1)*0.19, 'LineWidth', 0.001,'Color','#0072BD');hold on

set(gca,'FontSize',12, 'FontName','Times New Roman');
xlabel(['Iteration'],'FontSize',12, 'FontName','Times New Roman', 'FontWeight','bold')
ylabel(['Best Score Obtained So Far'],'FontSize',12, 'FontName','Times New Roman', 'FontWeight','bold')
% title(['Objective Space'],'FontSize',12, 'FontName','Times New Roman');

lgd = legend('DTLS-TCCMEEFO','DTLS-TCCMSSA',...
             'DTB-TCCMEEFO','DTB-TCCMSSA',...
             'Location','northeast',...
             'FontSize',11, 'FontName','Times New Roman');
axis tight
grid on
box on

%% SVR




















