% �������    global lamda p;
%            lamda=...;
%            p=...;

close all;
clear;
clc;
% ������ƽ���ź�
fs=2000;
N=2000;
n=1:N;
zs1=randn(1,N);                                         %������˹������
zs1=zs1/std(zs1);                                       %���������һ��
zs1=zs1-mean(zs1);                                      %������ֵ��Ϊ0
b1=sqrt(1);                                             %������������Ȩֵ
s5=b1*zs1;  
sig=s5';
t=n/fs;
% %ʱ����
% figure(1)
% plot(t,s5,'LineWidth',2);
% xlabel('ʱ�� t');
% ylabel('��ֵ A');

%  ��ͬ��lamda��pֵ���жԱ�(����lamda=1,p=1ʱΪS�任)
%   S�任
global lamda p;
lamda=1;
p=1;
[tfr,t,f]=st(sig);
%ʱƵ��ʾ
figure;
% mesh(t/fs,f*fs,abs(tfr).^2)
%  subplot(311);
contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
 axis([0 1 0 1000]);
%  xlabel('ʱ�� t');
% ylabel('Ƶ�� f');
%  title("l=1,p=1")
%  global lamda p;
% lamda=0.75;
% p=1;
% [tfr,t,f]=st(sig);
% %ʱƵ��ʾ
% subplot(312);
% contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
% % axis([0 1 0 50]);
% xlabel('ʱ�� t');
% ylabel('Ƶ�� f');
% title("l=0.75,p=1")
% 
% global lamda p;
% lamda=1;
% p=1.9;
% [tfr,t,f]=st(sig);
% %ʱƵ��ʾ
% subplot(313);
% contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
% % axis([0 1 0 50]);
% xlabel('ʱ�� t');
% ylabel('Ƶ�� f');
% title("l=1,p=1.9")