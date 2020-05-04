function y = plant( u )
%PLANT 函数
n = length(u);
y = zeros(1, n);
% n不能太小
if n > 3
%    y(1) = 0; % = 0
%    y(2) = 0.72*y(1); % = 0
%    y(3) = 0.72*y(2) + 0.025*y(1)*u(2); % = 0
    for i = 4 : 1 : n
        y(i) = 0.72*y(i-1) + 0.025*y(i-2)*u(i-1) + 0.01*u(i-2)*u(i-2) + 0.2*u(i-3);
    end
end
