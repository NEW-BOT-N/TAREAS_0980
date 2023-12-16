pkg load database;
nombre_archivo = 'I_6.txt';
cadena_texto ='';
opcion = 0;
opcion2 = 0;


try
  while opcion ~= 4
  % Bucle hasta que se seleccione la opción de salir
  disp('MENÚ')
  disp('1. INGRESAR AL SCRIPT')
  disp('2. MOSTRAR HISTORIAL')
  disp('3. ELIMINAR HISTORIAL')
  disp('4. SALIR')
  opcion = input('INGRESE SU ELECCIÓN: ');
  fprintf('\n');

  switch opcion
    case 1
      conn = pq_connect(setdbopts('dbname','EXAMEN_1','host','localhost','port','5432','user','postgres','password','123456'));
      disp('SENSOR');
      disp('1. AGREAGAR');
      disp('2. UPDATE MANUAL');
      disp('3. VISUALIZAR DATA');
      opcion2 = input('SU ELECCIÓN: ');
      switch opcion2
        case 1
          nombre = input('NOMBRE DEL SENSOR: ', 's');
          valor = input('VALOR INICIAL: ');

          try
              consulta_sql = 'INSERT INTO "I_6" ("NOMBRE","VALOR") VALUES ($1,$2)';
              valores = {nombre,valor};
              resultado = pq_exec_params(conn, consulta_sql, valores);
              cadena_texto = sprintf('* SE AGREGÓ UN SENSOR NUEVO\nNOMBRE: %s\nVALOR INICIAL: %d\n', nombre, valor);
              disp(cadena_texto);
          catch e
              disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
          end

          guardarEnArchivo(nombre_archivo, cadena_texto);
        case 2

    nombre_modificar = input('INGRESE NOMBRE DEL SENSOR A CALIBRAR: ', 's');

    try

        consulta_existencia = 'SELECT COUNT(*) FROM "I_6" WHERE "NOMBRE" = $1';
        valores_existencia = {nombre_modificar};
        resultado_existencia = pq_exec_params(conn, consulta_existencia, valores_existencia);
        texto=sprintf('%d',resultado_existencia.data{1, 1});
        if texto != '0'
    nueva_cantidad = input('VALOR UPDATE: ');
    try
        consulta_modificar = 'UPDATE "I_6" SET "VALOR" = $1 WHERE "NOMBRE" = $2';
        valores_modificar = {nueva_cantidad, nombre_modificar};
        resultado_modificar = pq_exec_params(conn, consulta_modificar, valores_modificar);
        cadena_texto = sprintf('* SE REALIZÓ UN UPDATE MANUAL DEL SENSOR: %s\nVALOR: %d\n', nombre_modificar,nueva_cantidad);
       disp(cadena_texto);
        guardarEnArchivo(nombre_archivo, cadena_texto);
    catch e
        disp(['ERROR DURANTE LA MODIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end


        else
            fprintf('NO SE ENCONTRÓ EL REGISTRO EN LA BASE DE DATOS\n');
        end
    catch e
        disp(['ERROR DURANTE LA VERIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end

    case 3

            try
            consulta_sql = 'SELECT * FROM "I_6" ORDER BY "ENTRADA"';
            resultado = pq_exec_params(conn, consulta_sql);

            fprintf('\nESTADO SENSORES\n');
            for i = 1:rows(resultado.data)
                fprintf('SENSOR: %s\nVALOR: %d\n\n', resultado.data{i, 2}, resultado.data{i, 3});
            end

        catch b
            disp(['ERROR DURANTE LA CONSULTA A LA DB, ERROR: ' b.message]);
        end

        otherwise
          disp('OPCIÓN INVALIDA');
      end



    case 2
      % Lee el contenido del archivo
      contenido = fileread(nombre_archivo);

      % Muestra el contenido en la consola
      disp('CONTENIDO DEL HISTORIAL:');
      disp(contenido);

    case 3

      % Abre el archivo en modo de escritura para borrar su contenido
      fid = fopen(nombre_archivo, 'w');
      fclose(fid);
      disp('CONTENIDO DEL HISTORIAL BORRADO.');
    case 4
      disp('SALIENDO DEL SCRIPT...');
      pq_close(conn);
    otherwise
      disp('OPCIÓN INVALIDA.');
  end
end
catch e
    disp(['OPCIÓN INVALIDA, ERROR: ' e.message]);
end


function guardarEnArchivo(nombre_archivo, cadena_texto)
    try
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
end

