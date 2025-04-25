function transformed_values = transform_intervals(zz, interval1, interval2)
% TRANSFORM_INTERVALS - Transforma valores no intervalo [0,1] para novos intervalos.
%
% Entradas:
%    zz       - Vetor com valores no intervalo [0,1].
%    interval1 - Vetor [min, max] para índices ímpares.
%    interval2 - Vetor [min, max] para índices pares.
%
% Saída:
%    transformed_values - Vetor com valores transformados para os novos intervalos.

    % Inicializar vetor de saída
    transformed_values = zeros(size(zz));
    
    % Iterar sobre os elementos do vetor zz
    for i = 1:length(zz)
        if mod(i, 2) == 1 % Índice ímpar → usar intervalo1
            transformed_values(i) = zz(i) * (interval1(2) - interval1(1)) + interval1(1);
        else % Índice par → usar intervalo2
            transformed_values(i) = zz(i) * (interval2(2) - interval2(1)) + interval2(1);
        end
    end
end
