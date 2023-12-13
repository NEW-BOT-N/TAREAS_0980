%ETAPA 1 - GENERAR SEÑAL SENOIDAL
fs = 1000; % frecuencia de muestreo
t = 0:1/fs:1; % vector de tiempo
f = 100; % frecuenciade la señal
x = sin(2*pi*f*t); % señal senoidal
%ETAPA 2 - APLICAR TRANSFORMADA DE FOURIER
xf = fft(x);
%ETAPA 3 - GENERAR FILTRO PASA BAJO
n = length(x);
fcutoff = 50; % frecuencia de corte
h = ones(n,1); % vector de ceros
h(round(n*fcutoff/fs)+1:end) = 0; %aplicar filtro
%ETAPA 4 - APLICAR FILTRO A LA SEÑAL EN EL DOMINIO DE LA FRECUENCIA
xf_filtered = xf .* h;
%ETAPA 5 - CONVERTIR SEÑAL FILTRADA AL DOMINO DEL TIEMPO
x_filtered = ifft(xf_filtered);
%ETAPA 6 - GENERAR GRÁFICA DE LA SEÑAL ORIGINAL Y LA SEÑAL FILTRADA
figure;
subplot(2,1,1);
plot(t,x);
title('Señal Original');
xlabel('Tiempo (s)');
ylabel('Amplitud');
subplot(2,1,2);
plot(t,real(x_filtered));
title('Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
