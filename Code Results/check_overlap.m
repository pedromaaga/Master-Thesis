function [overlap, pair] = check_overlap(centers, LPA, WPA, L_mesh)
    % centers: vetor com as coordenadas dos centros dos patches (x1, y1, x2, y2, ...)
    % LPA: largura dos patches
    % WPA: altura dos patches
    
    % Número de patches
    num_patches = length(centers) / 2;
    
    % Reorganizar coordenadas em uma matriz (cada linha é [x, y] de um patch)
    centers = reshape(centers, 2, num_patches)';
    
    % Inicializar valores de saída
    overlap = false; % Indica se há sobreposição
    pair = [];       % Pares de patches sobrepostos
    
    % Verificar todos os pares de patches
    for i = 1:num_patches
        for j = i+1:num_patches
            % Distância entre os centros
            dx = abs(centers(i, 1) - centers(j, 1));
            dy = abs(centers(i, 2) - centers(j, 2));
            
            % Verificar sobreposição
            if dx < (LPA+L_mesh) && dy < (WPA+L_mesh)
                overlap = true;
                pair = [i, j]; % Armazena os índices dos patches sobrepostos
                %fprintf('Sobreposição detectada entre os patches %d e %d\n', i, j);
                return; % Parar ao encontrar sobreposição
            end
        end
    end
end
