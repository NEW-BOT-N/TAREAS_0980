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
a_cont=0;
e_cont=0;
i_cont=0;
o_cont=0;
u_cont=0;
% Solicitar al usuario que ingrese una palabra
palabra = input('INGRESE UNA PALABRA: ', 's');

% Definir las vocales con y sin tilde

function num_vocales = contar_vocales(palabra, vcontil, vsintil)
    % Inicializar contadores
    vocales_con = 0;
    vocales_sin = 0;

    % Contar vocales con tilde
    for i = 1:length(palabra)
        if any(palabra(i) == vcontil)
            vocales_con = vocales_con + 1;
        end
    end

    % Contar vocales sin tilde
    for i = 1:length(palabra)
        if any(palabra(i) == vsintil)
            vocales_sin = vocales_sin + 1;
        end
    end

    % Calcular el total de vocales
    num_vocales = (vocales_con / 2) + vocales_sin;
end

a_cont = contar_vocales(palabra, 'áÁ', 'aA');
e_cont = contar_vocales(palabra, 'éÉ', 'eE');
i_cont = contar_vocales(palabra, 'íÍ', 'iI');
o_cont = contar_vocales(palabra, 'óÓ', 'oO');
u_cont = contar_vocales(palabra, 'úÚ', 'uU');
textoresultado = sprintf('CANTIDAD DE VOCALES: \nA: %d\nE: %d\nI: %d\nO: %d\nU: %d', a_cont, e_cont,i_cont,o_cont,u_cont);
disp(textoresultado);





conn = pq_connect(setdbopts('dbname','CORTO_1','host','localhost','port','5432','user','postgres','password','123456'));

try
    % Construcción y ejecución de la consulta SQL
    consulta_sql = 'INSERT INTO "C1_11" ("PALABRA", "TEXTO_SALIDA") VALUES ($1, $2)';
    valores = {palabra, textoresultado};
    resultado = pq_exec_params(conn, consulta_sql, valores);

    fprintf('DATOS INSERTADOS CON ÉXITO\n');
catch e
    disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
end

try
    % Construcción de la cadena de texto a escribir en el archivo
    cadena_texto = sprintf('* PALABRA: %s\nTEXTO_SALIDA:\n%s\n', palabra, textoresultado);

    % Especificar el nombre del archivo txt
    nombre_archivo = 'C1_11.txt';

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
    nombre_archivo = 'C1_11.txt';

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

