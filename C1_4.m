pkg load database;

salir = false;
textoresultado = '';
while ~salir

% Solicitar al usuario que ingrese un número
num1 = input('Ingrese un número: ');

% Inicializar la suma
suma = 0;

% Calcular la suma desde 0 hasta el número ingresado
for i = 0:num1
    suma = suma + i;
end

% Mostrar los resultados
 textoresultado = sprintf('La suma desde 0 hasta %d es: %d\n', num1, suma);
 disp(textoresultado);

conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));
 try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_4" ("NUMERO", "TEXTO_SALIDA") VALUES ($1,$2)';
    valores = {num1, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('Datos insertados con éxito\n');
catch e
    disp(['Error durante la conexión a la DB, error: ' e.message]);
end


try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('La suma desde 0 hasta %d es: %d\n', num1, suma);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_4.txt';

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


    opcion = input('¿Desea salir? (Sí/No): ', 's');
    if strcmpi(opcion, 'Sí') || strcmpi(opcion, 'Si')|| strcmpi(opcion, 's')
        salir = true;
    end
end

