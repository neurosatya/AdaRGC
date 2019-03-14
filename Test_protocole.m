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
MDM_acc					= MDMBaseline(data);
data = protocol_data;
MDM_acc_Super			= SupervisedAdaptationMDM(data);
data = protocol_data;
MDM_acc_UnSup			= UnsupervisedAdaptationMDM(data);
data = protocol_data;
MDM_acc_Rebias			= RebiasAdaptationMDM(data);
data = protocol_data;
MDM_acc_Rebias_Super	= SupervisedRebiasAdaptationMDM(data);
data = protocol_data;
MDM_acc_Rebias_UnSup	= UnsupervisedRebiasAdaptationMDM(data);

%% FgMDM
data = protocol_data;
FgMDM_acc				= FgMDMBaseline(data);
data = protocol_data;
FgMDM_acc_Super			= SupervisedAdaptationFgMDM(data);
data = protocol_data;
FgMDM_acc_UnSup			= UnSupervisedAdaptationFgMDM(data);
% data = protocol_data;
% FgMDM_acc_Rebias			= RebiasAdaptationFgMDM(data);
% data = protocol_data;
% FgMDM_acc_Super_Rebias	= SupervisedRebiasAdaptationFgMDM(data);
% data = protocol_data;
% FgMDM_acc_UnSup_Rebias	= RebiasAdaptationFgMDM(data);

format(initformat);

c = categorical({'MDM','FgMDM'});
y = [MDM_acc MDM_acc_Super MDM_acc_UnSup MDM_acc_Rebias MDM_acc_Rebias_Super MDM_acc_Rebias_UnSup; FgMDM_acc FgMDM_acc_Super FgMDM_acc_UnSup FgMDM_acc FgMDM_acc FgMDM_acc];
bar(c,y);




