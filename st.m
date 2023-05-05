% ��S�任�Ļ����ϣ��� gauss=g_window(length,freq,factor) �������޸ģ�
% ���߿ɸ�����Ҫ�������������ʽ���޸�



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
%"minfreq" is the minimum frequency in the ST result(Default=0)����СƵ�ʣ�
%"maxfreq" is the maximum frequency in the ST result (Default=Nyquist)�����Ƶ�ʣ�
%"samplingrate" is the time interval between samples (Default=1)������ʱ������
%"freqsamplingrate" is the frequency-sampling interval you desire in the ST
%                      result (Default=1)������Ƶ�ʼ����
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
%[removeedge] if true, ɾ����С������������ߣ�����ʱ�����еı�Ե����5���ĺ���׶�ȡ�
%                This is usually a good idea.
%[analytic_signal]  if the timeseries is real-valued
%                      ��������ȡ�����źŲ��������ST����
%[factor]     �ֲ�����˹�Ŀ�����ӣ�������Ϊ10������Ҳ�����һ���������*10��ĸ�˹���ڡ�
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
       disp('û�в�������'),end
   st_help
   t=0;st=-1;f=0;
   return
end

% ����Ϊ������    (���ź�ת��Ϊ  n*2  �ľ���)
if size(timeseries,2) > size(timeseries,1)      %�����������������
	timeseries=timeseries';	
end

% Make sure it is a 1-dimensional array
if size(timeseries,2) > 1
   error('���������ݵġ��������������Ǿ���')
      return 
elseif (size(timeseries)==eye(1))==1
	error('���������ݵġ��������������Ǳ���')
      return 
end

% ���������ʹ��Ĭ��ֵ

if nargin == 1
   minfreq = 0;
   maxfreq = fix(length(timeseries)/2);   %fix:��0��£ȡ��
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
       disp('�����������ʹ��Ĭ��ֵ'),end
   minfreq = 0;
   maxfreq = fix(length(timeseries)/2);
   samplingrate=1;
   freqsamplingrate=1;
end
if verbose 
   disp(fprintf('Minfreq = %d\n',minfreq))
   disp(fprintf('Maxfreq = %d\n',maxfreq))
   disp(fprintf('�����ʣ�ʱ  ��=  %d\n',samplingrate))
   disp(fprintf('�����ʣ�Ƶ����=  %d\n',freqsamplingrate))
   disp(fprintf('ʱ�����еĳ����ǣ� %d points\n',length(timeseries)))

   disp(' ')
end
%END OF INPUT VARIABLE CHECK

% If you want to "hardwire" minfreq & maxfreq & samplingrate & freqsamplingrate do it here

% calculate the sampled time and frequency values from the two sampling rates
t = (0:length(timeseries)-1)*samplingrate;
spe_nelements =ceil((maxfreq - minfreq+1)/freqsamplingrate);       % ceil:�����������ȡ��
f = (minfreq + (0:spe_nelements-1)*freqsamplingrate)/(samplingrate*length(timeseries));
if verbose 
    fprintf('The number of frequency voices is %d\n',spe_nelements),end


% The actual S Transform function is here:
st = strans(timeseries,minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,removeedge,analytic_signal,factor); 
% this function is below, thus nicely encapsulated

%WRITE switch statement on nargout
% ���Ϊ0������Ʒ�����
if nargout==0 
   if verbose 
       disp('����α��ɫͼ��'),end
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
%           ST���������Ƶ�ʣ�����ʱ��ֵ

%
%
%-----------------------------------------------------------------------

% Compute the length of the data.
n=length(timeseries);
original = timeseries;
if removeedge
    if verbose 
        disp('�ö���ʽ�����������'),end
 	 ind = [0:n-1]';
    r = polyfit(ind,timeseries,2);          %%%^^^^^^^^polyfit��������Ϻ���
    fit = polyval(r,ind) ;                  %%%^^^^^^^^polyval���������ʽ
	 timeseries = timeseries - fit;
    if verbose 
        disp('��5������׶��ȥ����Ե'),end
    sh_len = floor(length(timeseries)/10);  %%%^^^^^^^^floor�����������ȡ��
    wn = hanning(sh_len);
    if(sh_len==0)
       sh_len=length(timeseries);
       wn = 1&[1:sh_len];
    end
    % ȷ��wn������������Ϊʱ������Ҳ����
   if size(wn,2) > size(wn,1)
      wn=wn';	
   end
   
   timeseries(1:floor(sh_len/2),1) = timeseries(1:floor(sh_len/2),1).*wn(1:floor(sh_len/2),1);
	timeseries(length(timeseries)-floor(sh_len/2):n,1) = timeseries(length(timeseries)-floor(sh_len/2):n,1).*wn(sh_len-floor(sh_len/2):sh_len,1);
  
end

% If vector is real, do the analytic signal    �������Ϊʵ����ִ�з����ź� 

