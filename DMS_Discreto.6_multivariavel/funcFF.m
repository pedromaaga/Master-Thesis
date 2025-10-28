function [F,zz_adjusted] = funcFF(centers)
%% Problem variables
% Plate
LPL         = 0.414;                    % [m]
WPL         = 0.314;                    % [m]

% Patch material total
LPA_total   = LPL/5;                    % [m]
WPA_total   = WPL/5;                    % [m]
A_total     = LPA_total*WPA_total;


N           = length(centers) / 2;      % Number of pairs of patches
alpha       = LPA_total/WPA_total;      % Proportion between L and W of the patch

% Patch dimension
WPA         = sqrt(A_total/(alpha*N));  % [m]
LPA         = alpha*WPA;                % [m]

WPA         = round(WPA,4);
LPA         = round(LPA,4);

% Mesh size
L_mesh      = 3.175e-3;                 % [m]

%% Run ANSYS Program

if isempty(centers)
    F    = [Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf]';
else

    %format bank
    x=centers;

    % Abrir a pasta CodeAnsys
    cd('C:\Users\pedro\OneDrive\Documentos\USP\Duplo_diploma\[24_25] Semestre 2\Thesis\Code\Code Ansys');

    % escrever no ficheiro Input_GeometricParameters.txt
    if exist('Input_PositionPatches.txt','file')==2
        delete('Input_PositionPatches.txt');
    end

    fpoint = fopen('Input_PositionPatches.txt','w');
    fprintf(fpoint,'%.4f \n',[x]);
    fclose(fpoint);

    % escrever no ficheiro Input_GeometricParameters.txt
    if exist('Input_GeometricParameters.txt','file')==2
        delete('Input_GeometricParameters.txt');
    end

    fpoint = fopen('Input_GeometricParameters.txt','w');
    fprintf(fpoint,'%.4f \n',[N; LPL; WPL; LPA; WPA]);
    fclose(fpoint);


    if exist('Output_EMCC.txt','file')==2
        delete('Output_EMCC.txt');
    end

    % executar programa
    system('"C:\Program Files\ANSYS Inc\ANSYS Student\v251\ansys\bin\winx64\ANSYS251.exe" -b  -i CodeProject -o ficheirooutput');

    % ler resultados do programa do aluno 'Output_EMCC.txt'
    fvalue = fopen('Output_EMCC.txt','r');
    for i=1 : 10
        f_num(i) = fscanf(fvalue,'%f',1);
    end
    f_num(11) = N;
    fclose(fvalue);

    F    = (-1)*[f_num]';

    % Voltar ao diretorio original
    cd('C:\Users\pedro\OneDrive\Documentos\USP\Duplo_diploma\[24_25] Semestre 2\Thesis\Code\DMS_discreto.6_multivariavel');
end
end
