function y = fround(xx,DiscreteData)
xx
for i=1:size(xx,1)
    y(i,1)=DiscreteData{i,1}(xx(i));
end
end