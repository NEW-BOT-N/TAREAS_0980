pkg load database;
nombre_archivo = 'I_5.txt';
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
      disp('VENTAS');
      disp('1. AGREAGAR');
      disp('2. VISUALIZAR');
      opcion2 = input('SU ELECCIÓN: ');
      switch opcion2
        case 1
          fecha = input('FECHA: ', 's');
          monto = input('MONTO: ');


          try
              consulta_sql = 'INSERT INTO "I_5" ("FECHA","MONTO") VALUES ($1,$2)';
              valores = {fecha,monto};
              resultado = pq_exec_params(conn, consulta_sql, valores);
              cadena_texto = sprintf('* SE AGREGÓ UNA VENTA NUEVA\nFECHA: %s\nMONTO: %d\n', fecha, monto);
              disp(cadena_texto);
          catch a
              disp(['ERROR DURANTE LA CONEXIÓN A LA DB, ERROR: ' a.message]);
          end

          guardarEnArchivo(nombre_archivo, cadena_texto);
        case 2
        try
            consulta_sql = 'SELECT * FROM "I_5" ORDER BY "ENTRADA"';
            resultado = pq_exec_params(conn, consulta_sql);

            fprintf('\nVENTAS REALIZADAS\nFECHA         MONTO\n');
            for i = 1:rows(resultado.data)
                fprintf('%s   Q%d\n', resultado.data{i, 2}, resultado.data{i, 3});
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
catch c
    disp(['OPCIÓN INVALIDA, ERROR: ' c.message]);
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
    catch g
        disp(['ERROR DURANTE LA TRANSCRIPCIÓN, ERROR: ' d.message]);
    end
end

