for j=610:10:5000
    j
driver_glods_progressivo
%pause(1)
comand2 = strcat('copy /y glods_partial_results.txt glods_partial_results_',int2str(j),'.txt')
system(comand2)
%close all
clearvars -except j
clc
end