if analytic_signal
   if verbose 
       disp('��������źţ�ʹ��ϣ�����ر任��'),end
   % this version of the hilbert transform is different than hilbert.m
   %  This is correct!
   ts_spe = fft(real(timeseries));
   h = [1; 2*ones(fix((n-1)/2),1);ones(1-rem(n,2),1); zeros(fix((n-1)/2),1)];
   %%%%^^^^^^^^^^^^^^ones��a,b������ȫ��1��a*b�ľ���zeros��a,b������ȫ��0��a*b�ľ���rem(x,y):����x/y������
   ts_spe(:) = ts_spe.*h(:);                      
   %%%%^^^^^^^^^^^^^^A��������ʾA������Ԫ��
   timeseries = ifft(ts_spe);
end  

% Compute FFT's
tic;                  %^^^^^^^^^^^^^^^^^^^^tic��toc������¼matlab����ִ�е�ʱ��
vector_fft=fft(timeseries);
tim_est=toc;
vector_fft=[vector_fft,vector_fft];
tim_est = tim_est*ceil((maxfreq - minfreq+1)/freqsamplingrate)   ;
if verbose 
    fprintf('Ԥ��ʱ�� %f\n',tim_est),end

% Ԥ����ST�������
st=zeros(ceil((maxfreq - minfreq+1)/freqsamplingrate),n);
% �����ֵ
% Compute S-transform value for 1 ... ceil(n/2+1)-1 frequency points
if verbose 
    disp('����S�任'),end
if minfreq == 0
   st(1,:) = mean(timeseries)*(1&[1:1:n]);    %^^^^^^^mean:���ֵ
else
   st(1,:)=ifft(vector_fft(minfreq+1:minfreq+n).*g_window(n,minfreq,factor));
end

% the actual calculation of the ST
% ^^^^^^^^^^^^��ʼѭ��������Ƶ�ʵ�
for banana=freqsamplingrate:freqsamplingrate:(maxfreq-minfreq)
   st(banana/freqsamplingrate+1,:)=ifft(vector_fft(minfreq+banana+1:minfreq+banana+n).*g_window(n,minfreq+banana,factor));
end   % a fruit loop!   aaaaa ha ha ha ha ha ha ha ha ha ha
% ^^^^^^^^^^^^����ѭ��������Ƶ�ʵ�
if verbose 
    disp('�������'),end

%%% end strans function

%------------------------------------------------------------------------
function gauss=g_window(length,freq,factor)

% Function to compute the Gaussion window for 
% function Stransform. g_window is used by function
% Stransform. Programmed by Eric Tittley
%
%-----Inputs Needed--------------------------
%
%	length----------��˹���ĳ���
%
%	  freq----------�������ڵ�Ƶ��
%
%	 factor---------���ڿ������
%
%-----Outputs Returned--------------------------
%
%	gauss-----------The Gaussian window
%

vector(1,:)=[0:length-1];
vector(2,:)=[-length:-1];
vector=vector.^2;

% �޸�ǰ
% vector=vector.*(-factor.*2.*pi^2./freq.^2);

% �޸ĺ�
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
       disp('������������'),end
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
          disp('���Զ�����������'),end
   end

end      
     
   if minfreq < 0 || minfreq > fix(length(timeseries)/2)   %||��ʾ����
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
          disp('���� maxfreq <=> minfreq.'),end
   end
   if samplingrate <0
      samplingrate = abs(samplingrate);
      if verbose 
          disp('Samplingrate <0. ������������Ϊ�����ֵ'),end
   end
   if freqsamplingrate < 0   % check 'what if freqsamplingrate > maxfreq - minfreq' case
      freqsamplingrate = abs(freqsamplingrate);
      if verbose 
          disp('Ƶ�ʲ������Ǹ�ֵ��ȡ����ֵ'),end
   end

% bloody odd how you don't end a function

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^%
function st_help
   disp(' ')
   disp('st()  ��������')
   disp('st() returns  - 1 or an error message if it fails')
   disp('USAGE::    [localspectra,timevector,freqvector] = st(timeseries)')
   disp('NOTE::             ����st()����Ĭ�ϲ�����Ȼ����ú���strans()')
   disp(' ')  
   disp(' ****      ������ֱ�ӵ���strans()���������²���      ****')
   disp(' **** ���棡���ֱ�ӵ���strans()���򲻻�����Щ���룡****')
   disp('USAGE::  localspectra = strans(timeseries,minfreq,maxfreq,samplingrate,freqsamplingrate,verbose,removeedge,analytic_signal,factor) ')
     
   disp(' ')
   disp('Ĭ�ϲ�������st.m�п��ã�')
   disp('verbose          - prints out informational messages throughout the function.')
   disp('removeedge       - ��5����׶��ȥ����Ե��Ȼ����м���')
   disp('factor           - �ֲ���˹�Ŀ��������������Ϊ10����������ߣ����п������* 10��ĸ�˹����')
   disp('                   ��ͨ��ʹ��factor=1������ʱʹ��factor=3���Ի�ø��õ�Ƶ�ʷֱ���')
   disp(' ')
   disp('Ĭ���������')
   disp('minfreq           - ST����е����Ƶ�ʣ�Ĭ��= 0)')
   disp('maxfreq           - ST����е����Ƶ�ʣ�Ĭ��= nyquist��')
   disp('samplingrate      - �������ݵ�֮���ʱ������Ĭ��= 1��')
   disp('freqsamplingrate  - ST���������֮���Ƶ����')
	
% end of st_help procedure   


