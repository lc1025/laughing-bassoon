% 在S变换的基础上，对 gauss=g_window(length,freq,factor) 进行了修改；
% 读者可根据需要对其进行其他方式的修改



function [st,t,f] = st(timeseries,minfreq,maxfreq,samplingrate,freqsamplingrate)
% Returns the Stockwell Transform of the timeseries.
% Code by Robert Glenn Stockwell.
% DO NOT DISTRIBUTE
% BETA TEST ONLY
% Reference is "Localization of the Complex Spectrum: The S Transform"
% from IEEE Transactions on Signal Processing, vol. 44., number 4, April 1996, pages 998-1001.
%
%-------Inputs Needed------------------------------------------------
%  
%   *****All frequencies in (cycles/(time unit))!******
%	"timeseries" - vector of data to be transformed
%-------Optional Inputs ------------------------------------------------
%
%"minfreq" is the minimum frequency in the ST result(Default=0)（最小频率）
%"maxfreq" is the maximum frequency in the ST result (Default=Nyquist)（最大频率）
%"samplingrate" is the time interval between samples (Default=1)（采样时间间隔）
%"freqsamplingrate" is the frequency-sampling interval you desire in the ST
%                      result (Default=1)（采样频率间隔）
%Passing a negative number will give the default ex.  [s,t,f] = st(data,-1,-1,2,2)
%-------Outputs Returned------------------------------------------------
%
% st     -a complex matrix containing the Stockwell transform. 
%			 The rows of STOutput are the frequencies and the 
%         columns are the time values ie each column is 
%         the "local spectrum" for that point in time
%  t      - a vector containing the sampled times
%  f      - a vector containing the sampled frequencies
%--------Additional details-----------------------
%   %  There are several parameters immediately below that
%  the user may change. They are:
%[verbose]    if true prints out informational messages throughout the function.
%[removeedge] if true, 删除最小二乘拟合抛物线，并在时间序列的边缘放置5％的汉宁锥度。
%                This is usually a good idea.
%[analytic_signal]  if the timeseries is real-valued
%                      则它将获取分析信号并对其进行ST处理。
%[factor]     局部化高斯的宽度因子，即周期为10秒的正弦波，有一个宽度因子*10秒的高斯窗口。
%                I usually use factor=1, but sometimes factor = 3
%                to get better frequency resolution.
%   Copyright (c) by Bob Stockwell
%   $Revision: 1.2 $  $Date: 1997/07/08  $


% This is the S transform wrapper that holds default values for the function.
TRUE = 1; 
FALSE = 0;
%%% DEFAULT PARAMETERS  [change these for your particular application]
verbose = FALSE;          
removeedge= FALSE;
analytic_signal =  FALSE;
factor =1;
%%% END of DEFAULT PARAMETERS


%%%START OF INPUT VARIABLE CHECK
% First:  make sure it is a valid time_series 
%         If not, return the help message

if verbose 
    disp(' '),end  % i like a line left blank

if nargin == 0 
   if verbose 
       disp('没有参数输入'),end
   st_help
   t=0;st=-1;f=0;
   return
end

% 更改为列向量    (将信号转换为  n*2  的矩阵)
if size(timeseries,2) > size(timeseries,1)      %矩阵的列数大于行数
	timeseries=timeseries';	
end

% Make sure it is a 1-dimensional array
if size(timeseries,2) > 1
   error('请输入数据的“向量”，而不是矩阵')
      return 
elseif (size(timeseries)==eye(1))==1
	error('请输入数据的“向量”，而不是标量')
      return 
end

% 对输入变量使用默认值

if nargin == 1
   minfreq = 0;
   maxfreq = fix(length(timeseries)/2);   %fix:向0靠拢取整
   samplingrate=1;
   freqsamplingrate=1;
elseif nargin==2
   maxfreq = fix(length(timeseries)/2);
   samplingrate=1;
   freqsamplingrate=1;
   [ minfreq,maxfreq,samplingrate,freqsamplingrate] =  check_input(minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,timeseries);
elseif nargin==3 
   samplingrate=1;
   freqsamplingrate=1;
   [ minfreq,maxfreq,samplingrate,freqsamplingrate] =  check_input(minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,timeseries);
elseif nargin==4   
   freqsamplingrate=1;
   [ minfreq,maxfreq,samplingrate,freqsamplingrate] =  check_input(minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,timeseries);
elseif nargin == 5
      [ minfreq,maxfreq,samplingrate,freqsamplingrate] =  check_input(minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,timeseries);
else      
   if verbose 
       disp('输入参数错误：使用默认值'),end
   minfreq = 0;
   maxfreq = fix(length(timeseries)/2);
   samplingrate=1;
   freqsamplingrate=1;
