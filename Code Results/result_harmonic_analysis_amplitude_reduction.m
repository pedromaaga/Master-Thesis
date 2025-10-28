%% Harmonic Analysis - Comparação Controle vs Sem Controle
clear;
clc;

%% Inicialização
reducoes_absolutas = {};     % Redução absoluta entre pares
frequencias_plot = {};       % Frequências correspondentes
pares = {};                  % Nomes dos pares para legenda
amplitudes_sem_arr = {};     % Amplitudes sem controle
amplitudes_com_arr = {};     % Amplitudes com controle
parIndex = 0;

%% Loop para leitura de pares (sem controle e com controle)
while true
    % --- SEM CONTROLE ---
    [ampFileName1, ampFilePath1] = uigetfile('*.txt', 'Selecione o arquivo de AMPLITUDE SEM CONTROLE (ou cancelar para sair)');
    if ampFileName1 == 0
        break;
    end
    fileID = fopen(fullfile(ampFilePath1, ampFileName1), 'r');
    amp_sem_controle = fscanf(fileID, '%f');
    fclose(fileID);

    [freqFileName1, freqFilePath1] = uigetfile('*.txt', 'Selecione o arquivo de FREQUÊNCIA SEM CONTROLE');
    if freqFileName1 == 0
        break;
    end
    fileID = fopen(fullfile(freqFilePath1, freqFileName1), 'r');
    freq_sem_controle = fscanf(fileID, '%f');
    fclose(fileID);
    freq_sem_controle = freq_sem_controle(2:end);

    % --- COM CONTROLE ---
    [ampFileName2, ampFilePath2] = uigetfile('*.txt', 'Selecione o arquivo de AMPLITUDE COM CONTROLE');
    if ampFileName2 == 0
        break;
    end
    fileID = fopen(fullfile(ampFilePath2, ampFileName2), 'r');
    amp_com_controle = fscanf(fileID, '%f');
    fclose(fileID);

    [freqFileName2, freqFilePath2] = uigetfile('*.txt', 'Selecione o arquivo de FREQUÊNCIA COM CONTROLE');
    if freqFileName2 == 0
        break;
    end
    fileID = fopen(fullfile(freqFilePath2, freqFileName2), 'r');
    freq_com_controle = fscanf(fileID, '%f');
    fclose(fileID);
    freq_com_controle = freq_com_controle(2:end);

    % Verificações
    if length(amp_sem_controle) ~= length(amp_com_controle)
        warning('Tamanhos diferentes. Ignorado.');
        continue;
    end
    if ~isequal(freq_sem_controle, freq_com_controle)
        warning('Frequências diferentes. Ignorado.');
        continue;
    end

    % Armazenamento
    parIndex = parIndex + 1;
    reducoes_absolutas{parIndex} = amp_sem_controle - amp_com_controle;
    frequencias_plot{parIndex} = freq_sem_controle;
    pares{parIndex} = sprintf('Par %d', parIndex);
    amplitudes_sem_arr{parIndex} = amp_sem_controle;
    amplitudes_com_arr{parIndex} = amp_com_controle;
end

%% Verificação
if parIndex == 0
    error('Nenhum par foi processado.');
end

%% Limites comuns de frequência
minFreqs = cellfun(@(x) min(x), frequencias_plot);
maxFreqs = cellfun(@(x) max(x), frequencias_plot);
x_min = max(minFreqs);
x_max = min(maxFreqs);

%% FIGURA 1: Comparação direta das curvas com área entre elas preenchida (com normalização por par)
figure(1); clf;
colors = lines(parIndex);  % Cores para cada par

Norm_type = 3;  % Tipo de normalização: 1 - Fixo, 2 - Mediana, 3 - MinMax

