%Identification Systems Exercises 
%Escola Politecnica da Universidade de Sao Paulo 2022 
%Fernando Z Preto

%==================================================
%a) Discretization and comparasion under step input
%==================================================

K = 2;
tal = 10; %s
theta = 4; %s

%Continuos Transfer Function of the process LTI
Gs = tf(K,[tal 1],'InputDelay',theta)

Ts = 1; %s
%Discretization with period Ts and considering Zero Order Hold
    % q is used instead of z because in Identification Systems context
    % they consider the operator delay as real number and Z is a complex
    % one
Gq = c2d(Gs,Ts,'zoh')

%Simulink
integration_step_size = 0.01; %s
Simulation_Time = 20; %s
simOut = sim('models_continuosAndDiscrit_stepInput',Simulation_Time)


% Plots of step response
dark_blue = ' [0 0.4470 0.7410] ' ;
red_maple = ' [0.6350 0.0780 0.1840] ' ;
dark_organge = ' [0.8500 0.3250 0.0980] ' ;
dark_green = ' [0.4660 0.6740 0.1880] ' ;
figure ()
subplot (2 ,1 ,1)
hold on ;
plot ( simOut.ref , 'color' , dark_green )
plot ( simOut.y , 'color' , dark_blue )
plot ( simOut.yd , 'color' , red_maple )
grid ()
legend ( ' Reference ' , 'Process output' , 'Discretized process output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response - Fixed step 0.01s by Euler Integration Method' )
hold off ;
subplot (2 ,1 ,2)
hold on ;
plot ( simOut.u , 'color' , dark_blue )
plot ( simOut.ud , 'color' , red_maple )
grid ()
legend ( 'Process' , ' Discretized process' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( ' Controled Input ' )
hold off ;
% subplot (3 ,1 ,3)
% hold on ;
% plot ( simOut.error , 'color' , dark_blue )
% plot ( simOut.errord , 'color' , red_maple )
% grid ()
% legend ( ' Process ' , 'Discretized process' )
% xlabel ( ' tempo [ s ] ' )
% ylabel ( ' Amplitude ' )
% title ( ' Error e( t ) ' )
% hold off ;


%% ================================================
%b) Gaussian Noise
%==================================================

integration_step_size = 0.01; %s
Simulation_Time = 20; %s
simOutb = sim('b_gaussianNoise',Simulation_Time)

figure ()
hold on ;
plot ( simOutb.ref_b , 'color' , dark_green )
plot ( simOutb.y_b , 'color' , dark_blue )
plot ( simOutb.yideal_b , 'color' , red_maple )
grid ()
legend ( ' Reference ' , 'Process output', 'Process output without noise')
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response with gaussian Noise N(0,1E-6) - Fixed step 0.01s by Euler Integration Method' )
hold off ;

%% ======================================================
%c) Gaussian Noise afeted by 1 and 2 order linear filters
%========================================================

%Noise variances
var_low = 0.001;
var_high = 0.1;

%Disturbances Transfer Functions (Perturbacoes)
s = tf('s')

    %First Order Filter
Kpert1 = 1;
tal_pert1 = 5; %s
Gpert1s = Kpert1/(tal_pert1*s + 1)

    %Secound Order Filter
Kpert2 = 2;
tal_pert21 = 5; %s
tal_pert22 = 10; %s
Gpert2s = Kpert1/((tal_pert21*s + 1)*(tal_pert22*s + 1))

%Discretization of Filters Transfer Functions

Gpert1q = c2d(Gpert1s,Ts,'zoh')
Gpert2q = c2d(Gpert2s,Ts,'zoh')

%Simulink
integration_step_size = 0.01; %s
Simulation_Time = 20; %s
simOutc = sim('c_multipleNoises',Simulation_Time)

figure()
    %Low variance noises
subplot (3 ,2 ,1)
hold on ;
plot ( simOutc.e_direct_low , 'color' , red_maple )
grid ()
ylim([-0.06 0.06])
legend ( 'Direct noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Low Variance Noise (variance = 0.001)' )
hold off ;
subplot (3 ,2 ,3)
hold on ;
plot ( simOutc.e1_low , 'color' , red_maple )
grid ()
ylim([-0.015 0.015])
legend ( 'First Order Filtered noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Low Variance Noise (variance = 0.001)' )
hold off ;
subplot (3 ,2 ,5)
hold on ;
plot ( simOutc.e2_low , 'color' , red_maple )
grid ()
ylim([-0.005 0.005])
legend ( 'Secound Order Filtered noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Low Variance Noise (variance = 0.001)' )
hold off ;
    %High variance noises
