pkg load database;
nombre_archivo = 'I_1.txt';
textoresultado = '';
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
      disp('DATOS');
      disp('1. AGREAGAR');
      disp('2. MODIFICAR');
      disp('3. ELIMINAR');
      opcion2 = input('SU ELECCIÓN: ');
      switch opcion2
        case 1
          nombre = input('NOMBRE: ', 's');
          edad = input('EDAD: ');
          genero = input('GENERO: ', 's');
          direcc = input('DIRECCIÓN: ', 's');


          try
              consulta_sql = 'INSERT INTO "I_1" ("NOMBRE","EDAD","GENERO","DIRECCION") VALUES ($1,$2,$3,$4)';
              valores = {nombre,edad,genero,direcc};
              resultado = pq_exec_params(conn, consulta_sql, valores);

              fprintf('DATOS INSERTADOS CON ÉXITO\n');
          catch e
              disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
          end
          cadena_texto = sprintf('* SE AGREGÓ UN ESTUDIANTE NUEVO\nNOMBRE: %s\nEDAD: %d\nGENERO: %s\nDIRECCIÓN: %s\n', nombre, edad, genero, direcc);
          guardarEnArchivo(nombre_archivo, cadena_texto);
        case 2

              % Modificar información de un estudiante por nombre
    nombre_modificar = input('INGRESE EL NOMBRE DEL ESTUDIANTE A MODIFICAR: ', 's');

    % Verificar si el estudiante existe en la base de datos
    try

        consulta_existencia = 'SELECT COUNT(*) FROM "I_1" WHERE "NOMBRE" = $1';
        valores_existencia = {nombre_modificar};
        resultado_existencia = pq_exec_params(conn, consulta_existencia, valores_existencia);
        texto=sprintf('%d',resultado_existencia.data{1, 1});
        if texto != '0'

    % Solicitar nueva información del estudiante
    nuevo_nombre = input('NUEVO NOMBRE: ', 's');
    nueva_edad = input('NUEVA EDAD: ');
    nuevo_genero = input('NUEVO GÉNERO: ', 's');
    nueva_direccion = input('NUEVA DIRECCIÓN: ', 's');

    % Modificar en la base de datos
    try
        consulta_modificar = 'UPDATE "I_1" SET "NOMBRE" = $1, "EDAD" = $2, "GENERO" = $3, "DIRECCION" = $4 WHERE "NOMBRE" = $5';
        valores_modificar = {nuevo_nombre, nueva_edad, nuevo_genero, nueva_direccion, nombre_modificar};
        resultado_modificar = pq_exec_params(conn, consulta_modificar, valores_modificar);

        fprintf('INFORMACIÓN DEL ESTUDIANTE MODIFICADA EN LA BASE DE DATOS\n');

        cadena_texto = sprintf('* SE MODIFICÓ LA INFORMACIÓN DEL ESTUDIANTE CON NOMBRE: %s\nNOMBRE ESTABLECIDO: %s\nEDAD ESTABLECIDA: %d\nGENERO ESTABLECIDO: %s\nDIRECCIÓN ESTABLECIDA: %s\n', nombre_modificar,nuevo_nombre, nueva_edad, nuevo_genero, nueva_direccion);
        guardarEnArchivo(nombre_archivo, cadena_texto);
    catch e
        disp(['ERROR DURANTE LA MODIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end


        else
            fprintf('NO SE ENCONTRÓ AL ESTUDIANTE EN LA BASE DE DATOS\n');
        end
    catch e
        disp(['ERROR DURANTE LA VERIFICACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
    end


        case 3

% Eliminar estudiante por nombre
    nombre_eliminar = input('INGRESE EL NOMBRE DEL ESTUDIANTE A ELIMINAR: ', 's');
    % Verificar si el estudiante existe en la base de datos
    try

        consulta_existencia = 'SELECT COUNT(*) FROM "I_1" WHERE "NOMBRE" = $1';
        valores_existencia = {nombre_eliminar};
        resultado_existencia = pq_exec_params(conn, consulta_existencia, valores_existencia);
        texto=sprintf('%d',resultado_existencia.data{1, 1});
        if texto != '0'

          % Eliminar en la base de datos
          try

              consulta_sql = 'DELETE FROM "I_1" WHERE "NOMBRE" = $1';
              valores_eliminar = {nombre_eliminar};
              resultado_eliminar = pq_exec_params(conn, consulta_sql, valores_eliminar);

              fprintf('ESTUDIANTE ELIMINADO DE LA BASE DE DATOS\n');
              cadena_texto = sprintf('* SE ELIMINÓ EL ESTUDIANTE CON NOMBRE: %s\n', nombre_eliminar);
              guardarEnArchivo(nombre_archivo, cadena_texto);
          catch e
              disp(['ERROR DURANTE LA ELIMINACIÓN EN LA BASE DE DATOS, ERROR: ' e.message]);
          end
     else
            fprintf('NO SE ENCONTRÓ AL ESTUDIANTE EN LA BASE DE DATOS\n');
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