for i = 1:parIndex
    subplot(parIndex,1,i); hold on;
    freq = frequencias_plot{i};
    amp_sem = amplitudes_sem_arr{i};
    amp_com = amplitudes_com_arr{i};

    % === NORMALIZAÇÃO ===
    switch Norm_type
        case 1
            norm_val = 0.004170;  % Valor fixo
        case 2
            % Mediana da curva com menor pico máximo
            max_sem = max(amp_sem);
            max_com = max(amp_com);
            if max_sem < max_com
                norm_val = median(amp_sem);
            else
                norm_val = median(amp_com);
            end
        otherwise  % MinMax
            % Mínimo entre os máximos das duas curvas
            norm_val = min([max(amp_sem), max(amp_com)]);
    end

    amp_sem_norm = amp_sem / norm_val;
    amp_com_norm = amp_com / norm_val;

    % Cor base do par
    base_color = colors(i,:);
    % Encontrar onde sem controle está acima de com controle
    mask = amp_sem_norm > amp_com_norm;
    mask = mask(:);  % Garantir coluna
    
    % Identificar regiões contínuas onde mask == true
    dmask = diff([0; mask; 0]);
    ini = find(dmask == 1);
    fim = find(dmask == -1) - 1;
    
    % Preencher apenas essas regiões
    area_legend_added = false;
    for j = 1:length(ini)
        idx = ini(j):fim(j);
        f = freq(idx);
        y1 = amp_sem_norm(idx);
        y2 = amp_com_norm(idx);
    
        if ~area_legend_added
            h_fill = fill([f; flipud(f)], [y1; flipud(y2)], ...
                 base_color + (1 - base_color) * 0.5, ...
                 'EdgeColor', 'none', 'FaceAlpha', 0.5, ...
                 'DisplayName', 'Redução de Amplitude');
            area_legend_added = true;
        else
            fill([f; flipud(f)], [y1; flipud(y2)], ...
                 base_color + (1 - base_color) * 0.5, ...
                 'EdgeColor', 'none', 'FaceAlpha', 0.5, ...
                 'HandleVisibility', 'off');  % Oculta do legend
        end
    end

    % Curvas com controle e sem controle (mesma cor, estilos diferentes)
    plot(freq, amp_sem_norm, '-', 'LineWidth', 1.5, 'Color', base_color, 'DisplayName', 'Sem Controle');
    plot(freq, amp_com_norm, '--', 'LineWidth', 1.5, 'Color', base_color, 'DisplayName', 'Com Controle');

    xlim([x_min, x_max]);
    ylim([0 3]);
    ylabel('Amplitude Normalizada');
    legend('Location', 'Best');
    title(sprintf('Comparação - %s', pares{i}));
    grid on;
    set(gca, 'FontSize', 12);
end
xlabel('Frequência [Hz]');



%% FIGURA 2: Energia Dissipada Acumulada Normalizada
figure(2); clf;
hold on;
colors = lines(parIndex);

for i = 1:parIndex
    freq = frequencias_plot{i};
    amp_sem = amplitudes_sem_arr{i};
    amp_com = amplitudes_com_arr{i};

    area_acum_sem = cumtrapz(freq, amp_sem);
    area_acum_com = cumtrapz(freq, amp_com);

    energia_total = area_acum_sem(end);
    energia_dissipada_norm = 100*(area_acum_sem - area_acum_com) / energia_total;

    plot(freq, energia_dissipada_norm, 'LineWidth', 1.5, 'Color', colors(i,:), 'DisplayName', pares{i});
end

xlabel('Frequência [Hz]');
ylabel('% de Energia Dissipada');
legend('Location', 'Best');
xlim([x_min, x_max]);
ylim([-5 100]);
grid on;
set(gca, 'FontSize', 14);

%% FIGURA 3: Redução Absoluta de Amplitude
figure(3); clf;
hold on;
for i = 1:parIndex
    plot(frequencias_plot{i}, reducoes_absolutas{i}, 'LineWidth', 1.5, 'Color', colors(i,:), 'DisplayName', pares{i});
end

xlabel('Frequência [Hz]');
ylabel('Redução Absoluta de Amplitude');
legend('Location', 'Best');
xlim([x_min, x_max]);
grid on;
set(gca, 'FontSize', 14);

