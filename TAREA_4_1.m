% Definir la variable de tiempo en el rango de -0.04 a 0.04 con incrementos de 0.001
t = -0.04:0.001:0.04;

% Definir la función x(t) usando números complejos y la variable de tiempo t
x = 20 * exp(j * (80 * pi * t - 0.4 * pi));

% Crear una figura y establecer el tamaño de la ventana (posición x, posición y, ancho, alto)
figure('Position', [183, 180, 1000, 420]);

% Crear la primera subgráfica en una fila y dos columnas
subplot(1, 2, 1);

% Graficar la función x en 3D con la parte real en el eje x, la parte imaginaria en el eje y
plot3(t, real(x), imag(x));
% Activar la cuadrícula en la subgráfica
grid on; grid minor;
% Establecer el título de la subgráfica
title('20*e^{j*(80\pit-0.4\pi)}');
% Etiquetas de los ejes
xlabel('Tiempo (s)'); ylabel('Real'); zlabel('Imag');

% Crear la segunda subgráfica en una fila y dos columnas
subplot(1, 2, 2);

% Graficar la parte real de x en azul y mantener la gráfica (hold on)
plot(t, real(x), 'b'); hold on;

% Graficar la parte imaginaria de x en rojo
plot(t, imag(x), 'r');
% Activar la cuadrícula en la subgráfica
grid on; grid minor;
% Establecer el título de la subgráfica
title('Rojo - Componente Imaginario, Azul - Componente Real');
% Etiquetas de los ejes
xlabel('Tiempo (s)'); ylabel('Amplitud');

