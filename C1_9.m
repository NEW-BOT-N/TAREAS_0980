pkg load database;

textoresultado = '';
textoresultado2 = '';
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
        num1 = input('NÚMERO DE INICIO: ');
        num2 = input('NÚMERO DE FIN: ');
        if num2 <= num1
            error('EL PRIMER NÚMERO DEBE SER MENOR QUE EL SEGUNDO.');
        end
        textoresultado2 ='';


        for i = num1+2:2:num2
            textoresultado2 = sprintf('%s, %d', textoresultado2,i);
        end
        textoresultado = sprintf('SUCESIÓN: %d%s', num1, textoresultado2);
        disp(textoresultado);



conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));

try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_9" ("N_INICIO","N_FIN","TEXTO_SALIDA") VALUES ($1, $2,$3)';
    valores = {num1,num2, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('DATOS INSERTADOS CON ÉXITO\n');
catch e
    disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('* NÚMERO DE INICIO: %d, NÚMERO DE FIN: %d\nTEXTO_SALIDA:\n%s\n', num1,num2, textoresultado);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_9.txt';

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
    nombre_archivo = 'C1_9.txt';

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

