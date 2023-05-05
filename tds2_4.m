function [dps,tps,tfs,sps]=tds2_4
fs=2000;
fdp1=75;                               %定频信号频率单位为Hz
N=200;
n=0:199;                              %信号观测时间
b=length(n);                            %信号长度
for i=1:b                               %构造跳频周期为0.5ms、1ms、0.25ms的跳频信号
                 
   if i>=10&&i<=11                %突发信号
         ftf(i)=960;
         atf(i)=1; 
    elseif i>=90&&i<=91
         ftf(i)=480;
         atf(i)=1; 
    elseif i>=170&&i<=171
        ftf(i)=670;
        atf(i)=1; 
    else
        ftf(i)=0;  
        atf(i)=0;
    end
     %扫频信号
     if i>=10&&i<=13                
        t=i-10;
        fsp(i)=0.1*t+100;
        sps(i)=sqrt(10)*cos(2*pi*fsp(i)*t/fs);
    elseif i>=50&&i<=53         
        t=i-50;
        fsp(i)=0.1*t+100;
        sps(i)=sqrt(10)*cos(2*pi*fsp(i)*t/fs);
    elseif i>=90&&i<=93
        t=i-90;
        fsp(i)=0.1*t+100;
        sps(i)=sqrt(10)*cos(2*pi*fsp(i)*t/fs);
     elseif i>=130&&i<=133 
        t=i-130;
        fsp(i)=0.1*t+100;
        sps(i)=sqrt(10)*cos(2*pi*fsp(i)*t/fs);
     else
        sps(i)=0;
    end
end
frequency_hop1=[700, 135, 500, 800,100];
for i=1:N
    m1=floor((i)/((N+1)/length(frequency_hop1)))+1;
    fh(i)=frequency_hop1(m1);%每个时间点上对应的跳变频率
end
frequency_hop_signal=10.*cos(2*pi*fh.*n/fs);
tps=frequency_hop_signal;
dps1=sqrt(7)*cos(2*pi*fdp1*n/fs);     %第一个定频信号，采样频率为2.56MHz

tfs=sqrt(10)*atf.*cos(2*pi*ftf.*n/fs);  %突发信号
dps=dps1;  
