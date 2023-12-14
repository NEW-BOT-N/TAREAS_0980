pkg load database;

salir = false;
textoresultado = '';
while ~salir
    % Solicitar tres números al usuario
    num1 = input('Ingrese un número: ');


    % Inicializar un vector para almacenar los divisores
    divisores = [];

    % Encontrar los divisores del número
    for i = 1:num1
        if rem(num1, i) == 0
            % i es un divisor de numero
            divisores = [divisores i];
        end
    end

% Mostrar los divisores
        textoresultado = sprintf('Los divisores de %d son: %s\n', num1, num2str(divisores));
    %Mostar resultado
    disp(textoresultado);
    % Preguntar al usuario si desea salir del bucle

conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));
try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_2" ("NUMERO", "TEXTO_SALIDA") VALUES ($1,$2)';
    valores = {num1, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('Datos insertados con éxito\n');
catch e
    disp(['Error durante la conexión a la DB, error: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('NUMERO: %d, TEXTO_SALIDA: %s\n', num1, textoresultado);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_2.txt';

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

