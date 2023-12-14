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
  % Menú de opciones


  switch opcion
    case 1

          % Solicitar tres números al usuario
    num1 = input('PRIMER NOTA: ');
    num2 = input('SEGUNDA NOTA: ');
    num3 = input('TERCERA NOTA: ');
    prom = (num1+num2+num3)/3;
    % Comparar los números y realizar acciones según las condiciones
    if prom>=60
      textoresultado = sprintf('APROBADO ☺\n');
    else
        % Todos los números son iguales
        textoresultado = sprintf('REPROBADO\n');
    end
    %Mostar resultado
    disp(textoresultado);


conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));
try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_13" ("NOTA_1", "NOTA_2", "NOTA_3","PROMEDIO", "TEXTO_SALIDA") VALUES ($1, $2, $3, $4, $5)';
    valores = {num1, num2, num3,prom, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('DATOS INSERTADOS CON ÉXITO\n');
catch e
    disp(['ERROR AL REALIZAR LA CONEXIÓN A LA DB, ERROR: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('NOTA 1: %d, NOTA 2: %d, NOTA 3: %d, PROMEDIO: %d\nTEXTO_SALIDA: %s\n', num1, num2, num3, prom, textoresultado);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_13.txt';
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
    nombre_archivo = 'C1_13.txt';

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

