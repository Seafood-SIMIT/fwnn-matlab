function g = relation( x, c, q )
%RELATION 函数
%关系函数是高斯函数。

g = exp(- ((x-c) / q)^2);
% 保证不出现0的情况
if g < 1.0e-004
    g = 1.0e-004;
end
