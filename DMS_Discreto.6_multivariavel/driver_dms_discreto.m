clear
clc
%% colocar todos os pontos da CACHE em x_ini
load('CACHE.mat')
x_ini=[];
% for ii=1:size(CACHE.X,1)
%     x_ini=[x_ini CACHE.X{ii,1}];
% end

N_max_simulated = 2;                        % Number of patches maximum (1 - 9)
Inc             = 0.05;                      

% Já fiz:
% Inc 0.5 N_max 5
% Uni Modal Inc 0.1 N_max 5
% Uni Modal Inc 0.05 N_max 5
% Multi Modal (6, 7 e 8) Inc 0.5 N_max 3
% Multi Modal (6, 7 e 8) Inc 0.1 N_max 3
% Multi Modal (6, 7 e 8) Inc 0.05 N_max 3

%% variaveis de projeto
x.x1=[-1 0: Inc: 1 ]';
for i = 2:N_max_simulated*2
    x.(['x' num2str(i)]) = x.x1;
end

for i = (N_max_simulated*2 + 1):18
    x.(['x' num2str(i)]) = [-1]';
end

DiscreteData = struct2cell(x);

%% identificar os pontos validos para as variaveis de projeto
% Inicializar vetor de colunas validas
valid_columns = true(1, size(x_ini, 2));
% identificar as colunas falsas
for col = 1:size(x_ini, 2)
    for row = 1:size(x_ini, 1)
        % Verificar se o valor esta dentro dos valores discretos permitidos com precisão de 12 dígitos
        if ~any(abs(x_ini(row, col) - DiscreteData{row}) < 1e-8)
            valid_columns(col) = false;
            break;
        end
    end
end

% Manter apenas as colunas validas em x_ini
x_ini_filtered = x_ini(:, valid_columns);
%% 

obj=[0 0 0 0 0 1 1 1 0 0 1];
format compact;
[Plist,Flist,alfa,func_eval] = dmsAguilar(1,'func_F','dms_paretofront.txt',...
    'dms_cache.txt',x_ini_filtered,DiscreteData,[],obj);