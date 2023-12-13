% Define una secuencia de valores de -3 a 7
n = -3:7;

% Define una señal x en función de la secuencia n
x = 0.55 .^ (n + 3);

% Define una respuesta al impulso h como una secuencia de unos
h = [1 1 1 1 1 1 1 1 1 1 1];

% Realiza la convolución de las señales x e h y almacena el resultado en y
y = conv(x, h);

% Crear una figura y establecer el tamaño de la ventana (posición x, posición y, ancho, alto)
figure('Position', [233, 78, 900, 600]);

% Subgráfico 1: Grafica la señal original x usando la función stem
subplot(311)
stem(x)
title('Señal Original')

% Subgráfico 2: Grafica la respuesta al impulso h usando la función stem
subplot(312)
stem(h)
title('Respuesta al impulso/ Segunda Señal')

% Subgráfico 3: Grafica el resultado de la convolución y usando la función stem
subplot(313)
stem(y)
title('Convolución Resultante')
