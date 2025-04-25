%% Harmonic Analysis
clear
clc

%% Initialization
amplitudes = {};  % Store amplitude data
frequencies = {}; % Store frequency data
labels = {};      % Store labels for the legend

% Loop to select files
datasetCount = 0;
while true
    % Select amplitude file
    [ampFileName, ampFilePath] = uigetfile('*.txt', 'Select an AMPLITUDE file (or cancel to stop)');
    if ampFileName == 0
        break;  % Exit loop if user cancels
    end
    fileID = fopen(fullfile(ampFilePath, ampFileName), 'r');
    amplitude = fscanf(fileID, '%f');
    fclose(fileID);

    % Select frequency file
    [freqFileName, freqFilePath] = uigetfile('*.txt', 'Select a corresponding FREQUENCY file');
    if freqFileName == 0
        break;  % Exit loop if user cancels
    end
    fileID = fopen(fullfile(freqFilePath, freqFileName), 'r');
    freqData = fscanf(fileID, '%f');
    fclose(fileID);

    % Process data
    excited_w = freqData(1);          % Excitation frequency
    samples_w = freqData(2:end);      % Normalized frequency samples

    % Store data
    datasetCount = datasetCount + 1;
    amplitudes{datasetCount} = amplitude;
    frequencies{datasetCount} = samples_w ;
    % frequencies{datasetCount} = samples_w / excited_w;
    
    % Add label for legend
    labels{datasetCount} = sprintf('Dataset %d', datasetCount);
end

% Check if at least one dataset was selected
if datasetCount == 0
    error('No file pairs were selected. Exiting...');
end

%% Define normalization value
Norm_type = 2;      % 1 - Fixed Normalization
                    % 2 - Center Normalization
                    % 3 - MinMax Normalization

if Norm_type == 1
    norm = 0.004170;  % Fixed normalization value
elseif Norm_type == 2
    maxAmplitudes = cellfun(@max, amplitudes);
    [~, idxMinMax] = min(maxAmplitudes);
    % Pega a mediana da curva correspondente
    norm = median(amplitudes{idxMinMax});
else
    % MinMax normalization: get the minimum of the maximum amplitudes
    maxAmplitudes = cellfun(@max, amplitudes);
    norm = min(maxAmplitudes);
end

%% Plot
figure;
hold on;
colors = {'r--', 'b-', 'g-.', 'k:', 'm-', 'c--'};  % Colors for different datasets

for i = 1:datasetCount
    colorIdx = mod(i - 1, length(colors)) + 1;  % Ensure color cycling
    plot(frequencies{i}, amplitudes{i} / norm, colors{colorIdx}, 'LineWidth', 1);
end

xlabel('Frequência [Hz]');
%xlabel('Frequência Normalizada [ \omega_{n}/\omega_{central} ]');
ylabel('Amplitude Normalizada [ x_{n}/x_{MinMax} ]');
legend(labels, 'Location', 'Best');
xlim([max(cellfun(@(x) min(x), frequencies)), min(cellfun(@(x) max(x), frequencies))]);
ylim([0 3]);

set(gca, 'FontSize', 16);
set(gcf, 'Position', [100, 100, 800, 600]);
grid on;




