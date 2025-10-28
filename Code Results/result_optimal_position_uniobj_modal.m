clear all
clc

%%
load CACHE.mat

x = reshape(cell2mat(CACHE.X),18,length(CACHE.X));
obj_func = reshape(cell2mat(CACHE.OF),11,length(CACHE.OF));

%% Get the best position and EMCC for each quantity of patches in each mode
qnt_patches = -min(obj_func(11,:));
qnt_modes   = 10;

EMCC_results.x_perc = cell(qnt_modes,qnt_patches);
EMCC_results.x_abs = cell(qnt_modes,qnt_patches);
EMCC_results.OF = cell(qnt_modes,qnt_patches);

for i = 1:qnt_patches
    % Filter obj_func and x for the current patch quantity
    patch_filter = (obj_func(11, :) == -i);
    filtered_of = obj_func(:, patch_filter);
    filtered_x = x(:, patch_filter);

    for j = 1:qnt_modes
        % Get the index of the "best" EMCC for the current mode and patch quantity
        [EMCC, index] = min(filtered_of(j, :));
        zz = filtered_x(:, index); % Extract corresponding position
        [~,position] = optimize_patch_centers(zz);

        % Store results in EMCC_results
        EMCC_results.x_perc{j, i} = zz;
        EMCC_results.x_abs{j, i} = position;
        EMCC_results.OF{j, i} = EMCC;
    end
end

figure;
hold on;

for i = 1:qnt_patches
    emcc_values = -cell2mat(EMCC_results.OF(:, i));
    
    % Plot y-values for the current patch quantity
    if i==1
        plot((1:qnt_modes)', emcc_values, '-o', 'LineWidth', 1, 'DisplayName', sprintf('%d Par de patches', i));
    else
        plot((1:qnt_modes)', emcc_values, '-o', 'LineWidth', 1, 'DisplayName', sprintf('%d Pares de patches', i));
    end
end

% Add labels and legend
xlabel('Modo de Vibração');
ylabel('k_{e (m)}^{2} [%]');
legend show;
grid on;
hold off;