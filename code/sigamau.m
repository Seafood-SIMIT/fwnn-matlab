%向量元素相加
function sigamau = sigamau( U, n )
%SIGAMAU 函数

sigamau = 0;
for i = 1 : 1 : n
    sigamau = sigamau + U(i);
end
