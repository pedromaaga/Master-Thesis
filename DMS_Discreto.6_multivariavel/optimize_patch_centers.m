function [zz_adjusted, centers] = optimize_patch_centers(zz)
% OPTIMIZE_PATCH_CENTERS - Ajusta os centros dos patches validando sobreposição.
%
% Entradas:
%    zz - Vetor com as coordenadas iniciais dos centros.
%
% Saídas:
%    zz_adjusted - Vetor ajustado com centros inválidos atualizados.
%    centers     - Centros válidos transformados.

    active = 1; % Variável de controle do loop
    while active
        % Limpar e ajustar centros
        [zz_adjusted, zz_valid] = clean_and_sort_centers(zz);
        N           = length(zz_valid) / 2;     % Number of pairs of patches
       
        %% Problem variables
        % Plate
        LPL         = 0.414;                    % [m]
        WPL         = 0.314;                    % [m]
        
        % Patch material total
        LPA_total   = LPL/5;                    % [m]
        WPA_total   = WPL/5;                    % [m]
        A_total     = LPA_total*WPA_total;
        
        alpha       = LPA_total/WPA_total;      % Proportion between L and W of the patch
        
        % Patch dimension
        WPA         = sqrt(A_total/(alpha*N));  % [m]
        LPA         = alpha*WPA;                % [m]
        
        WPA         = round(WPA,4);
        LPA         = round(LPA,4);
        
        % Mesh size
        L_mesh      = 3.175e-3;                 % [m]

        %% Intervalos dos domínios
        interval1 = [-LPL/2 + LPA/2 + L_mesh, LPL/2 - LPA/2 - L_mesh]';
        interval2 = [-WPL/2 + WPA/2 + L_mesh, WPL/2 - WPA/2 - L_mesh]';

        % Transformar valores válidos para os intervalos
        transformed_values = transform_intervals(zz_valid, interval1, interval2);
        centers = transformed_values; % Centros transformados

        % Validar sobreposição
        [overlap, pair] = check_overlap(centers, LPA, WPA, L_mesh);

        % Plotar patches no domínio
        %close all;
        %plot_patches_with_domain(centers, (LPA+L_mesh), (WPA+L_mesh));

        if overlap
            % Atualizar centros inválidos
            zz_adjusted(pair(1) * 2) = -1;
            zz = zz_adjusted;
        else
            % Convergência alcançada
            active = 0;
        end
    end
end
