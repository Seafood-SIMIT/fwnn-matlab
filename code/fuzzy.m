%求最小值
function [ min, which ] = fuzzy( g, m, n )
%FUZZY 函数

min = g(1, n);
which = 1;
for i = 2 : 1 : m
    if min > g(i, n)
        min = g(i, n);
        which = i;
    end
end
