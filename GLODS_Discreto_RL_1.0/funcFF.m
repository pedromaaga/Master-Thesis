function [F] = funcFF(zz);
    %
    format bank
    % Abrir a pasta CodeAnsys
    cd('C:\Users\pedro\OneDrive\Documentos\USP\Duplo_diploma\[24_25] Semestre 2\Thesis\Code\Code Ansys');
    
    % escrever no ficheiro Input_EletricValues.txt
    if exist('Input_EletricValues.txt','file')==2
        delete('Input_EletricValues.txt');
    end
    
    fpoint = fopen('Input_EletricValues.txt','w');
    fprintf(fpoint,'%.4f \n',[zz]);
    fclose(fpoint);
    
    % Delete output files
    if exist('Output_DataAmplitude.txt','file')==2
        delete('Output_DataAmplitude.txt');
    end
    
    if exist('Output_DataFrequency.txt','file')==2
        delete('Output_DataFrequency.txt');
    end
    
    % executar programa
    system('"C:\Program Files\ANSYS Inc\ANSYS Student\v251\ansys\bin\winx64\ANSYS251.exe" -b  -i CodeProject -o ficheirooutput');
    
    % ler resultados do programa do aluno 'Output_DataAmplitude.txt'
    fvalue = fopen('Output_DataAmplitude.txt','r');
    f_num = fscanf(fvalue, '%f');
    fclose(fvalue);
    
    F    = max(f_num)';
    
    % Voltar ao diretorio original
    cd('C:\Users\pedro\OneDrive\Documentos\USP\Duplo_diploma\[24_25] Semestre 2\Thesis\Code\GLODS_Discreto_RL_1.0');
end
