function idx = paretoGroup(data)
    n = size(data, 1);
    idx = true(n, 1);
    for i = 1:n
        for j = 1:n
            if all(data(j,:) <= data(i,:)) && any(data(j,:) < data(i,:))
                idx(i) = false;
                break;
            end
        end
    end
end

