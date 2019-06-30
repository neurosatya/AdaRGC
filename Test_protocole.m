%% Intialize data
clear all
addpath('MDM')
addpath('FgMDM')
addpath('Misc')

initformat = get(0,'format');
format('long');

load('protocol_data1.mat')

% protocol_data=data;

trueYtest  = protocol_data.labels(protocol_data.idxTest);

% trueYtest=trueYtest';

%% MDM
data = protocol_data;
[MDM_acc, MDM_dect, MDM_dist]				= MDM(data, 'normal', true);
data = protocol_data;
[MDM_acc_S, MDM_dect_S, MDM_dist_S]			= MDM(data, 'Supervised', true);
data = protocol_data;
[MDM_acc_U, MDM_dect_U, MDM_dist_U]			= MDM(data, 'Unsupervised', true);
data = protocol_data;
[MDM_acc_R, MDM_dect_R, MDM_dist_R]			= MDM(data, 'Rebias', true);
data = protocol_data;
[MDM_acc_R_S, MDM_dect_R_S, MDM_dist_R_S]	= MDM(data, 'Supervised Rebias', true);
data = protocol_data;
[MDM_acc_R_U, MDM_dect_R_U, MDM_dist_R_U]	= MDM(data, 'Unsupervised Rebias', true);


%% FgMDM
data = protocol_data;
[FgMDM_acc, FgMDM_dect, FgMDM_dist]			= FgMDM(data, 'normal', true);
data = protocol_data;
[FgMDM_acc_R, FgMDM_dect_R, FgMDM_dist_R]			= FgMDM(data, 'Rebias', true);
% data = protocol_data;
% [FgMDM_acc_S, FgMDM_dect_S, FgMDM_dist_S]	= FgMDM(data, 'Supervised', true);
% data = protocol_data;
% [FgMDM_acc_U, FgMDM_dect_U, FgMDM_dist_U]	= FgMDM(data, 'Unsupervised', true);
% data = protocol_data;
% FgMDM_acc_R			= RebiasAdaptationFgMDM(data);
% data = protocol_data;
% FgMDM_acc_S_R	= SupervisedRebiasAdaptationFgMDM(data);
% data = protocol_data;
% FgMDM_acc_U_R	= RebiasAdaptationFgMDM(data);

format(initformat);

%c = categorical({'MDM','FgMDM'});
%y = [MDM_acc MDM_acc_S MDM_acc_U MDM_acc_R MDM_acc_R_S MDM_acc_R_U; FgMDM_acc FgMDM_acc_S FgMDM_acc_U FgMDM_acc FgMDM_acc FgMDM_acc];
%bar(c,y);




