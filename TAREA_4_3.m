% Definir una secuencia de números de -50 a 50
n = -50:50;

% Definir tres señales diferentes en función de la secuencia n
x = cos(pi * 0.1 * n);
y = cos(pi * 0.9 * n);
z = cos(pi * 2.1 * n);

% Crear una figura y establecer el tamaño de la ventana (posición x, posición y, ancho, alto)
figure('Position', [283, 78, 800, 600]);

% Subtrama 1: Graficar la señal x[n]
subplot(311);
plot(n, x);
% Título de la subtrama
title('x[n]=cos(0.1\pin)');
% Activar la cuadrícula en la subgráfica
grid on; grid minor;

% Subtrama 2: Graficar la señal y[n]
subplot(312);
plot(n, y);
% Título de la subtrama
title('y[n]=cos(0.9\pin)');
% Activar la cuadrícula en la subgráfica
grid on; grid minor;

% Subtrama 3: Graficar la señal z[n]
subplot(313);
plot(n, z);
% Activar la cuadrícula en la subgráfica
grid on; grid minor;
% Título de la subtrama
title('z[n]=cos(2.1\pin)');
% Etiqueta del eje x en la subtrama inferior
xlabel('n');