end
if verbose 
   disp(fprintf('Minfreq = %d\n',minfreq))
   disp(fprintf('Maxfreq = %d\n',maxfreq))
   disp(fprintf('采样率（时  域）=  %d\n',samplingrate))
   disp(fprintf('采样率（频率域）=  %d\n',freqsamplingrate))
   disp(fprintf('时间序列的长度是： %d points\n',length(timeseries)))

   disp(' ')
end
%END OF INPUT VARIABLE CHECK

% If you want to "hardwire" minfreq & maxfreq & samplingrate & freqsamplingrate do it here

% calculate the sampled time and frequency values from the two sampling rates
t = (0:length(timeseries)-1)*samplingrate;
spe_nelements =ceil((maxfreq - minfreq+1)/freqsamplingrate);       % ceil:朝着正无穷方向取整
f = (minfreq + (0:spe_nelements-1)*freqsamplingrate)/(samplingrate*length(timeseries));
if verbose 
    fprintf('The number of frequency voices is %d\n',spe_nelements),end


% The actual S Transform function is here:
st = strans(timeseries,minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,removeedge,analytic_signal,factor); 
% this function is below, thus nicely encapsulated

%WRITE switch statement on nargout
% 如果为0，则绘制幅度谱
if nargout==0 
   if verbose 
       disp('绘制伪彩色图像'),end
   pcolor(t,f,abs(st))
end
return


%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


function st = strans(timeseries,minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,removeedge,analytic_signal,factor)   
% Returns the Stockwell Transform, ST Output, of the time-series
% Code by R.G. Stockwell.
% Reference is "Localization of the Complex Spectrum: The S Transform"
% from IEEE Transactions on Signal Processing, vol. 44., number 4,
% April 1996, pages 998-1001.
%
%-------Inputs Returned------------------------------------------------
%         - are all taken care of in the wrapper function above
%
%-------Outputs Returned------------------------------------------------
%
%	ST    -a complex matrix containing the Stockwell transform.
%			
%           ST输出的行是频率，列是时间值

%
%
%-----------------------------------------------------------------------

% Compute the length of the data.
n=length(timeseries);
original = timeseries;
if removeedge
    if verbose 
        disp('用多项式拟合消除趋势'),end
 	 ind = [0:n-1]';
    r = polyfit(ind,timeseries,2);          %%%^^^^^^^^polyfit：线性拟合函数
    fit = polyval(r,ind) ;                  %%%^^^^^^^^polyval：计算多项式
	 timeseries = timeseries - fit;
    if verbose 
        disp('用5％汉宁锥度去除边缘'),end
    sh_len = floor(length(timeseries)/10);  %%%^^^^^^^^floor：向负无穷大方向取整
    wn = hanning(sh_len);
    if(sh_len==0)
       sh_len=length(timeseries);
       wn = 1&[1:sh_len];
    end
    % 确保wn是列向量，因为时间序列也是列
   if size(wn,2) > size(wn,1)
      wn=wn';	
   end
   
   timeseries(1:floor(sh_len/2),1) = timeseries(1:floor(sh_len/2),1).*wn(1:floor(sh_len/2),1);
	timeseries(length(timeseries)-floor(sh_len/2):n,1) = timeseries(length(timeseries)-floor(sh_len/2):n,1).*wn(sh_len-floor(sh_len/2):sh_len,1);
  
end

% If vector is real, do the analytic signal    如果向量为实，则执行分析信号 

if analytic_signal
   if verbose 
       disp('计算分析信号（使用希尔伯特变换）'),end
   % this version of the hilbert transform is different than hilbert.m
   %  This is correct!
   ts_spe = fft(real(timeseries));
   h = [1; 2*ones(fix((n-1)/2),1);ones(1-rem(n,2),1); zeros(fix((n-1)/2),1)];
   %%%%^^^^^^^^^^^^^^ones（a,b）生成全是1的a*b的矩阵，zeros（a,b）生成全是0的a*b的矩阵，rem(x,y):整除x/y的余数
   ts_spe(:) = ts_spe.*h(:);                      
   %%%%^^^^^^^^^^^^^^A（：）表示A的所有元素
   timeseries = ifft(ts_spe);
end  

% Compute FFT's
tic;                  %^^^^^^^^^^^^^^^^^^^^tic和toc用来记录matlab命令执行的时间
vector_fft=fft(timeseries);
tim_est=toc;
vector_fft=[vector_fft,vector_fft];
tim_est = tim_est*ceil((maxfreq - minfreq+1)/freqsamplingrate)   ;
if verbose 
    fprintf('预计时间 %f\n',tim_est),end

% 预分配ST输出矩阵
st=zeros(ceil((maxfreq - minfreq+1)/freqsamplingrate),n);
% 计算均值
% Compute S-transform value for 1 ... ceil(n/2+1)-1 frequency points
if verbose 
    disp('计算S变换'),end
if minfreq == 0
   st(1,:) = mean(timeseries)*(1&[1:1:n]);    %^^^^^^^mean:求均值