subplot (3 ,2 ,2)
hold on ;
plot ( simOutc.e_direct_high , 'color' , red_maple )
grid ()
ylim([-0.6 0.6])
legend ( 'Direct noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'High Variance Noise (variance = 0.1)' )
hold off ;
subplot (3 ,2 ,4)
hold on ;
plot ( simOutc.e1_high , 'color' , red_maple )
grid ()
ylim([-0.03 0.03])
legend ( 'First Order Filtered noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'High Variance Noise (variance = 0.1)' )
hold off ;
subplot (3 ,2 ,6)
hold on ;
plot ( simOutc.e2_high , 'color' , red_maple )
grid ()
ylim([-0.01 0.01])
legend ( 'Secound Order Filtered noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'High Variance Noise (variance = 0.1)' )
hold off ;

%% ========================================================
%d) Output afeted by Diferent Gaussian based noises Tsim=60
%==========================================================

integration_step_size = 0.01; %s
Simulation_Time = 60; %s
simOutc = sim('c_multipleNoises',Simulation_Time)

%d1 - var = 0.01 =================================

figure ()
    %Signal + Noises
subplot (3 ,2 ,1)
hold on ;
plot ( simOutc.ref_c , 'color' , dark_green )
plot ( simOutc.yideal_c , 'color' , dark_blue )
plot ( simOutc.v_direct_low , 'color' , red_maple )
grid ()
ylim([-0.05 0.3])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + noise' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response with direct gaussian noise (var = 0.001)' )
hold off ;
subplot (3 ,2 ,3)
hold on ;
plot ( simOutc.ref_c , 'color' , dark_green )
plot ( simOutc.yideal_c , 'color' , dark_blue )
plot ( simOutc.v1_low , 'color' , red_maple )
grid ()
ylim([-0.05 0.25])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + noise' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response with gaussian noise filtered by First Order Filter (var = 0.001)' )
hold off ;
subplot (3 ,2 ,5)
hold on ;
plot ( simOutc.ref_c , 'color' , dark_green )
plot ( simOutc.yideal_c , 'color' , dark_blue )
plot ( simOutc.v2_low , 'color' , red_maple )
grid ()
ylim([-0.05 0.25])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + noise' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response with gaussian noise filtered by Secound Order Filter (var = 0.001)' )
hold off ;
    %Noises
subplot (3 ,2 ,2)
hold on ;
plot ( simOutc.e_direct_low , 'color' , red_maple )
grid ()
ylim([-0.1 0.1])
legend ( 'Direct noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Low Variance Noise (variance = 0.001)' )
hold off ;
subplot (3 ,2 ,4)
hold on ;
plot ( simOutc.e1_low , 'color' , red_maple )
grid ()
ylim([-0.015 0.015])
legend ( 'First Order Filtered noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Low Variance Noise (variance = 0.001)' )
hold off ;
subplot (3 ,2 ,6)
hold on ;
plot ( simOutc.e2_low , 'color' , red_maple )
grid ()
ylim([-0.005 0.005])
legend ( 'Secound Order Filtered noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Low Variance Noise (variance = 0.001)' )
hold off ;

figure()
hold on ;
plot ( simOutc.ref_c , 'color' , 'k' )
plot ( simOutc.yideal_c , '--'  ,'color' , 'k')
plot ( simOutc.v_direct_low , 'color' , dark_green )
plot ( simOutc.v1_low ,'LineWidth',0.5, 'color' , dark_blue )
plot ( simOutc.v2_low ,'LineWidth',0.5, 'color' , red_maple )
grid ()
ylim([-0.005 0.3])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + direct noise', 'Process output + 1º filtered noise' , 'Process output + 2º filtered noise'  )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response with gaussian noises (var = 0.001)' )
hold off ;

% d2 - var = 0.1 ==================================

figure ()
    %Signal + Noises
