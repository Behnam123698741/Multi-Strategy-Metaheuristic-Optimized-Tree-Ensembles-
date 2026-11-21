% 
clc
clear
close all
warning off

%% Data Loading
load DataFire


Data = DataFire;

idx0 = find(Data(:, 1) == 0);
idx1 = find(Data(:, 1) == 1);
cnt_0 = numel(idx0);
cnt_1 = numel(idx1);
Data0 = Data(idx0, [2, 6]);
Data1 = Data(idx1, [2, 6]);

idx = 1;
ZP =      round(([sum(Data0(:,idx)==1), sum(Data0(:,idx)==2), sum(Data0(:,idx)==3), sum(Data0(:,idx)==4), sum(Data0(:,idx)==5)] / cnt_0) * 10000)/100;
OP =      round(([sum(Data1(:,idx)==1), sum(Data1(:,idx)==2), sum(Data1(:,idx)==3), sum(Data1(:,idx)==4), sum(Data1(:,idx)==5)] / cnt_1) * 10000)/100;

idx = 2;
ZP = [ZP; round(([sum(Data0(:,idx)==1), sum(Data0(:,idx)==2), sum(Data0(:,idx)==3), sum(Data0(:,idx)==4), sum(Data0(:,idx)==5)] / cnt_0) * 10000)/100];
OP = [OP; round(([sum(Data1(:,idx)==1), sum(Data1(:,idx)==2), sum(Data1(:,idx)==3), sum(Data1(:,idx)==4), sum(Data1(:,idx)==5)] / cnt_1) * 10000)/100];

aFire = [ZP; OP];


%% Data Loading
load DataFlood


Data = DataFlood;

idx0 = find(Data(:, 1) == 0);
idx1 = find(Data(:, 1) == 1);
cnt_0 = numel(idx0);
cnt_1 = numel(idx1);
Data0 = Data(idx0, [3, 7]);
Data1 = Data(idx1, [3, 7]);

idx = 1;
ZP =      round(([sum(Data0(:,idx)==1), sum(Data0(:,idx)==2), sum(Data0(:,idx)==3), sum(Data0(:,idx)==4), sum(Data0(:,idx)==5)] / cnt_0) * 10000)/100;
OP =      round(([sum(Data1(:,idx)==1), sum(Data1(:,idx)==2), sum(Data1(:,idx)==3), sum(Data1(:,idx)==4), sum(Data1(:,idx)==5)] / cnt_1) * 10000)/100;

idx = 2;
ZP = [ZP; round(([sum(Data0(:,idx)==1), sum(Data0(:,idx)==2), sum(Data0(:,idx)==3), sum(Data0(:,idx)==4), sum(Data0(:,idx)==5)] / cnt_0) * 10000)/100];
OP = [OP; round(([sum(Data1(:,idx)==1), sum(Data1(:,idx)==2), sum(Data1(:,idx)==3), sum(Data1(:,idx)==4), sum(Data1(:,idx)==5)] / cnt_1) * 10000)/100];

aFlood = [ZP; OP];




%% Data Loading
load DataLandslide


Data = DataLandslide;

idx0 = find(Data(:, 1) == 0);
idx1 = find(Data(:, 1) == 1);
cnt_0 = numel(idx0);
cnt_1 = numel(idx1);
Data0 = Data(idx0, [4, 8]);
Data1 = Data(idx1, [4, 8]);

idx = 1;
ZP =      round(([sum(Data0(:,idx)==1), sum(Data0(:,idx)==2), sum(Data0(:,idx)==3), sum(Data0(:,idx)==4), sum(Data0(:,idx)==5)] / cnt_0) * 10000)/100;
OP =      round(([sum(Data1(:,idx)==1), sum(Data1(:,idx)==2), sum(Data1(:,idx)==3), sum(Data1(:,idx)==4), sum(Data1(:,idx)==5)] / cnt_1) * 10000)/100;

idx = 2;
ZP = [ZP; round(([sum(Data0(:,idx)==1), sum(Data0(:,idx)==2), sum(Data0(:,idx)==3), sum(Data0(:,idx)==4), sum(Data0(:,idx)==5)] / cnt_0) * 10000)/100];
OP = [OP; round(([sum(Data1(:,idx)==1), sum(Data1(:,idx)==2), sum(Data1(:,idx)==3), sum(Data1(:,idx)==4), sum(Data1(:,idx)==5)] / cnt_1) * 10000)/100];

aLandslide = [ZP; OP];

%% Data Loading
load DataLS


Data = DataLS;

idx0 = find(Data(:, 1) == 0);
idx1 = find(Data(:, 1) == 1);
cnt_0 = numel(idx0);
cnt_1 = numel(idx1);
Data0 = Data(idx0, [5, 9]);
Data1 = Data(idx1, [5, 9]);

idx = 1;
ZP =      round(([sum(Data0(:,idx)==1), sum(Data0(:,idx)==2), sum(Data0(:,idx)==3), sum(Data0(:,idx)==4), sum(Data0(:,idx)==5)] / cnt_0) * 10000)/100;
OP =      round(([sum(Data1(:,idx)==1), sum(Data1(:,idx)==2), sum(Data1(:,idx)==3), sum(Data1(:,idx)==4), sum(Data1(:,idx)==5)] / cnt_1) * 10000)/100;

idx = 2;
ZP = [ZP; round(([sum(Data0(:,idx)==1), sum(Data0(:,idx)==2), sum(Data0(:,idx)==3), sum(Data0(:,idx)==4), sum(Data0(:,idx)==5)] / cnt_0) * 10000)/100];
OP = [OP; round(([sum(Data1(:,idx)==1), sum(Data1(:,idx)==2), sum(Data1(:,idx)==3), sum(Data1(:,idx)==4), sum(Data1(:,idx)==5)] / cnt_1) * 10000)/100];

aLS = [ZP; OP];






