else
   st(1,:)=ifft(vector_fft(minfreq+1:minfreq+n).*g_window(n,minfreq,factor));
end

% the actual calculation of the ST
% ^^^^^^^^^^^^开始循环以增加频率点
for banana=freqsamplingrate:freqsamplingrate:(maxfreq-minfreq)
   st(banana/freqsamplingrate+1,:)=ifft(vector_fft(minfreq+banana+1:minfreq+banana+n).*g_window(n,minfreq+banana,factor));
end   % a fruit loop!   aaaaa ha ha ha ha ha ha ha ha ha ha
% ^^^^^^^^^^^^结束循环以增加频率点
if verbose 
    disp('计算完成'),end

%%% end strans function

%------------------------------------------------------------------------
function gauss=g_window(length,freq,factor)

% Function to compute the Gaussion window for 
% function Stransform. g_window is used by function
% Stransform. Programmed by Eric Tittley
%
%-----Inputs Needed--------------------------
%
%	length----------高斯窗的长度
%
%	  freq----------评估窗口的频率
%
%	 factor---------窗口宽度因子
%
%-----Outputs Returned--------------------------
%
%	gauss-----------The Gaussian window
%

vector(1,:)=[0:length-1];
vector(2,:)=[-length:-1];
vector=vector.^2;

% 修改前
% vector=vector.*(-factor.*2.*pi^2./freq.^2);

% 修改后
global lamda p;
vector=vector.*(-factor.*2.*pi^2./freq.^(2*p)/lamda.^2);

% Compute the Gaussion window
gauss=sum(exp(vector));


%-----------------------------------------------------------------------

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
function [ minfreq,maxfreq,samplingrate,freqsamplingrate] =  check_input(minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,timeseries)
% this checks numbers, and replaces them with defaults if invalid

% if the parameters are passed as an array, put them into the appropriate variables
s = size(minfreq);
l = max(s);
if l > 1  
   if verbose 
       disp('接受输入数组'),end
   temp=minfreq;
   minfreq = temp(1);
   if l > 1  
       maxfreq = temp(2);end
   if l > 2  
       samplingrate = temp(3);end
   if l > 3  
       freqsamplingrate = temp(4);end
   if l > 4  
      if verbose 
          disp('忽略额外的输入参数'),end
   end

end      
     
   if minfreq < 0 || minfreq > fix(length(timeseries)/2)   %||表示“或”
      minfreq = 0;
      if verbose 
          disp('Minfreq < 0 or > Nyquist. Setting minfreq = 0.'),end
   end
   if maxfreq > length(timeseries)/2  || maxfreq < 0 
      maxfreq = fix(length(timeseries)/2);
      if verbose 
          fprintf('Maxfreq < 0 or > Nyquist. Setting maxfreq = %d\n',maxfreq),end
   end
  if minfreq > maxfreq 
      temporary = minfreq;
      minfreq = maxfreq;
      maxfreq = temporary;
      clear temporary;
      if verbose 
          disp('交换 maxfreq <=> minfreq.'),end
   end
   if samplingrate <0
      samplingrate = abs(samplingrate);
      if verbose 
          disp('Samplingrate <0. 将采样率设置为其绝对值'),end
   end
   if freqsamplingrate < 0   % check 'what if freqsamplingrate > maxfreq - minfreq' case
      freqsamplingrate = abs(freqsamplingrate);
      if verbose 
          disp('频率采样率是负值，取绝对值'),end
   end

% bloody odd how you don't end a function

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
function st_help
   disp(' ')
   disp('st()  帮助命令')
   disp('st() returns  - 1 or an error message if it fails')
   disp('USAGE::    [localspectra,timevector,freqvector] = st(timeseries)')
   disp('NOTE::             函数st()设置默认参数，然后调用函数strans()')
   disp(' ')  
   disp(' ****      您可以直接调用strans()并传递以下参数      ****')
   disp(' **** 警告！如果直接调用strans()，则不会检查这些输入！****')
   disp('USAGE::  localspectra = strans(timeseries,minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,removeedge,analytic_signal,factor) ')
     
   disp(' ')
   disp('默认参数（在st.m中可用）')
   disp('verbose          - prints out informational messages throughout the function.')
   disp('removeedge       - 以5％的锥度去除边缘，然后进行计算')
   disp('factor           - 局部高斯的宽度因数，即周期为10秒的正弦曲线，具有宽度因数* 10秒的高斯窗口')
   disp('                   我通常使用factor=1，但有时使用factor=3，以获得更好的频率分辨率')
   disp(' ')
   disp('默认输入变量')
   disp('minfreq           - ST结果中的最低频率（默认= 0)')
   disp('maxfreq           - ST结果中的最高频率（默认= nyquist）')
   disp('samplingrate      - 连续数据点之间的时间间隔（默认= 1）')
   disp('freqsamplingrate  - ST结果中样本之间的频率数')
	
% end of st_help procedure   


