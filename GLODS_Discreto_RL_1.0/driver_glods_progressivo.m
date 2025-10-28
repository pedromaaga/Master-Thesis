%{
Otimizações já feitas


IV) Caso para verificar o programa de otimização (modo 1)
N_patches = 1;
interval_r = [42000:100:47000];
interval_ind = [30:0.5:40];
interval_circ = [5];

III) Caso de 3 Patches com configuração ótima da Média Harmônica (modo 6,7,8)
N_patches = 3;          
interval_r = [30000:100:60000];
interval_ind = [3:0.1:6];
interval_circ = [5];

II) Caso de 2 Patches com configuração ótima do MinMax (modo 6,7,8)
N_patches = 2;
interval_r = [10000:100:40000];
interval_ind = [1.5:0.1:3.5];
interval_circ = [5];

I) Caso de 1 Patches com configuração ótima do MinMax (modo 6,7,8)
N_patches = 1;
interval_r = [4000:100:20000];
interval_ind = [0.2:0.1:2];
interval_circ = [5];
%}
%%
delete file*
%%
clear
clc
%% colocar todos os pontos da CACHE em x_ini
load('CACHE.mat')
x_ini=[];
% for ii=1:size(CACHE.X,1)
%     x_ini=[x_ini CACHE.X{ii,1}];
% end
%

%% Parameters
N_patches = 1;              % Remenber to put the right configuration
interval_r = [42000:100:47000];
interval_ind = [30:0.5:40];
interval_circ = [5];

%% variaveis de projeto
% Resistors
x.x1=interval_r';
for i = 2:N_patches
    x.(['x' num2str(i)]) = x.x1;
end

% Inductors
x.(['x' num2str(N_patches+1)]) = interval_ind';
for i = N_patches+2:2*N_patches
    x.(['x' num2str(i)]) = x.(['x' num2str(N_patches+1)]);
end

% Circuit type
x.(['x' num2str(2*N_patches+1)]) = interval_circ';
for i = 2*N_patches+2:3*N_patches
    x.(['x' num2str(i)]) = x.(['x' num2str(2*N_patches+1)]);
end

DiscreteData = struct2cell(x);
format compact;

%%
[glods_profile,Plist,flist,alfa,radius,func_eval] = glods_progressivo('func_f','glods_partial_results.txt',x_ini,DiscreteData);
%
