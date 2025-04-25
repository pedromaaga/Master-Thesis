function [zz_adjusted, zz_valid] = clean_and_sort_centers(zz)
% CLEAN_AND_SORT_CENTERS - Limpa centros inválidos e os move para o final.
% Entradas:
%    zz - Vetor com as coordenadas dos centros (formato [x1, y1, x2, y2, ...]).
%
% Saídas:
%    zz_adjusted - Vetor ajustado com centros inválidos movidos para o final.
%    zz_valid    - Vetor com apenas os centros válidos (excluindo os [-1, -1]).

    % Número total de pares (centros)
    num_centers = length(zz) / 2;
    
    % Reorganizar o vetor zz em uma matriz de centros (cada linha é [x, y])
    centers = reshape(zz, 2, num_centers)'; 
    
    % Identificar linhas onde qualquer coordenada é -1
    invalid_rows = any(centers == -1, 2);
    
    % Ajustar os centros inválidos (substituir por [-1, -1])
    centers(invalid_rows, :) = -1;
    
    % Separar centros válidos e inválidos
    valid_centers = centers(~invalid_rows, :);
    invalid_centers = centers(invalid_rows, :);

    % Ordenar os centros válidos: primeiro por x (decrescente), depois por y (decrescente)
    valid_centers = sortrows(valid_centers, [-1, -2]);
    
    % Concatenar válidos seguidos pelos inválidos
    sorted_centers = [valid_centers; invalid_centers];
    
    % Voltar ao formato original (vetor)
    zz_adjusted = reshape(sorted_centers', [], 1);
    zz_valid = reshape(valid_centers', [], 1); % Apenas os centros válidos
end
