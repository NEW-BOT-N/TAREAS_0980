pkg load database;


salir = false;
textoresultado = '';
while ~salir
    % Solicitar tres números al usuario
    num1 = input('Ingrese el primer número: ');
    num2 = input('Ingrese el segundo número: ');
    num3 = input('Ingrese el tercer número: ');

    % Comparar los números y realizar acciones según las condiciones
    if num1 == num2 && num2 ~= num3
        % Dos primeros números iguales
        textoresultado = sprintf('Los dos primeros números son iguales y diferentes al tercero: %d\n', num3);
    elseif num1 == num3 && num1 ~= num2
        % Primer y tercer número iguales
        textoresultado = sprintf('El primer y tercer número son iguales y diferentes al segundo: %d\n', num2);
    elseif num2 == num3 && num2 ~= num1
        % Dos últimos números iguales
        textoresultado = sprintf('Los dos últimos números son iguales y diferentes al primero: %d\n', num1);

    elseif num1 > num2 && num1 > num3
        % El primer número es el mayor
        resultado = num1 + num2 + num3;
        textoresultado = sprintf('El mayor es el primer número. La suma es: %f\n', resultado);
    elseif num2 > num1 && num2 > num3
        % El segundo número es el mayor
        resultado = num1 * num2 * num3;
        textoresultado = sprintf('El mayor es el segundo número. La multiplicación es: %d\n', resultado);
    elseif num3 > num1 && num3 > num2
        % El tercer número es el mayor
        resultado = strcat(num2str(num1), num2str(num2), num2str(num3));
        textoresultado = sprintf('El mayor es el tercer número. La concatenación es: %s\n', resultado);
            else
        % Todos los números son iguales
        textoresultado = sprintf('Todos los números son iguales: %d, %d, %d \n', num1,num2,num3);
    end
    %Mostar resultado
    disp(textoresultado);
    % Preguntar al usuario si desea salir del bucle

conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));

try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_1" ("PRIMER_NUMERO", "SEGUNDO_NUMERO", "TERCER_NUMERO", "TEXTO_SALIDA") VALUES ($1, $2, $3, $4)';
    valores = {num1, num2, num3, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('Datos insertados con éxito\n');
catch e
    disp(['Error durante la conexión a la DB, error: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('*PRIMER_NUMERO: %d, SEGUNDO_NUMERO: %d, TERCER_NUMERO: %d, TEXTO_SALIDA: %s\n', num1, num2, num3, textoresultado);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_1.txt';

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

