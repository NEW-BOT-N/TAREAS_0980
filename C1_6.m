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
    num1 = input('MEDIDA DEL PRIMER LADO: ');
    num2 = input('MEDIDA DEL SEGUNDO LADO: ');
    num3 = input('MEDIDA DEL TERCER LADO: ');

    % Comparar los números y realizar acciones según las condiciones
    if num1 == num2 && num2 ~= num3
        % Dos primeros números iguales
        textoresultado = sprintf('LAS MEDIDAS PERTENECEN A UN TRIÁNGULO ESCALENO\n');
    elseif num1 == num3 && num1 ~= num2
        % Primer y tercer número iguales
        textoresultado = sprintf('LAS MEDIDAS PERTENECEN A UN TRIÁNGULO ESCALENO\n');
    elseif num2 == num3 && num2 ~= num1
        % Dos últimos números iguales
        textoresultado = sprintf('LAS MEDIDAS PERTENECEN A UN TRIÁNGULO ESCALENO\n');
    elseif num1 > num2 && num1 > num3
        % El primer número es el mayor
        textoresultado = sprintf('LAS MEDIDAS PERTENECEN A UN TRIÁNGULO ISÓSELES\n');
    elseif num2 > num1 && num2 > num3
        % El segundo número es el mayor
        textoresultado = sprintf('LAS MEDIDAS PERTENECEN A UN TRIÁNGULO ISÓSELES\n');
    elseif num3 > num1 && num3 > num2
        % El tercer número es el mayor
        textoresultado = sprintf('LAS MEDIDAS PERTENECEN A UN TRIÁNGULO ISÓSELES\n');
            else
        % Todos los números son iguales
        textoresultado = sprintf('LAS MEDIDAS PERTENECEN A UN TRIÁNGULO EQUILÁTERO\n');
    end
    %Mostar resultado
    disp(textoresultado);


conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));
try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_6" ("LADO_1", "LADO_2", "LADO_3", "TEXTO_SALIDA") VALUES ($1, $2, $3, $4)';
    valores = {num1, num2, num3, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('Datos insertados con éxito\n');
catch e
    disp(['Error durante la conexión a la DB, error: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('LADO 1: %d, LADO 2: %d, LADO 3: %d, TEXTO_SALIDA: %s\n', num1, num2, num3, textoresultado);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_6.txt';

    % Abrir el archivo en modo de escritura (o crearlo si no existe)
    archivo = fopen(nombre_archivo, 'a');

    % Verificar si el archivo se abrió correctamente
    if archivo == -1
        error('No se pudo abrir el archivo para escritura.');
    end

    % Escribir la cadena de texto en el archivo
    fprintf(archivo, cadena_texto);

    % Cerrar el archivo
    fclose(archivo);

    fprintf('Datos almacenados en el archivo\n');
catch e
    disp(['Error durante la operación, error: ' e.message]);
end
    case 2
    % Especifica el nombre del archivo
    nombre_archivo = 'C1_6.txt';

    % Lee el contenido del archivo
    contenido = fileread(nombre_archivo);

    % Muestra el contenido en la consola
    disp('Contenido del archivo:');
    disp(contenido);

    case 3
      % Salir
      disp('Saliendo del programa...');
    otherwise
      % Opción no válida
      disp('Opcion no valida.');
  end

end
