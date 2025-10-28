%% Harmonic analyse
clear
clc

%% Get the results
% ==================== Amplitude ====================
fileID = fopen("Output_DataAmplitude_NoControl.txt",'r');
amplitude_thesis = fscanf(fileID,'%f');            % Get amplitude data

fileID = fopen("Output_DataAmplitude_Control.txt",'r');
amplitude_reference = fscanf(fileID,'%f');            % Get amplitude data

% ==================== Frequency ====================
fileID = fopen("Output_DataFrequency_NoControl.txt",'r');
w = fscanf(fileID,'%f');                         % Get frequency data
excited_w = w(1);
samples_w = w(2:end);

% Normalized value
norm = 0.1750;
%% Plot
figure(1)
plot(samples_w/excited_w,amplitude_thesis/norm,'r--','LineWidth',1)
hold on
plot(samples_w/excited_w,amplitude_reference/norm,'b-','LineWidth',1)

xlabel('Frequência Normalizada [ \omega_{n}/\omega_{central} ]')
ylabel('Amplitude Normalizada [ x_{n}/x_{max} ]')
legend(["Sem shunt", "Com shunt"])
xlim([min(samples_w/excited_w) max(samples_w/excited_w)])
ylim([0 3])
grid on

