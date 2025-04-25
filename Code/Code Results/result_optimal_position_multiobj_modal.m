clear all
clc

%% Carregar os dados
load CACHE.mat

x = reshape(cell2mat(CACHE.X), 18, length(CACHE.X));
obj_func = reshape(cell2mat(CACHE.OF), 11, length(CACHE.OF));

%% Variáveis de análise
modes_all = [6, 7, 8];
all_patches = [1, 2, 3];  % Todas as quantidades de patches disponíveis

% Combinações de 2
comb2 = num2cell(nchoosek(modes_all, 2), 2);
% Combinações de 3
comb3 = num2cell(nchoosek(modes_all, 3), 2);
mode_combinations_2d = comb2;  % Apenas biobjetivo
mode_combinations_3d = comb3;  % Triobjetivo

%% Variáveis para armazenar os pontos
pareto_points_x_perc = struct();
pareto_points_x_abs = struct();
pareto_points_of = struct();

%% Fronteira de Pareto 
% Loop para cada quantidade de patches e combinação de modos

for qnt_patches = all_patches
    % Filtrar apenas os pontos com essa quantidade de patches
    patch_filter = (obj_func(11, :) == -qnt_patches);
    filtered_of = obj_func(:, patch_filter);
    filtered_x = x(:, patch_filter);

    % Para cada combinação de 2 modos (biobjetivo)
    for comb_idx = 1:length(mode_combinations_2d)
        current_modes = mode_combinations_2d{comb_idx};
        n_obj = length(current_modes);

        % Coletar objetivos para os modos
        objectives = zeros(n_obj, size(filtered_of, 2));
        for j = 1:n_obj
            objectives(j, :) = filtered_of(current_modes(j), :);
        end
        objectives = objectives';

        % Calcular fronteira de Pareto
        pareto_idx = paretoGroup(objectives);

        % Filtrar os índices que são iguais a 1 (pertencem à fronteira de Pareto)
        pareto_idx_1 = find(pareto_idx == 1);

        % Armazenar os pontos absolutos para os índices da fronteira de Pareto
        for i = 1:length(pareto_idx_1)
            idx = pareto_idx_1(i);  % Extrair o índice individual

            zz = filtered_x(:, idx);  % Extrair a posição correspondente
            [~, position] = optimize_patch_centers(zz);  % Calcular a posição absoluta
            
            % Criar uma chave única para cada combinação de modos e quantidade de patches
            key = sprintf('qnt_patches_%d_modes_%d_%d', qnt_patches, current_modes(1), current_modes(2));
            
            % Armazenar os pontos de porcentagem e de objetivo na estrutura
            if ~isfield(pareto_points_x_perc, key)
                pareto_points_x_perc.(key) = {};  % Inicializa o campo caso não exista
                pareto_points_x_abs.(key) = {};  % Inicializa o campo caso não exista
                pareto_points_of.(key) = {};    % Inicializa o campo caso não exista
            end
            
            % Armazenar os valores em porcentagem e absolutos
            pareto_points_x_perc.(key){end+1} = zz;        % Armazenar os valores percentuais (zz)
            pareto_points_x_abs.(key){end+1} = position;    % Armazenar os valores absolutos (position)
            pareto_points_of.(key){end+1} = -objectives(idx, :);  % Armazenar os valores dos objetivos
        end
    end

    % Para cada combinação de 3 modos (triobjetivo)
    for comb_idx = 1:length(mode_combinations_3d)
        current_modes = mode_combinations_3d{comb_idx};
        n_obj = length(current_modes);

        % Coletar objetivos para os modos
        objectives = zeros(n_obj, size(filtered_of, 2));
        for j = 1:n_obj
            objectives(j, :) = filtered_of(current_modes(j), :);
        end
        objectives = objectives';

        % Calcular fronteira de Pareto
        pareto_idx = paretoGroup(objectives);

        % Filtrar os índices que são iguais a 1 (pertencem à fronteira de Pareto)
        pareto_idx_1 = find(pareto_idx == 1);

        % Armazenar os pontos absolutos para os índices da fronteira de Pareto
        for i = 1:length(pareto_idx_1)
            idx = pareto_idx_1(i);  % Extrair o índice individual

            zz = filtered_x(:, idx);  % Extrair a posição correspondente
            [~, position] = optimize_patch_centers(zz);  % Calcular a posição absoluta
            
            % Criar uma chave única para cada combinação de modos e quantidade de patches
            key = sprintf('qnt_patches_%d_modes_%d_%d_%d', qnt_patches, current_modes(1), current_modes(2), current_modes(3));
            
            % Armazenar os pontos de porcentagem e de objetivo na estrutura
            if ~isfield(pareto_points_x_perc, key)
                pareto_points_x_perc.(key) = {};  % Inicializa o campo caso não exista
                pareto_points_x_abs.(key) = {};  % Inicializa o campo caso não exista
                pareto_points_of.(key) = {};    % Inicializa o campo caso não exista
            end
            
            % Armazenar os valores em porcentagem e absolutos
            pareto_points_x_perc.(key){end+1} = zz;        % Armazenar os valores percentuais (zz)
            pareto_points_x_abs.(key){end+1} = position;    % Armazenar os valores absolutos (position)
            pareto_points_of.(key){end+1} = -objectives(idx, :);  % Armazenar os valores dos objetivos
        end
    end
