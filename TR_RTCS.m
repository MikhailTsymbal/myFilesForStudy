clc
clear all
close all hidden
%% Дано
q=1;
j=sqrt(-1);
E=50*1e-3;
Ti=20*1e-6;
f=2*1e6;
fd=100*f;
sigma_x=0.2;
beta=400*1e6;
t = 0:1/fd:3*Ti-1/fd;% интервал времени для построения графиков
s=(0.5*E.*((t>=0) +(t-Ti/2>=0))-E.*(t-Ti>=0));% огибающая сигнала на входе
% s=(0.5*E.*((t>=0) +(t-Ti/2>=0))-E.*(t-Ti>=0)).*sin(2*pi*f.*t);
%сигнал на входе
tau=-0.1e-3:0.1e-5:0.1e-3;
tau1=-0.2e-7:0.001e-7:0.2e-7;
%% Корреляционная функция и спектр мощности
Korr_f=power(sigma_x,2)*exp(-beta.^2.*tau1.^2/2);%корреляционная функция
% График сигнала
% figure(1);
% grid on;
% plot(t,s);
% title('Сигнал на входе')
% xlabel('Время, с ')
% ylabel('Амплитуда, В ');
% График корреляционной функции
figure(2);
grid on;
hold on;
plot(tau1,Korr_f);
xlabel('\tau,c');
ylabel('R (\tau)');
title('Корреляционная функция шума на входе')
% Построение графика спектра мощности(по таблице) 
f0=0:0.25e3:2*1e6-0.25e3;
Power_spectr=(power(sigma_x,2)*sqrt(2/pi)/beta)*exp(-(2*pi*f0).^2/(2.*beta.^2));%спектр мощности
figure(3);
grid on;
hold on;
plot(f0,Power_spectr);
title('Cпектральная плотность мощности входе')
xlabel('Частота, Гц');
ylabel('В^2 * c');
%% 2 пункт
f1=0:0.25e3:3*1e6-0.25e3;
S_vh=fft(s);
figure(4);
grid on;
plot(f1,S_vh);
title('Спектральная плотность сигнала на входе')
xlabel('Гц');
ylabel('Вт/с');
K_p=1./power(1+j*(2*1.*(f1-f)/f),2); %коэфф передачи
figure(5);
grid on;
plot(f1,abs(K_p));
title('Коэффициент передачи сигнала до подбора')
xlabel('Гц');
ylabel('');
alp=pi*f/1;
S_vih=(0.5* E.* (1-( 1+alp.*t).*exp(-alp.*t) ).*(t>=0)+0.5*E.*(1-(1+alp.*(t-Ti/2)).*exp(-alp.*(t-Ti/2)))...
    .*(t-Ti/2>=0)-E*(1-(1+alp.*(t-Ti)).*exp(-alp.*(t-Ti))).*(t-Ti>=0)).*abs(K_p);
figure(6);
grid on;
plot(f1,S_vih);
title('Спектральная плотность сигнала на выходе')
xlabel('Гц');
ylabel('Вт/с');
% преобразование Лапласа
s_vih=ifft(S_vih);
figure(7);
grid on;
hold on;
plot(f1,s_vih,'r-');
plot(f1,s,'b-');
title('Сигнал на входе и выходе')
xlabel('Время, с');
ylabel('Амплитуда, В');
%% 3 пункт 
aplpha=pi*f/10;
delt_w=(pi/2)*aplpha;
sigma_vih=sqrt(max(Power_spectr).*1*delt_w);
q=real(max(s_vih))./sigma_vih % максимальное отношение сигнал шум 

%% 4 Пункт другой расчет
a_t=0:0.01:10;
alpha_T=1./sqrt(a_t).*(1-(exp(-a_t/2))-((a_t)/2).*exp(-a_t)/2);
figure(8)
hold on;
grid on;
[M,I]=max(alpha_T);% индекс при котором достигается максимум
plot(a_t,alpha_T)
title('Выбор оптимального значения альфа')
xlabel('\alpha*T');
ylabel('q');
 yline(0.4280);
xline( 3.2900);
alpha= 3.2900/Ti;
qmax=sqrt(E^2.*Ti/(pi.*max(Power_spectr)));
tl=0:0.001*Ti:2*Ti;
Q=29;% добротность подобранная
alp=pi*f/Q; 
%% 5 пункт
f1=1.8*1e6:0.25e3:2.2*1e6-0.25e3;
K_p1=100./power((1+j*(2*Q.*(f1-f)/f)),2); % новый коэфф. передачи
s_vih2=100*(0.5* E.* (1-( 1+alp.*t).*exp(-alp.*t) ).*(t>=0)...
    +0.5*E.*(1-(1+alp.*(t-Ti/2)).*exp(-alp.*(t-Ti/2))).*(t-Ti/2>=0)...
    -E*(1-(1+alp.*(t-Ti)).*exp(-alp.*(t-Ti))).*(t-Ti>=0)).*sin(2*pi*f.*t);
