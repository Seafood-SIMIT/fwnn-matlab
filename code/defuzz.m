function u = defuzz( U, y, n )
%DEFUZZ 函数

t1 = 0;
t2 = 0;
for i = 1 : 1 : n
    t1 = t1 + U(i) * y(i);
    t2 = t2 + U(i);
end
u = t1 / t2; % t2不能为零
