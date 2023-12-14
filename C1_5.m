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

% Inicializar un vector para almacenar los números impares
impares = [];

% Encontrar los números impares desde 1 hasta 100
for i = 1:100
    if rem(i, 2) ~= 0
        % i es impar
        impares = [impares i];
    end
end

% Mostrar los números impares
 textoresultado = sprintf('Números impares desde 1 hasta 100: %s\n', num2str(impares));
 disp(textoresultado);


conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));
 try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_5" ("TEXTO_SALIDA") VALUES ($1)';
    valores = {textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('Datos insertados con éxito\n');
catch e
    disp(['Error durante la conexión a la DB, error: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('Números impares desde 1 hasta 100: %s\n\n', num2str(impares));

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_5.txt';

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
    nombre_archivo = 'C1_5.txt';

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
