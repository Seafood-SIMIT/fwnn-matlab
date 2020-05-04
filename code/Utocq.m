function [ Utoc, Utoq ] = Utocq( g, x, c, q, m, n, p )
%UTOCQ º¯Êý

Utoc = zeros(m, n);
Utoq = zeros(m, n);
for i = 1 : 1 : m
    for j = 1 : 1 : n
        if p(j) == i
            Utoc(i, j) = g(i, j) * 2 * (x(i) - c(i, j)) / (q(i, j)^2);
            Utoq(i, j) = Utoc(i, j) * (x(i) - c(i, j)) / q(i, j);
        end
    end
end
