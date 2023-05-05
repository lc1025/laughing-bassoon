% 具体操作    global lamda p;
%            lamda=...;
%            p=...;

close all;
clear;
clc;
% 产生非平稳信号
fs=2000;
N=2000;
n=1:N;
zs1=randn(1,N);                                         %产生高斯白噪声
zs1=zs1/std(zs1);                                       %噪声方差归一化
zs1=zs1-mean(zs1);                                      %噪声均值设为0
b1=sqrt(1);                                             %噪声幅度修正权值
s5=b1*zs1;  
sig=s5';
t=n/fs;
% %时域波形
% figure(1)
% plot(t,s5,'LineWidth',2);
% xlabel('时间 t');
% ylabel('幅值 A');

%  不同的lamda，p值进行对比(其中lamda=1,p=1时为S变换)
%   S变换
global lamda p;
lamda=1;
p=1;
[tfr,t,f]=st(sig);
%时频表示
figure;
% mesh(t/fs,f*fs,abs(tfr).^2)
%  subplot(311);
contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
 axis([0 1 0 1000]);
%  xlabel('时间 t');
% ylabel('频率 f');
%  title("l=1,p=1")
%  global lamda p;
% lamda=0.75;
% p=1;
% [tfr,t,f]=st(sig);
% %时频表示
% subplot(312);
% contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
% % axis([0 1 0 50]);
% xlabel('时间 t');
% ylabel('频率 f');
% title("l=0.75,p=1")
% 
% global lamda p;
% lamda=1;
% p=1.9;
% [tfr,t,f]=st(sig);
% %时频表示
% subplot(313);
% contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
% % axis([0 1 0 50]);
% xlabel('时间 t');
% ylabel('频率 f');
% title("l=1,p=1.9")