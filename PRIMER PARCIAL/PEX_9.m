pkg load database;
nombre_archivo = 'I_9.txt';
cadena_texto ='';
texto ='';
nombre_modificar ='';
opcion = 0;
opcion2 = 0;
cantidadbase=0;
nueva_cantidad=0;


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
      disp('1. AGREAGAR NUEVO');
      disp('2. ACTUALIZAR CANTIDAD');
      disp('3. AGREGAR VENTA');
      opcion2 = input('SU ELECCIÓN: ');
      switch opcion2
        case 1
          nombre = input('NOMBRE DEL PRODUCTO: ', 's');
          cantidad = input('CANTIDAD: ');
        nombre_modificar=nombre;
   try
        consulta_existencia = 'SELECT COUNT(*) FROM "I_9" WHERE "PRODUCTO" = $1';
        valores_existencia = {nombre_modificar};
        resultado_existencia = pq_exec_params(conn, consulta_existencia, valores_existencia);
        texto=sprintf('%d',resultado_existencia.data{1, 1});
    catch e
        disp(['ERROR DURANTE LA VERIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end
        if texto == '0'
         try
              consulta_sql = 'INSERT INTO "I_9" ("PRODUCTO","CANTIDAD") VALUES ($1,$2)';
              valores = {nombre,cantidad};
              resultado = pq_exec_params(conn, consulta_sql, valores);
              cadena_texto = sprintf('* SE AGREGÓ UN PRODUCTO NUEVO\nNOMBRE: %s\nCANTIDAD: %d\n', nombre, cantidad);
              disp(cadena_texto);
              guardarEnArchivo(nombre_archivo, cadena_texto);
          catch e
              disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
          end

        else
            fprintf('EL PRODUCTO YA EXISTE EN LA BASE DE DATOS\n');
        end

        case 2

    nombre_modificar = input('INGRESE EL NOMBRE DEL PRODUCTO A MODIFICAR: ', 's');

           try
        consulta_existencia = 'SELECT COUNT(*) FROM "I_9" WHERE "PRODUCTO" = $1';
        valores_existencia = {nombre_modificar};
        resultado_existencia = pq_exec_params(conn, consulta_existencia, valores_existencia);
        texto=sprintf('%d',resultado_existencia.data{1, 1});
    catch e
        disp(['ERROR DURANTE LA VERIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end
        if texto != '0'
    nueva_cantidad = input('CANTIDAD: ');
    try
        consulta_modificar = 'UPDATE "I_9" SET "CANTIDAD" = $1 WHERE "PRODUCTO" = $2';
        valores_modificar = {nueva_cantidad, nombre_modificar};
        resultado_modificar = pq_exec_params(conn, consulta_modificar, valores_modificar);
        cadena_texto = sprintf('* SE MODIFICÓ LA CANTIDAD DEL PRODUCTO: %s\nCANTIDAD ACTUALIZADA: %d\n', nombre_modificar,nueva_cantidad);
       disp(cadena_texto);
        guardarEnArchivo(nombre_archivo, cadena_texto);
    catch e
        disp(['ERROR DURANTE LA MODIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end

        else
            fprintf('NO SE ENCONTRÓ EL REGISTRO EN LA BASE DE DATOS\n');
        end


        case 3
          fprintf('INTRODUZCA LA INFORMACIÓN DE LA VENTA\n');
          nombre = input('NOMBRE DEL PRODUCTO: ', 's');
             try
        consulta_existencia = 'SELECT COUNT(*) FROM "I_9" WHERE "PRODUCTO" = $1';
        valores_existencia = {nombre};
        resultado_existencia = pq_exec_params(conn, consulta_existencia, valores_existencia);
        texto=sprintf('%d',resultado_existencia.data{1, 1});
    catch e
        disp(['ERROR DURANTE LA VERIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end
                  if texto != '0'

cantidad = input('CANTIDAD: ');
          monto = input('MONTO: Q');
   try
        consulta_existencia = 'SELECT "CANTIDAD" FROM "I_9" WHERE "PRODUCTO" = $1';
        valores_existencia = {nombre};
        resultado_existencia = pq_exec_params(conn, consulta_existencia, valores_existencia);
        cantidadbase = resultado_existencia.data{1, 1};
    catch e
        disp(['ERROR DURANTE LA VERIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end

  nueva_cantidad=cantidadbase-cantidad;
  nombre_modificar=nombre;
    try
        consulta_modificar = 'UPDATE "I_9" SET "CANTIDAD" = $1 WHERE "PRODUCTO" = $2';
        valores_modificar = {nueva_cantidad, nombre_modificar};
        resultado_modificar = pq_exec_params(conn, consulta_modificar, valores_modificar);
        cadena_texto = sprintf('* SE MODIFICÓ LA CANTIDAD DEL PRODUCTO: %s\nCANTIDAD ACTUALIZADA: %d\n', nombre_modificar,nueva_cantidad);
       disp(cadena_texto);
        guardarEnArchivo(nombre_archivo, cadena_texto);
    catch e
        disp(['ERROR DURANTE LA MODIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end

              try
              consulta_sql = 'INSERT INTO "I_9_V" ("PRODUCTO","CANTIDAD","MONTO") VALUES ($1,$2,$3)';
              valores = {nombre,cantidad,monto};
              resultado = pq_exec_params(conn, consulta_sql, valores);
              cadena_texto = sprintf('* SE AGREGÓ UNA VENTA\nNOMBRE: %s\nCANTIDAD: %d\n,MONTO: %d\n', nombre, cantidad,monto);
              disp(cadena_texto);
          catch e
              disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
          end

        else
            fprintf('NO SE ENCONTRÓ EL REGISTRO EN LA BASE DE DATOS\n');
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