s_vih3=100*(0.5* E.* (1-( 1+alp.*t).*exp(-alp.*t) ).*(t>=0)...
    +0.5*E.*(1-(1+alp.*(t-Ti/2)).*exp(-alp.*(t-Ti/2))).*(t-Ti/2>=0)...
    -E*(1-(1+alp.*(t-Ti)).*exp(-alp.*(t-Ti))).*(t-Ti>=0));
% через преобразование Лапласа
figure(9);
grid on;
hold on;
% plot(t,s_vih,'r-');
% plot(t,s,'b-');
plot(t,s_vih3,'g-');
title('Огибающая выходного усиленного сигнала')
xlabel('Время, с');
ylabel('В');
%% математическое ожидание,дисперсия, плотность вероятности
%% корреляционная функция и спектр мощности напряжения на выходе усилителя
noise_band=pi*alp/2;
f0=1.8*1e6:0.25e3:2.2*1e6-0.25e3;
Power_spectr_y=max(Power_spectr).*power(abs(K_p1),2);% спектр мощности на выходе
figure(10);
grid on;
hold on;
plot(f0,Power_spectr_y);
title('Энергетический спектр сигнала на выходе')
xlabel('Гц');
ylabel('В^2 *c');
sigma_y_kv=max(Power_spectr).*max(power(abs(K_p1),2))*noise_band;% сигма на выходе
R_Corr_y=sigma_y_kv.*exp(-alp*abs(tau)).*(1+alp.*abs(tau));% корреляционная функция на выходе
R_Corr_y1=sigma_y_kv.*exp(-alp*abs(tau)).*cos(2*pi*f/20.*tau).*(1+alp.*abs(tau));
% заполнение корреляционной функции на выходе

figure(11);
grid on;
hold on;
plot(tau, R_Corr_y,'r-');
plot(tau, R_Corr_y1,'b-');
plot(tau, -R_Corr_y,'r--');
title('Корреляционная функция на выходе')
xlabel('\tau,c');
ylabel('R(\tau)');
a=sqrt(pi/2)*beta;% шумовая полоса шума
b=pi*alpha/2;% шумовая полоса цепи
y=-4:0.001:4;
plot_ver=(exp(-y.^2/(2*sigma_y_kv)))./(sqrt(2*pi*sigma_y_kv));
figure(12);
grid on;
hold on;
plot(y, plot_ver,'r-');
title('Плотность вероятности')
xlabel('y');
ylabel('p(y)');
plot_ver=@(y) (exp(-y.^2/(2*sigma_y_kv)))./(sqrt(2*pi*sigma_y_kv));
inte=integral(plot_ver,-2,2)
tl=0:0.001*Ti:2*Ti;
%% Пункт 7 Изобразить временные диаграммы (реализации) шума на входе и выходе усилителя,
% а также результирующего напряжения (суммы сигнала и шума) на входе и выходе усилителя
w_noise = wgn(1000,real(max(Power_spectr)),);
figure(13);
grid on;
hold on;
plot(tl, w_noise);
r_vih =(sqrt(sigma_y_kv))*randn(1,12000);% шум на входе
r_vh =((sigma_x))*randn(1,12000);% шум на выходе
figure(13);
grid on;
hold on;
plot(t, r_vh);%
title('Шум на входе')
xlabel('Время,с');
ylabel('Амплитуда, В');
figure(14);
grid on;
hold on;
plot(t, r_vih);% шум на выходе
title('Шум на выходе')
xlabel('Время,с');
ylabel('Амплитуда, В');
noise_vh = wgn(1,8000,-163.4389);
figure(15);
grid on;
plot(t,noise_vh);
title('Шум на входе')
xlabel('t');
ylabel('В');
noise_vih = wgn(1,8000,-53.0635);
figure(16);
grid on;
hold on;
plot(t,noise_vih);
title('Шум на выходе')
xlabel('t');
ylabel('В');
s_plus_noise_vh=s+r_vh;% сигнал + шум на входе
s_plus_noise_vih=s_vih2+r_vih;% сигнал + шум на выходe
figure(17);
grid on;
hold on;
plot(t,s_plus_noise_vh);
title('Сигнал с шумом на входе')
xlabel('Время,с');
ylabel('Амплитуда, В');
figure(18);
grid on;
hold on;
plot(t,s_plus_noise_vih);
plot(t,s_vih3);
title('Сигнал с шумом на выходе')
xlabel('Время,с');
ylabel('Амплитуда, В');
legend({'радиоимпульс на выходе','огибающая сигнала на выходе'})
%% 8 пункт
ratio_q=qmax/q; % оптимальное отношение сигнал/шум с отношением
% сигнал/шум, полученным при подобранном в п. 3 значении добротности
t3 = -2*Ti+1/fd:1/fd:2*Ti-1/fd;
akf = xcorr(s,s);% акф
figure(19);
grid on;
hold on;
title('Сигнал на выходе согласованного фильтра')
xlabel('\tau,с');
ylabel('Амплитуда, В');
plot(t3+Ti,akf);% выход согласованного фильтра
qmax_max=sqrt((((E/2)^2).*Ti/2 + ((E)^2) .*Ti/2 )./(2*pi.*max(Power_spectr)));