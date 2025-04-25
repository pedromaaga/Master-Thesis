function plot_patches_with_domain(centers, LPA, WPA)
    % centers: vetor com as coordenadas dos centros dos patches (x1, y1, x2, y2, ...)
    % LPA: largura dos patches
    % WPA: altura dos patches
    %
    %% Problem variables
    % Plate
    LPL         = 0.414;                    % [m]
    WPL         = 0.314;                    % [m]

    %% Domínio dos patches
    
    x1_limits = [-LPL/2, LPL/2];
    x2_limits = [-WPL/2, WPL/2];
    
    % Número de patches
    num_patches = length(centers) / 2;
    
    % Reorganizar coordenadas em uma matriz (cada linha é [x, y] de um patch)
    centers = reshape(centers, 2, num_patches)';
    
    % Criar figura
    figure;
    hold on;
    axis equal;
    grid on;
    xlabel('X');
    ylabel('Y');
    title('Representação dos Patches com Domínio');
    
    % Desenhar o domínio
    rectangle('Position', [x1_limits(1), x2_limits(1), diff(x1_limits), diff(x2_limits)], ...
              'EdgeColor', 'k', 'LineWidth', 2, 'LineStyle', '--');
    
    % Definir cores para os patches
    colors = lines(num_patches); % Paleta de cores
    
    % Desenhar cada patch
    for i = 1:num_patches
        % Coordenadas do centro
        cx = centers(i, 1);
        cy = centers(i, 2);
        
        % Cálculo dos limites do retângulo (patch)
        x_min = cx - LPA / 2;
        x_max = cx + LPA / 2;
        y_min = cy - WPA / 2;
        y_max = cy + WPA / 2;
        
        % Desenhar retângulo
        rectangle('Position', [x_min, y_min, LPA, WPA], ...
                  'EdgeColor', colors(i, :), ...
                  'FaceColor', colors(i, :) * 0.5, ...
                  'LineWidth', 1.5);
        
        % Adicionar rótulo do patch no centro
        text(cx, cy, sprintf('P%d', i), ...
             'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'middle', ...
             'Color', 'white', ...
             'FontWeight', 'bold');
    end
    
    % Ajustar os limites do gráfico
    xlim([x1_limits(1) - LPA, x1_limits(2) + LPA]);
    ylim([x2_limits(1) - WPA, x2_limits(2) + WPA]);
    
    hold off;
end
