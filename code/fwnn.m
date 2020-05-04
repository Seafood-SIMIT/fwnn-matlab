%FWNN 脚本文件，作为主程序使用
% 清理工作
close all
clear
% 关键变量
d = 5; % 用于输入的宽度
m = d; % 输入信号的个数
n = 5; % 关系函数的个数，模糊判断的个数，小波函数的个数
epoch = 2000; % 迭代次数
num_yangben = 49; % 数据个数
num_test = 12;
rate = 0.08; % 学习速率
mom = 0.5; % 冲量 

% 产生试验数据
data = indata();
%result = plant(data);
result = data(:,d+1);
% TEST
file_yangben = '测试集.dat';
fid = fopen(file_yangben);
%u = fread(fid,[size_input_x,size_input_y],'float');
u_test = dlmread(file_yangben,',');
fclose(fid);

% 随机初始化各个参数于（0，1）
c = rand(m, n);
q = rand(m, n); % 注意：不能为零
a = rand(n, m);
b = rand(n, m);
w = rand(1, n);

% t-1迭代的参数值
pc = c;
pq = q;
pa = a;
pb = b;
pw = w;

% t+1迭代的参数值
nc = zeros(m, n);
nq = zeros(m, n);
na = zeros(n, m);
nb = zeros(n, m);
nw = zeros(1, n);

% 用于画图的数据
tu = zeros(epoch, num_yangben);
E = zeros(epoch, num_yangben);

% 训练过程
tic % 开始计时
for loop1 = 1 : 1 : epoch
    for loop2 = 1 : 1 : num_yangben
        % 初始化中间数据
        x = zeros(1, m);
        g = zeros(m, n);
        U = zeros(1, n);
        p = zeros(1, n);
        W = zeros(1, n);
        %y = zeros(1, n);
        % 给输入节点赋值
        for i = 1 : 1 : d
            x(i) = data(loop2,i);
        end
        %for i = 1 : 1 : d
           % x(m + 1 - i) = result(loop2 - i);
        %end
        % 计算第二层节点的输出值
        for i = 1 : 1 : m
            for j = 1 : 1 : n
                g(i, j) = relation(x(i), c(i, j), q(i, j));
            end
        end
        % 计算第三层节点的输出，同时记录第三层节点的选择信息
        for i = 1 : 1 : n
            [min, which] = fuzzy(g, m, i);
            U(i) = min;
            p(i) = which;
        end
        % 计算第四层节点的输出
        for i = 1 : 1 : n
            for j = 1 : 1 : m
                W(i) = W(i) + wavelet(x(j), a(i, j), b(i, j));
            end
        end
        y = w .* W;
        % 计算最终的输出
        u = defuzz(U, y, n);
        tu(loop1, loop2) = u;
        % 计算误差
        temp1 = u - result(loop2);
        E(loop1, loop2) = temp1^2 / 2;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        % 下面使用梯度下降算法修正参数
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % 计算E对w的偏导数
        temp2 = sigamau(U, n);
        Etow = zeros(1, n);
        sima = zeros(1, n);
        for i = 1 : 1 : n
            Etow(i) = temp1 * U(i) * W(i) / temp2;
            sima(i) = temp1 * U(i) * w(i) / temp2;
        end
        % 计算几个下面会重复使用的数据
        temp3 = zeros(n, m);
        temp4 = zeros(n, m);
        for i = 1 : 1 : n
            for j = 1 : 1 : m
                temp3(i, j) = varz2(x(j), a(i, j), b(i, j)); % temp3= z^2
                temp4(i, j) = exp(-temp3(i, j)/2) / sqrt(abs(a(i, j))^3); % temp4 = ?
            end
        end
        % 计算E对a的偏导数
        Etoa = zeros(n, m);
        for i = 1 : 1 : n
            for j = 1 : 1 : m
                temp5 = temp3(i, j); % temp5 = z^2
                Etoa(i, j) = sima(i) * (3.5 * temp5 - temp5^2 - 0.5) * temp4(i , j);
            end
        end
        % 计算E对b的偏导数
        Etob = zeros(n, m);
        for i = 1 : 1 : n
            for j = 1 : 1 : m
                temp5 = temp3(i, j); % temp5 = z^2
                Etob(i, j) = sima(i) * (3 * temp5 - temp5^3) * temp4(i , j);
            end
        end
        % 计算E对c、q的偏导数
        utoU = zeros(1, n);
        for i = 1 : 1 : n
            utoU(i) = (y(i) - u) / temp2; % temp2 = sigama(U)
        end
        [Utoc, Utoq] = Utocq(g, x, c, q, m, n, p);
        Etoc = zeros(m, n);
        Etoq = zeros(m, n);
        for i = 1 : 1 : m
            for j = 1 : 1 : n
                temp6 = temp1 * utoU(j);
                Etoc(i, j) = temp6 * Utoc(i, j);
                Etoq(i, j) = temp6 * Utoq(i, j);
            end
        end
        % 对参数修正
        nw = w - rate * Etow + mom * (w - pw);
        na = a - rate * Etoa + mom * (a - pa);
        nb = b - rate * Etob + mom * (b - pb);
        nc = c - rate * Etoc;
        nq = q - rate * Etoq;
        % 修改参数t-1，t
        pw = w; w = nw;
        pa = a; a = na;
        pb = b; b = nb;
        c = nc;
        q = nq;
    end
end
toc % 结束计时，并显示时间
figure(1)
% 图形显示统计信息
k = 1 : 1 : num_yangben;
ttu = tu(epoch, :);
plot(k, result, '-', k, ttu, '-r')
legend('样本集结果', '样本集预测值')
title('训练结果');
xlabel('样本');
ylabel('优先级');
%%============================================================'
%%测试
%%===========================================================
for loop2 = 1 : 1 : num_test
        % 初始化中间数据
        x = zeros(1, m);
        g = zeros(m, n);
        U = zeros(1, n);
        p = zeros(1, n);
        W = zeros(1, n);
        %y = zeros(1, n);
        % 给输入节点赋值
        for i = 1 : 1 : d
            x(i) = u_test(loop2,i);
        end
        %for i = 1 : 1 : d
           % x(m + 1 - i) = result(loop2 - i);
        %end
        % 计算第二层节点的输出值
        for i = 1 : 1 : m
            for j = 1 : 1 : n
                g(i, j) = relation(x(i), c(i, j), q(i, j));
            end
        end
        % 计算第三层节点的输出，同时记录第三层节点的选择信息
        for i = 1 : 1 : n
            [min, which] = fuzzy(g, m, i);
            U(i) = min;
            p(i) = which;
        end
        % 计算第四层节点的输出
        for i = 1 : 1 : n
            for j = 1 : 1 : m
                W(i) = W(i) + wavelet(x(j), a(i, j), b(i, j));
            end
        end
        y = w .* W;
        % 计算最终的输出
        result_test(loop2) = defuzz(U, y, n);
end
figure(2)
% 图形显示测试信息
k = 1 : 1 : num_test;
plot(k, u_test(:,6), 'g',k, result_test, 'r')
legend('测试集结果', '测试集预测值')
title('测试结果');
xlabel('样本');
ylabel('优先级');
