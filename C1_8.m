pkg load database;

textoresultado = '';
opcion = 0;
while opcion ~= 3
  % Bucle hasta que se seleccione la opción de salir
  disp('MENÚ')
  disp('1. CALCULAR')
  disp('2. MOSTRAR HISTORIAL')
  disp('3. SALIR')
  opcion = input('INGRESE SU ELECCIÓN:');
  fprintf('\n');
  % Menú de opciones


  switch opcion
    case 1
        modelo = input('INGRESE EL MODELO: ');
        km = input('INGRESE EL KILOMETRAJE: ');
        if modelo < 2007
          if km > 20000
             textoresultado = sprintf('EL TAXI DEBE SER RENOVADO\n');
          end
        elseif modelo >= 2007 && modelo <=2013
          if km == 20000
             textoresultado = sprintf('EL TAXI DEBE RECIBIR MANTENIMIENTO\n');
          end

        elseif modelo > 2013
          if km < 10000
             textoresultado = sprintf('EL TAXI SE ENCUENTRA EN CONDICIONES ÓPTIMAS\n');
          end
        else
          textoresultado = sprintf('MECÁNICO\n');
        end
        disp(textoresultado);



conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));

try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_8" ("MODELO","KILOMETRAJE","TEXTO_SALIDA") VALUES ($1, $2,$3)';
    valores = {modelo,km, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('DATOS INSERTADOS CON ÉXITO\n');
catch e
    disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('* MODELO: %d, KILOMETRAJE: %d, TEXTO_SALIDA: %s\n', modelo,km, textoresultado);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_8.txt';

    % Abrir el archivo en modo de escritura (o crearlo si no existe)
    archivo = fopen(nombre_archivo, 'a');

    % Verificar si el archivo se abrió correctamente
    if archivo == -1
        error('NO SE PUEDE ABRIR EL ARCHIVO .TXT');
    end

    % Escribir la cadena de texto en el archivo
    fprintf(archivo, cadena_texto);

    % Cerrar el archivo
    fclose(archivo);

    fprintf('DATOS ALMACENADOS EN ARCHIVO\n');
    fprintf('\n');
catch e
    disp(['ERROR DURANTE LA TRANSCRIPCIÓN, ERROR: ' e.message]);
end
    case 2
    % Especifica el nombre del archivo
    nombre_archivo = 'C1_8.txt';

    % Lee el contenido del archivo
    contenido = fileread(nombre_archivo);

    % Muestra el contenido en la consola
    disp('CONTENIDO DEL HISTORIAL:');
    disp(contenido);

    case 3
      % Salir
      disp('SALIENDO DEL SCRIPT...');
    otherwise
      % Opción no válida
      disp('OPCIÓN INVALIDA.');
  end

end