subplot (3 ,2 ,1)
hold on ;
plot ( simOutc.ref_c , 'color' , dark_green )
plot ( simOutc.yideal_c , 'color' , dark_blue )
plot ( simOutc.v_direct_high , 'color' , red_maple )
grid ()
ylim([-0.4 1.2])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + noise' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response with direct gaussian noise (var = 0.1)' )
hold off ;
subplot (3 ,2 ,3)
hold on ;
plot ( simOutc.ref_c , 'color' , dark_green )
plot ( simOutc.yideal_c , 'color' , dark_blue )
plot ( simOutc.v1_high , 'color' , red_maple )
grid ()
ylim([-0.025 0.25])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + noise' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response with gaussian noise filtered by First Order Filter (var = 0.1)' )
hold off ;
subplot (3 ,2 ,5)
hold on ;
plot ( simOutc.ref_c , 'color' , dark_green )
plot ( simOutc.yideal_c , 'color' , dark_blue )
plot ( simOutc.v2_high , 'color' , red_maple )
grid ()
ylim([-0.025 0.25])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + noise' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response with gaussian noise filtered by Secound Order Filter (var = 0.1)' )
hold off ;
    %Noises
subplot (3 ,2 ,2)
hold on ;
plot ( simOutc.e_direct_high , 'color' , red_maple )
grid ()
ylim([-1 1])
legend ( 'Direct noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'High Variance Noise (variance = 0.1)' )
hold off ;
subplot (3 ,2 ,4)
hold on ;
plot ( simOutc.e1_high , 'color' , red_maple )
grid ()
ylim([-0.03 0.03])
legend ( 'First Order Filtered noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'High Variance Noise (variance = 0.1)' )
hold off ;
subplot (3 ,2 ,6)
hold on ;
plot ( simOutc.e2_high , 'color' , red_maple )
grid ()
ylim([-0.01 0.01])
legend ( 'Secound Order Filtered noise output' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'High Variance Noise (variance = 0.1)' )
hold off ;

figure()
hold on ;
plot ( simOutc.ref_c , 'color' , 'k' )
plot ( simOutc.yideal_c , '--'  ,'color' , 'k')
plot ( simOutc.v_direct_high , 'color' , dark_green )
plot ( simOutc.v1_high ,'LineWidth',0.5, 'color' , dark_blue )
plot ( simOutc.v2_high ,'LineWidth',0.5, 'color' , red_maple )
grid ()
ylim([-0.4 1.0])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + direct noise', 'Process output + 1º filtered noise' , 'Process output + 2º filtered noise'  )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response with gaussian noises (var = 0.1)' )
hold off ;

%% ========================================================
%e) Output afeted by Diferent Gaussian based noises Tsim=60
%==========================================================

%simulink
integration_step_size = 0.01; %s
Simulation_Time = 60; %s
simOute = sim('e_noisev1plusv2',Simulation_Time)

    %Low Variance
figure()
subplot(2,2,[1 3])
hold on ;
plot ( simOute.ref_e , 'color' , dark_green )
plot ( simOute.yideal_e ,'--', 'color' , 'k' )
plot ( simOute.v12_low_e , 'color' , red_maple )
grid ()
ylim([-0.001 0.21])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + (v1 + v2)' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response affected by v1+v2 (var = 0.001)' )
hold off ;
subplot(2,2,2)
hold on ;
plot ( simOute.e1_low_e , 'color' , 'b' )
plot ( simOute.e2_low_e , 'color' , 'm' )
grid ()
ylim([-0.005 0.005])
legend ( 'v1','v2' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Noise (variance = 0.001)' )
hold off ;
subplot(2,2,4)
hold on ;
plot ( simOute.e12_low_e , 'color' , 'r' )
grid ()
ylim([-0.005 0.005])
legend ( 'Noises ' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Added noises (v1+v2) (variance = 0.001)' )
hold off ;

    %High Variance
figure()
subplot(2,2,[1 3])
hold on ;
plot ( simOute.ref_e , 'color' , dark_green )
plot ( simOute.yideal_e ,'--', 'color' , 'k' )
plot ( simOute.v12_high_e , 'color' , red_maple )
grid ()
ylim([-0.005 0.25])
legend ( ' Reference ' , 'Process ideal output' , 'Process output + (v1 + v2)' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Step Response affected by v1+v2 (var = 0.1)' )
hold off ;
subplot(2,2,2)
hold on ;
plot ( simOute.e1_high_e , 'color' , 'b' )
plot ( simOute.e2_high_e , 'color' , 'm' )
grid ()
ylim([-0.03 0.03])
legend ( 'v1','v2' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Noise (variance = 0.1)' )
hold off ;
subplot(2,2,4)
hold on ;
plot ( simOute.e12_high_e , 'color' , 'r' )
grid ()
ylim([-0.03 0.03])
legend ( 'Noises ' )
xlabel ( ' time [ s ] ' )
ylabel ( ' Amplitude ' )
title ( 'Added noises (v1+v2) (variance = 0.1)' )
hold off ;