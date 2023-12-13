% Define un vector n que va desde -1000 hasta 1000
n = -1000:1000;

% Crea una señal compleja x: exp(j*2*pi*0.01*n)
x = exp(j * 2 * pi * 0.01 * n);

% Crea una figura con dos subgráficos apilados verticalmente
subplot(2, 1, 1);

% Grafica la parte real de la señal y en función de n, en color naranja (código HEX)
plot(n, real(x), 'color', '#FFA500');
% Activar la cuadrícula en la subgráfica
grid on; grid minor;
% Establecer el título de la subgráfica
title('Componente Real');

% Crea otra señal compleja y: exp(j*2*pi*2.01*n)
y = exp(j * 2 * pi * 2.01 * n);

% Mantiene la gráfica actual y agrega la siguiente en la misma ventana
hold on;

% Crea el segundo subgráfico
subplot(2, 1, 2);

% Grafica la parte real de la señal y en función de n, en color rojo ('r')
plot(n, real(y), 'r');
% Activar la cuadrícula en la subgráfica
grid on; grid minor;
% Establecer el título de la subgráfica
title('Componente Real');
