clc;
clear all;

[t,I] = RIR;
f1= displayRoom('testfile','HideVS');   
figure
plot(1000*t,abs(I))
ylabel('Amplitude')
xlabel('Time (ms)')
legend('Source 1','Source 2')