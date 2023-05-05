% 具体操作    global lamda p;
%            lamda=...;
%            p=...;

close all;
clear;
clc;
standard_deviation=1;
fs=2000;                  %采样频率
N=2000;
n=1:N;
T=1/fs;
SNR=16;                                 %信噪比dB
SNR1=10.^(SNR/10);                                %所需信噪比转换成非dB
t=n/fs;
SIR=0;
SIR=10^(SIR/20);
T=zeros(1000,1);                                                %时频对消统计量序列初始化
    frequency_hop1=[600, 135,500 200 800];
    for i=1:N
        m1=floor((i)/((N+1)/length(frequency_hop1)))+1;
        fh(i)=frequency_hop1(m1);%每个时间点上对应的跳变频率
    end
    frequency_hop_signal=SNR*standard_deviation*cos(2*pi*fh.*n/fs);
    s5=frequency_hop_signal;
    % %噪声
    zs1=randn(1,N);                                         %产生高斯白噪声
    zs1=zs1/std(zs1);                                       %噪声方差归一化
    zs1=zs1-mean(zs1);                                      %噪声均值设为0
    b1=sqrt(1);                                             %噪声幅度修正权值
    zs=b1*zs1;  
    signal_power_tps=1/N*sum(frequency_hop_signal.*frequency_hop_signal);          %原始跳频信号功率
    SNR_P_biaozhun_tps=signal_power_tps/(b1^2);   %原始跳频信号的信噪比
    frequency_hop_signal=sqrt(SNR1/SNR_P_biaozhun_tps)*frequency_hop_signal;   %跳频信号幅度修正
     frequency_fixed1=300;
    dps=sqrt(SNR)*standard_deviation/SIR*cos(2*pi*frequency_fixed1*n/fs);
     s5=dps+frequency_hop_signal;
%      s5=zs;
    sig=s5';     
% %时域波形
figure(1)
plot(t,s5,'LineWidth',2);
xlabel('时间 t');
ylabel('幅值 A');

%  不同的lamda，p值进行对比(其中lamda=1,p=1时为S变换)
%   S变换
global lamda p;
lamda=1.9;
p=0.6;
[tfr,t,f]=st(sig);
% signal_FH = tfr./sqrt(mean(abs(tfr).^2)); %将信号功率归一化，生成单个信号样本
%时频表示
figure;
%  mesh(t,f,abs(signal_FH))
%  subplot(311);
contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
 axis([0 1 0 1000]);
xlabel('时间 t');
ylabel('频率 f');
title("l=1,p=1")
% global lamda p;
% lamda=1.9;
% p=0.6;
% [tfr,t,f]=st(sig);
% %时频表示
% subplot(312);
% contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
%  axis([0 1 0 300]);
% xlabel('时间 t');
% ylabel('频率 f');
% title("l=1.9,p=0.6")
% % 
% global lamda p;
% lamda=0.75;
% p=1;
% [tfr,t,f]=st(sig);
% %时频表示
% subplot(313);
% contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
% axis([0 1 0 300]);
% xlabel('时间 t');
% ylabel('频率 f');
% title("l=0.75,p=1")