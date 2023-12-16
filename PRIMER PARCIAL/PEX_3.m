pkg load database;
nombre_archivo = 'I_3.txt';
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
      disp('PRODUCTOS');
      disp('1. AGREAGAR');
      disp('2. MODIFICAR');
      disp('3. ELIMINAR');
      opcion2 = input('SU ELECCIÓN: ');
      switch opcion2
        case 1
          nombre = input('NOMBRE DEL PRODUCTO: ', 's');
          cantidad = input('CANTIDAD: ');

          try
              consulta_sql = 'INSERT INTO "I_3" ("PRODUCTO","CANTIDAD") VALUES ($1,$2)';
              valores = {nombre,cantidad};
              resultado = pq_exec_params(conn, consulta_sql, valores);
              cadena_texto = sprintf('* SE AGREGÓ UN PRODUCTO NUEVO\nNOMBRE: %s\nCANTIDAD: %d\n', nombre, cantidad);
              disp(cadena_texto);
          catch e
              disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
          end

          guardarEnArchivo(nombre_archivo, cadena_texto);
        case 2

    nombre_modificar = input('INGRESE EL NOMBRE DEL PRODUCTO A MODIFICAR: ', 's');

    try

        consulta_existencia = 'SELECT COUNT(*) FROM "I_3" WHERE "PRODUCTO" = $1';
        valores_existencia = {nombre_modificar};
        resultado_existencia = pq_exec_params(conn, consulta_existencia, valores_existencia);
        texto=sprintf('%d',resultado_existencia.data{1, 1});
        if texto != '0'
    nueva_cantidad = input('CANTIDAD: ');
    try
        consulta_modificar = 'UPDATE "I_3" SET "CANTIDAD" = $1 WHERE "PRODUCTO" = $2';
        valores_modificar = {nueva_cantidad, nombre_modificar};
        resultado_modificar = pq_exec_params(conn, consulta_modificar, valores_modificar);
        cadena_texto = sprintf('* SE MODIFICÓ LA CANTIDAD DEL PRODUCTO: %s\nCANTIDAD ACTUALIZADA: %d', nombre_modificar,nueva_cantidad);
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

    nombre_eliminar = input('INGRESE EL NOMBRE DEL PRODUCTO A ELIMINAR: ', 's');

    try

        consulta_existencia = 'SELECT COUNT(*) FROM "I_3" WHERE "PRODUCTO" = $1';
        valores_existencia = {nombre_eliminar};
        resultado_existencia = pq_exec_params(conn, consulta_existencia, valores_existencia);
        texto=sprintf('%d',resultado_existencia.data{1, 1});
        if texto != '0'
          try

              consulta_sql = 'DELETE FROM "I_3" WHERE "PRODUCTO" = $1';
              valores_eliminar = {nombre_eliminar};
              resultado_eliminar = pq_exec_params(conn, consulta_sql, valores_eliminar);
              cadena_texto = sprintf('* SE ELIMINÓ EL PRODUCTO: %s\n', nombre_eliminar);
              disp(cadena_texto);
              guardarEnArchivo(nombre_archivo, cadena_texto);
          catch e
              disp(['ERROR DURANTE LA ELIMINACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
          end
     else
            fprintf('NO SE ENCONTRÓ EL REGISTRO EN LA BASE DE DATOS\n');
        end
    catch e
        disp(['ERROR DURANTE LA VERIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
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

