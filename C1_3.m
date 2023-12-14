pkg load database;

salir = false;
textoresultado = '';
while ~salir

% Solicitar al usuario que ingrese una palabra
palabra = input('Ingrese una palabra: ', 's');

% Inicializar contadores
vocales_con=0;
vocales_sin=0;
% Definir las vocales con y sin tilde
vocalescontilde = 'áéíóúÁÉÍÓÚ';
vocalessintilde = 'aeiouAEIOU';
% Contar las vocales con tilde en la palabra
for i = 1:length(palabra)
    if any(palabra(i) == vocalescontilde)
        vocales_con = vocales_con + 1;
    end
end
%contar vocales sin tilde
for i = 1:length(palabra)
    if any(palabra(i) == vocalessintilde)
        vocales_sin = vocales_sin + 1;
    end
end
vocales=(vocales_con/2)+vocales_sin;

% Mostrar los resultados
 textoresultado = sprintf('Vocales : %d\n', vocales);
 disp(textoresultado);


conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));
 try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_3" ("PALABRA", "TEXTO_SALIDA") VALUES ($1,$2)';
    valores = {palabra, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('Datos insertados con éxito\n');
catch e
    disp(['Error durante la conexión a la DB, error: ' e.message]);
end


try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('Palabra Ingresada: %s, Vocales : %d\n', palabra, vocales);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_3.txt';

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


