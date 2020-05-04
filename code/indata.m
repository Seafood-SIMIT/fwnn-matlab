function u = indata( )
%INPUT 函数

file_yangben = '样本集.dat';
fid = fopen(file_yangben);
%u = fread(fid,[size_input_x,size_input_y],'float');
u = dlmread(file_yangben,',');
fclose(fid);

