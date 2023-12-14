pkg load database;

textoresultado = '';
opcion = 0;
while opcion ~= 3
  % Bucle hasta que se seleccione la opción de salir
  disp('MENÚ')
  disp('1. CALCULAR')
  disp('2. MOSTRAR HISTORIAL')
  disp('3. SALIR')
  opcion = input('INGRESE SU ELECCIÓN: ');
  fprintf('\n');
  % Menú de opciones


  switch opcion
    case 1
        pkg load database;

textoresultado = '';
year = input('INGRESE UN AÑO: ');

    % Determinar si un año es bisiesto

    if rem(year, 4) == 0
        % Año divisible por 4
        if rem(year, 100) == 0
            % Año divisible por 100
            if rem(year, 400) == 0
                % Año divisible por 400
                es_bisiesto = true;
            else
                es_bisiesto = false;
            end
        else
            % Año no divisible por 100
            es_bisiesto = true;
        end
    else
        % Año no divisible por 4
        es_bisiesto = false;
    end

    % Mostrar el resultado
    if es_bisiesto
       textoresultado = sprintf('%d ES AÑO BISIESTO.\n', year);
    else
       textoresultado = sprintf('%d NO ES AÑO BISIESTO.\n', year);
    end

disp(textoresultado);





conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));

try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_14" ("YEAR", "TEXTO_SALIDA") VALUES ($1, $2)';
    valores = {year, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('DATOS INSERTADOS CON ÉXITO\n');
catch e
    disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('* AÑO: %d\nTEXTO_SALIDA:%s\n', year, textoresultado);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_14.txt';

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
    nombre_archivo = 'C1_14.txt';

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

