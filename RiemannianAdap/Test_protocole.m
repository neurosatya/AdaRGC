%% Intialize data
clear all
addpath('MDM')
addpath('FgMDM')
addpath('Misc')

initformat = get(0,'format');
format('long');

load('protocol_data.mat')

trueYtest  = protocol_data.labels(protocol_data.idxTest);


%% MDM
data = protocol_data;
MDM_acc					= 100*numel(find(trueYtest-MDMBaseline(data)==0))/12;
data = protocol_data;
MDM_acc_Super			= 100*numel(find(trueYtest-SupervisedAdaptationMDM(data)==0))/12;
data = protocol_data;
MDM_acc_UnSup			= 100*numel(find(trueYtest-UnsupervisedAdaptationMDM(data)==0))/12;
data = protocol_data;
MDM_acc_Rebias			= 100*numel(find(trueYtest-RebiasAdaptationMDM(data)==0))/12;
data = protocol_data;
MDM_acc_Rebias_Super	= 100*numel(find(trueYtest-SupervisedRebiasAdaptationMDM(data)==0))/12;
data = protocol_data;
MDM_acc_Rebias_UnSup	= 100*numel(find(trueYtest-UnsupervisedRebiasAdaptationMDM(data)==0))/12;

%% FgMDM
data = protocol_data;
FgMDM_acc				= 100*numel(find(trueYtest-FgMDMBaseline(data)==0))/12;
data = protocol_data;
FgMDM_acc_Super			= 100*numel(find(trueYtest-SupervisedAdaptationFgMDM(data)==0))/12;
data = protocol_data;
FgMDM_acc_Super_Rebias	= 100*numel(find(trueYtest-SupervisedRebiasAdaptationFgMDM(data)==0))/12;
data = protocol_data;
%FgMDM_acc_UnSup			= 100*numel(find(trueYtest-UnSupervisedAdaptationFgMDM(data)==0))/12;
data = protocol_data;
FgMDM_acc_UnSup_Rebias	= 100*numel(find(trueYtest-RebiasAdaptationFgMDM(data)==0))/12;

format(initformat);




