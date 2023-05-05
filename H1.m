%复杂电磁环境下 修改信干比 我的方法可用2021
% function [tps1] = H1
clear all
clear
n=0:199;                         %观测时间
N=length(n);                        %时间长度
SNR=[20];                            %信噪比，通过改变该值来画检测概率曲线
SDR=-1.5;                              %跳频和其他所有干扰信号的功率比，-0.4=5 -3.4=2 -5.4=0
fs=2000;                        %采样频率10MHz
fangcha=2;                          %噪声方差
SNR1=10.^(SNR/10);                  %所需信噪比转换成非dB
SDR1=10^(SDR/10);                   %所需信干比转换成非dB
t=n/fs;

[dps,tps,tfs,sps]=tds2_4;                  %产生定频信号、突发信号和跳频信号
dps2=dps;
signal_power_tps=1/N*sum(tps.*tps);                 %原始跳频信号功率计算
signal_power_dps=1/N*sum(dps.*dps);                 %原始定频信号功率计算
signal_power_tfs=1/N*sum(tfs.*tfs);                 %原始定频信号功率计算
signal_power_sps=1/N*sum(sps.*sps);                 %原始定频信号功率计算
SDR_P_biaozhun=signal_power_tps/(signal_power_dps+signal_power_tfs+signal_power_sps);   %初始信干比
dps=sqrt(SDR_P_biaozhun/SDR1)*dps;                  %定频信号幅度修正
tfs=sqrt(SDR_P_biaozhun/SDR1)*tfs;                  %突发信号幅度修正
sps=sqrt(SDR_P_biaozhun/SDR1)*sps;                  %扫频信号幅度修正
signal_power_tps2=1/N*sum(tps.*tps);                 %原始跳频信号功率计算
signal_power_dps2=1/N*sum(dps.*dps);                 %原始定频信号功率计算
signal_power_tfs2=1/N*sum(tfs.*tfs);                 %原始定频信号功率计算
signal_power_sps2=1/N*sum(sps.*sps);                 %原始定频信号功率计算
SIR=10*log10(signal_power_tps2/(signal_power_tfs2+signal_power_sps2)); %信干比（跳频/（突发+扫频））  

zs=randn(1,N);                   %生成白噪声
zs=zs/std(zs);                   %噪声方差归一化
zs=zs-mean(zs);                  %噪声均值设为0
b=sqrt(fangcha);                 %修正后的噪声
zs=b*zs;                         %修正后的噪声

%根据信干比和信噪比计算噪声幅度修正值
N1=signal_power_tps/SNR1;       %（高斯白噪声+定频信号+突发信号+扫频）的功率
% if 4*sum(zs.*(dps+tfs+sps))^2/(N^2)-4*(1/N*sum((dps+tfs+sps).*(dps+tfs+sps))-N1)*b^2>=0   %判断是否存在有效的白噪声幅度修正值
m=((-2)*sum(zs.*(dps+tfs+sps))/N+sqrt(4*sum(zs.*(dps+tfs+sps))^2/(N^2)-4*(1/N*sum((dps+tfs+sps).*(dps+tfs+sps))-N1)*b^2))/(2*b^2);  %一元二次方程解得高斯白噪声幅度修正值
zs=m*zs;                     %修正后的噪声
signal_power_zs=1/N*sum(zs.*zs);
zs=dps+tfs+sps;                   %高斯白噪声+定频信号+突发信号
tps1=tps+zs;                  %背景噪声叠加到信号上
s5=tps1;
sig=s5'; 
     % %时域波形
figure(1) 
plot(t,s5,'LineWidth',2); 
xlabel('时间 t'); ylabel('幅值 A');

%  不同的lamda，p值进行对比(其中lamda=1,p=1时为S变换) %   S变换 
 global lamda p; 
 lamda=1;
 p=1; 
[tfr,t,f]=st(sig); %时频表示 figure;
mesh(t,f,abs(tfr).^2) 
% subplot(311);
contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none'); 
% axis([0 1 0 300]);
xlabel('时间 t'); ylabel('频率 f'); 
title("l=1.9,p=0.6")
        
%           
          