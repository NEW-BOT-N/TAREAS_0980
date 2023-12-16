pkg load database;
nombre_archivo = 'I_2.txt';
textoresultado = '';
opcion = 0;
opcion2 = 0;
gasto =0;
presupuesto=0;


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
      disp('MENU 2');
      disp('1. AGREGAR GASTO');
      disp('2. ACTUALIZAR PRESUPUESTO');
      opcion2=0;
      opcion2 = input('SU ELECCIÓN: ');
      switch opcion2
        case 1
           %OBTENER VALOR DEL PRESUPUESTO
           try
              consulta_sql = 'SELECT "PRESUPUESTO" FROM "I_2" ORDER BY "ENTRADA" DESC LIMIT 1';
              resultado = pq_exec_params(conn, consulta_sql);
              presupuesto = resultado.data{1, 1};
          catch f
              disp(['ERRRO DURANTE LA CONSULTA SQL: ' f.message]);
          end

          gasto = input('INGRESE EL GASTO: ');
          if gasto>presupuesto
            fprintf('NO TIENE PRESUPUESTO SUFICIENTE\n');
          else
            presuactual = presupuesto-gasto;
            %CÓDIGO PARA ACTUALIZAR PRESUPUESTO   y GASTO
            try
              consulta_sql = 'INSERT INTO "I_2" ("PRESUPUESTO","GASTO") VALUES ($1,$2)';
              valores = {presuactual,gasto};
              resultado = pq_exec_params(conn, consulta_sql, valores);
              fprintf('SE AGREGÓ UN GASTO NUEVO\nMONTO: %d\nPRESUPUESTO ACTUAL: %d\n', gasto, presuactual);
          catch e
              disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' e.message]);
          end

          cadena_texto = sprintf('* SE AGREGÓ UN GASTO NUEVO\nMONTO: %d\nPRESUPUESTO ACTUAL: %d\n', gasto, presuactual);
          guardarEnArchivo(nombre_archivo, cadena_texto);
        end

        case 2
          try
              consulta_sql = 'SELECT "PRESUPUESTO" FROM "I_2" ORDER BY "ENTRADA" DESC LIMIT 1';
              resultado = pq_exec_params(conn, consulta_sql);
              presupuesto = resultado.data{1, 1};
          catch f
              disp(['ERRRO DURANTE LA CONSULTA SQL: ' f.message]);
          end
          addpresup = input('MONTO A SUMAR: ');
          presuactual=presupuesto+addpresup;
            try
              consulta_sql = 'INSERT INTO "I_2" ("PRESUPUESTO","GASTO") VALUES ($1,$2)';
              valores = {presuactual,gasto};
              resultado = pq_exec_params(conn, consulta_sql, valores);

              fprintf('SE ACTUALIZÓ EL PRESUPUESTO\nMONTO APORTADO: %d\nPRESUPUESTO ACTUAL: %d\n', addpresup, presuactual);
          catch h
              disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' h.message]);
          end

          cadena_texto = sprintf('* SE ACTUALIZÓ EL PRESUPUESTO\nMONTO APORTADO: %d\nPRESUPUESTO ACTUAL: %d\n', addpresup, presuactual);
          guardarEnArchivo(nombre_archivo, cadena_texto);
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
        fprintf('\n');
    catch l
        disp(['ERROR DURANTE LA TRANSCRIPCIÓN, ERROR: ' l.message]);
    end
end

