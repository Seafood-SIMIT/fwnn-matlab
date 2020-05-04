%FFBPNET 脚本文件，作为主程序使用

close all
clear

d = 5;
num = 1000;
data = indata(num);
result = plant(data);

% 生成输入矩阵
input = zeros(2 * d + 1, num);
for i = 1 : 1 : d + 1
    for j = 1 : 1 : num - d - 1 + i
        input(i, j + d + 1 - i) = data(j);
    end
end
for i = 1 : 1 : d
    for j = 1 : 1 : num - d - 1 + i
        input(d + 1 + i, j + d + 1 - i) = result(j);
    end
end 

net = newff(minmax(input), [6, 3, 1]);
y1 = sim(net, input);
net.trainParam.show = 10;
net.trainParam.epochs = 200;
net.trainParam.goal = 1.0e-6;
net = train(net, input, result);
y2 = sim(net, input);
k = 1 : 1 : num;
plot(k, result, 'g', k, y2, 'b')
