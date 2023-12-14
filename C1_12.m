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

    textoresultado = '';
    disp('1. ÁREAS');
    disp('1. CALCULAR ÁREA DE UN CUADRADO');
    disp('2. CALCULAR ÁREA DE UN TRIÁNGULO');
    disp('3. CALCULAR ÁREA DE UN CIRCULO');
    opcion2 = input('SU ELECCIÓN: ');

    switch opcion2
        case 1
            lado = input('LONGITUD DEL LADO: ');
            area = lado^2;
            textoresultado = sprintf('EL ÁREA DEL CUADRADO ES: %.2f\n', area);
        case 2
            base = input('LONGITUD DE LA BASE DEL TRIÁNGULO: ');
            altura = input('ALTURA DEL TRIÁNGULO: ');
            area = (base * altura) / 2;
            textoresultado = sprintf('EL ÁREA DEL TRIÁNGULO ES: %.2f\n', area);
        case 3
            radio = input('RADIO DEL CÍRCULO: ');
            area = pi * radio^2;
            textoresultado = sprintf('EL ÁREA DEL CÍRCULO ES: %.2f\n', area);
        otherwise
            disp('OPCIÓN NO VALIDA.');
    end
disp(textoresultado);




conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));

try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_12" ("TEXTO_SALIDA") VALUES ($1)';
    valores = {textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('DATOS INSERTADOS CON ÉXITO\n');
catch e
    disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('*TEXTO_SALIDA: %s\n', textoresultado);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_12.txt';

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
    nombre_archivo = 'C1_12.txt';

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

