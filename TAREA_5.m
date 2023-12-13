if (exist('OCTAVE_VERSION', 'builtin') ~= 0)
  pkg load signal;
end
% Si estamos en Octave, cargamos el paquete de señales

% Menu Principal
opcion = 0;
while opcion ~= 5
  % Bucle hasta que se seleccione la opción de salir
  disp('Seleccione una opcion')
  disp('1. Grabar')
  disp('2. Reproducir')
  disp('3. Graficar')
  disp('4. Graficar densidad')
  disp('5. Salir')
  opcion = input('Ingrese su eleccion: ');
  % Menú de opciones

  switch opcion
    case 1
      % Grabacion de audio
      try
        duracion = input('Ingrese la duracion de la grabacion en segundos: ');
        disp('Comenzando la grabacion...');
        recObj = audiorecorder;
        recordblocking(recObj, duracion);
        disp('Grabacion finalizada.');
        data = getaudiodata(recObj);
        audiowrite('audio.wav', data, recObj.SampleRate);
        disp('Archivo de audio grabado correctamente.');
      catch
        disp('Error al grabar el audio.');
      end
    case 2
      % Reproduccion de audio
      try
        [data, fs] = audioread('audio.wav');
        sound(data, fs);
      catch
        disp('Error al reproducir el audio.');
      end
    case 3
      % Grafica de audio
      try
        [data, fs] = audioread('audio.wav');
        tiempo = linspace(0, length(data)/fs, length(data));
        plot(tiempo, data);
        xlabel('Tiempo (s)');
        ylabel('Amplitud');
        title('Audio');
      catch
        disp('Error al graficar el audio.');
      end
    case 4
      % Graficando espectro de frecuencia
      try
        disp('Graficando espectro de frecuencia...');
        % Lee la señal desde el archivo .wav
        [audio, Fs] = audioread('audio.wav');
        % Numero de muestras de la señal
        N = length(audio);
        % Vector de Frecuencias
        f = linspace(0, Fs/2, N/2+1);
        % Ventana de Hann para reducir el efecto de las discontinuidades al calcular la FFT
        ventana = hann(N);
        % Densidad espectral de potencia
        Sxx = pwelch(audio, ventana, 0, N, Fs);
        % Grafica el espectro de frecuencia en dB
        plot(f, 10*log10(Sxx(1:N/2+1)));
        xlabel('Frecuencia (Hz)');
        ylabel('Densidad espectral de potencia (db/Hz)');
        title('Espectro de frecuencia de la señal grabada');
      catch
        disp('Error al graficar el audio.');
      end
    case 5
      % Salir
      disp('Saliendo del programa...');
    otherwise
      % Opción no válida
      disp('Opcion no valida.');
  end
end

