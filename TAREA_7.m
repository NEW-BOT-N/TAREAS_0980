pkg load database;

conn = pq_connect(setdbopts('dbname','IVA','host','localhost','port','5432','user','postgres','password','123456'));

precio = input("Precio: Q");
iva = precio*0.12;
coniva = precio+iva;
fprintf("IVA Q%d\n",iva);
fprintf("Precio Con IVA Q%d\n",coniva);

try
% Construcción y ejecución de la consulta SQL
consulta_sql = ['INSERT INTO "PRECIOS" ("PRECIO", "CONIVA") VALUES (' num2str(precio) ', ' num2str(coniva) ');'];
resultado = pq_exec_params(conn, consulta_sql);
fprintf("Datos insertados con exito");
  catch e
  disp(['Error durante la conexión a la DB, error: ' e.message]);
  end