end

%% Pontos ótimos da Fronteira de Pareto

pareto_optimal_points_x_abs = struct();

% Loop sobre todas as chaves da struct de fronteiras
keys_of = fieldnames(pareto_points_of);

for k = 1:length(keys_of)
    key = keys_of{k};
    frontier = cell2mat(pareto_points_of.(key)');  % Convert to matrix (N x D)

    % --- 1. Média Harmônica (quanto maior melhor) ---
    harm_mean = harmmean(frontier, 2);  % Harmônica linha a linha
    [~, idx_hm] = max(harm_mean);

    % --- 2. Distância Euclidiana à Média ---
    centroid_mean = mean(frontier, 1);
    distances_mean = sqrt(sum((frontier - centroid_mean).^2, 2));
    [~, idx_ed_mean] = min(distances_mean);

    % --- 3. Distância Euclidiana à Mediana ---
    centroid_median = median(frontier, 1);
    distances_median = sqrt(sum((frontier - centroid_median).^2, 2));
    [~, idx_ed_median] = min(distances_median);

    % --- 4. Método MinMax ---
    max_vals = max(frontier, [], 2);  % Melhor valor em cada ponto
    [~, idx_minmax] = min(max_vals);

    % --- 5. Método MaxMin ---
    min_vals = min(frontier, [], 2);  % Pior valor em cada ponto
    [~, idx_maxmin] = max(min_vals);

    % Armazenar os resultados
    pareto_optimal_points_x_abs.(key).harmonic_mean = pareto_points_x_abs.(key){idx_hm};
    pareto_optimal_points_x_abs.(key).euclidean_mean = pareto_points_x_abs.(key){idx_ed_mean};
    pareto_optimal_points_x_abs.(key).euclidean_median = pareto_points_x_abs.(key){idx_ed_median};
    pareto_optimal_points_x_abs.(key).minmax = pareto_points_x_abs.(key){idx_minmax};
    pareto_optimal_points_x_abs.(key).maxmin = pareto_points_x_abs.(key){idx_maxmin};
end

%% Plots - Fronteiras de Pareto com Pontos Ótimos

for k = 1:length(keys_of)
    key = keys_of{k};
    frontier = cell2mat(pareto_points_of.(key)');
    dims = size(frontier, 2);  % Quantidade de objetivos

    % Extração dos modos e patches a partir da chave (só para o título)
    str_parts = split(key, '_');
    qtd_patches = str2double(str_parts{3});
    modos = str2double(str_parts(5:end));

    % Obter os pontos ótimos
    pt_opt = pareto_optimal_points_x_abs.(key);
    labels = fieldnames(pt_opt);
    markers = {'*', 'x', '+', 's', '^'};
    legend_entries = {'Harmônica', 'Euclidiana - Média', 'Euclidiana - Mediana', 'MinMax', 'MaxMin'};

    % Criar nome para a janela
    if dims == 2
        fig_title = sprintf('Fronteira de Pareto | %d patch(es) | Modos %d e %d', qtd_patches, modos(1), modos(2));
    else
        fig_title = sprintf('Fronteira de Pareto 3D | %d patch(es) | Modos %d, %d e %d', qtd_patches, modos(1), modos(2), modos(3));
    end
    
    % Criar figura com o nome no topo da janela
    figure('Name', fig_title, 'NumberTitle', 'off','Units','normalized','Position',[0.05 0.1 0.9 0.75]);
    hold on;
    
    % Fronteira de Pareto
    if dims == 2
        plot(frontier(:, 1), frontier(:, 2), 'o', 'LineWidth', 1.5);
        xlabel(sprintf('k_{e (%d)}^{2} [%%]', modos(1)), 'FontSize', 12);
        ylabel(sprintf('k_{e (%d)}^{2} [%%]', modos(2)), 'FontSize', 12);
    elseif dims == 3
        plot3(frontier(:, 1), frontier(:, 2), frontier(:, 3), '.', 'Color', [0.6 0.6 0.6], 'MarkerSize', 8);
        xlabel(sprintf('k_{e (%d)}^{2} [%%]', modos(1)), 'FontSize', 12);
        ylabel(sprintf('k_{e (%d)}^{2} [%%]', modos(2)), 'FontSize', 12);
        zlabel(sprintf('k_{e (%d)}^{2} [%%]', modos(3)), 'FontSize', 12);
        % Achata o eixo Z e estica X/Y
        pbaspect([4 2 1]);  % [largura, profundidade, altura]
        
        % Ângulo de visão (azimute, elevação)
        view([-30 20]);  % você pode ajustar esses valores pra um ângulo ideal
    end


    % Plotar os pontos ótimos com marcadores diferentes
    for i = 1:length(labels)
        pt = pt_opt.(labels{i});
        % Buscar o valor do ponto ótimo na lista da fronteira para obter os objetivos
        pt_idx = find(cellfun(@(c) isequal(c, pt), pareto_points_x_abs.(key)));
        if isempty(pt_idx)
            continue
        end
        obj_val = pareto_points_of.(key){pt_idx};

        if dims == 2
            plot(obj_val(1), obj_val(2), markers{i}, 'MarkerSize', 10, 'LineWidth', 1.5);
        elseif dims == 3
            plot3(obj_val(1), obj_val(2), obj_val(3), markers{i}, 'MarkerSize', 10, 'LineWidth', 1.5);
        end
    end

    legend(['Fronteira', legend_entries], 'Location', 'best');
    set(gca, 'FontSize', 16);
    grid on;
    hold off;
end


%% Plot 2D com os pontos ótimos projetados do caso com 3 Modos

for k = 1:length(keys_of)
    key = keys_of{k};

    % Pular se não for de 3 modos
    if count(key, '_') < 6  % Ex: 'qnt_patches_1_modes_6_7_8'
        continue;
    end

    % Extrair patches e modos
    str_parts = split(key, '_');
    qtd_patches = str2double(str_parts{3});
    modos_3d = str2double(str_parts(5:end));

    % Pegar os pontos ótimos 3D
    pt_opt = pareto_optimal_points_x_abs.(key);
    labels = fieldnames(pt_opt);
    markers = {'*', 'x', '+', 's', '^'};
    legend_entries = {'Harmônica', 'Euclidiana - Média', 'Euclidiana - Mediana', 'MinMax', 'MaxMin'};

    % Gerar pares possíveis de modos 2D a partir dos 3D
    comb2_from_3d = nchoosek(modos_3d, 2);

    for c = 1:size(comb2_from_3d, 1)
        modos_2d = comb2_from_3d(c, :);
        key_2d = sprintf('qnt_patches_%d_modes_%d_%d', qtd_patches, modos_2d(1), modos_2d(2));

        % Verificar se a fronteira 2D correspondente existe
        if ~isfield(pareto_points_of, key_2d)
            continue;
        end

        % Pegar fronteira 2D
        frontier_2d = cell2mat(pareto_points_of.(key_2d)');

        % Projetar TODOS os pontos da fronteira 3D nesse plano 2D
        frontier_3d = cell2mat(pareto_points_of.(key)');
        idx_m1 = find(modos_3d == modos_2d(1));
        idx_m2 = find(modos_3d == modos_2d(2));
        frontier_3d_proj = frontier_3d(:, [idx_m1, idx_m2]);

        % Criar figura
        figure('Name', sprintf('Projeção dos ótimos 3D | %d patch(es) | Modos %d e %d', ...
                      qtd_patches, modos_2d(1), modos_2d(2)),...
                'Position', [100, 100, 800, 600]);
        hold on;

        % Plotar a projeção da fronteira 3D (cinza claro)
        plot(frontier_3d_proj(:, 1), frontier_3d_proj(:, 2), '.', 'Color', [0.6 0.6 0.6], 'MarkerSize', 8);

        % Plotar a fronteira de Pareto 2D (em azul mais destacado)
        plot(frontier_2d(:, 1), frontier_2d(:, 2), 'o', 'LineWidth', 1.5);

        % Adicionar os pontos projetados dos ótimos 3D
        for i = 1:length(labels)
            pt = pt_opt.(labels{i});
            pt_idx = find(cellfun(@(c) isequal(c, pt), pareto_points_x_abs.(key)));
            if isempty(pt_idx), continue; end

            obj_val = pareto_points_of.(key){pt_idx};

            % Pegar apenas os valores dos dois modos atuais
            idx_m1 = find(modos_3d == modos_2d(1));
            idx_m2 = find(modos_3d == modos_2d(2));

            % Ponto projetado no plano desses dois modos
            proj_pt = obj_val([idx_m1, idx_m2]);

            plot(proj_pt(1), proj_pt(2), markers{i}, 'MarkerSize', 10, 'LineWidth', 1.5);
        end

        xlabel(sprintf('k_{e (%d)}^{2} [%%]', modos_2d(1)));
        ylabel(sprintf('k_{e (%d)}^{2} [%%]', modos_2d(2)));
        title(sprintf('Projeção: Modos %d × %d',modos_2d(1), modos_2d(2)));
        legend(['Todos os pontos', 'Fronteira 2D', legend_entries], 'Location', 'best');
        set(gca, 'FontSize', 16);
        grid on;
        hold off;
    end
end


%% Figura única com subplots - Fronteira 3D em cima + Projeções 2D abaixo (layout 2x3)

for k = 1:length(keys_of)
    key = keys_of{k};

    if count(key, '_') < 6
        continue;
    end

    str_parts = split(key, '_');
    qtd_patches = str2double(str_parts{3});
    modos_3d = str2double(str_parts(5:end));

    comb2_from_3d = nchoosek(modos_3d, 2);

    frontier_3d = cell2mat(pareto_points_of.(key)');
    pt_opt = pareto_optimal_points_x_abs.(key);
    labels = fieldnames(pt_opt);
    markers = {'*', 'x', '+', 's', '^'};
    legend_entries = {'Harmônica', 'Euclidiana - Média', 'Euclidiana - Mediana', 'MinMax', 'MaxMin'};

    % Criar figura
    figure('Name', sprintf('Fronteira 3D e Projeções 2D - %d patches - Modos %d, %d, %d', qtd_patches, modos_3d), ...
        'Units','normalized','Position',[0.05 0.1 0.9 0.75]);

    % Subplot 1: Fronteira 3D (linha inteira de cima)
    subplot(2, 3, 1:3);
    hold on;
    plot3(frontier_3d(:,1), frontier_3d(:,2), frontier_3d(:,3), '.', 'Color', [0.5 0.5 0.5], 'MarkerSize', 8);

    for i = 1:length(labels)
        pt = pt_opt.(labels{i});
        pt_idx = find(cellfun(@(c) isequal(c, pt), pareto_points_x_abs.(key)));
        if isempty(pt_idx), continue; end

        obj_val = pareto_points_of.(key){pt_idx};
        plot3(obj_val(1), obj_val(2), obj_val(3), markers{i}, 'MarkerSize', 8, 'LineWidth', 1.5);
    end

    xlabel(sprintf('k_{e (%d)}^{2} [%%]', modos_3d(1)));
    ylabel(sprintf('k_{e (%d)}^{2} [%%]', modos_3d(2)));
    zlabel(sprintf('k_{e (%d)}^{2} [%%]', modos_3d(3)));
    grid on;
    view(3);
    hold off;

    legend({'Fronteira de Pareto', legend_entries{:}}, 'Location', 'northeastoutside');

    % Subplots 2-4: Projeções 2D (parte de baixo)
    for c = 1:3
        modos_2d = comb2_from_3d(c, :);
        key_2d = sprintf('qnt_patches_%d_modes_%d_%d', qtd_patches, modos_2d(1), modos_2d(2));
        if ~isfield(pareto_points_of, key_2d)
            continue;
        end

        frontier_2d = cell2mat(pareto_points_of.(key_2d)');
        idx_m1 = find(modos_3d == modos_2d(1));
        idx_m2 = find(modos_3d == modos_2d(2));
        frontier_3d_proj = frontier_3d(:, [idx_m1, idx_m2]);

        subplot(2, 3, 3 + c); % Posições 4, 5 e 6
        hold on;

        plot(frontier_3d_proj(:, 1), frontier_3d_proj(:, 2), '.', 'Color', [0.6 0.6 0.6], 'MarkerSize', 8);
        plot(frontier_2d(:, 1), frontier_2d(:, 2), 'o', 'LineWidth', 1.5);

        for i = 1:length(labels)
            pt = pt_opt.(labels{i});
            pt_idx = find(cellfun(@(c) isequal(c, pt), pareto_points_x_abs.(key)));
            if isempty(pt_idx), continue; end

            obj_val = pareto_points_of.(key){pt_idx};
            proj_pt = obj_val([idx_m1, idx_m2]);

            plot(proj_pt(1), proj_pt(2), markers{i}, 'MarkerSize', 8, 'LineWidth', 1.5);
        end

        xlabel(sprintf('k_{e (%d)}^{2} [%%]', modos_2d(1)));
        ylabel(sprintf('k_{e (%d)}^{2} [%%]', modos_2d(2)));
        title(sprintf('Projeção: Modos %d × %d', modos_2d(1), modos_2d(2)));
        grid on;
        hold off;
    end
end


