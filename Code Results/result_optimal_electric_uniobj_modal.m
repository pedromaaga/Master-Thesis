clear all
clc

%%
load CACHE.mat

qnt_patches = 1;

x = reshape(cell2mat(CACHE.X),qnt_patches*3,length(CACHE.X));
obj_func = reshape(cell2mat(CACHE.OF),1,length(CACHE.OF));

%% Get the best electric value

[amplitude_min, index] = min(obj_func(:,:));
optimal_value = x(:, index);