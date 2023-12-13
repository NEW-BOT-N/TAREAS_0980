import psycopg2

try:
    # Establecer la conexión a la base de datos
    conn = psycopg2.connect(
        dbname='IVA',
        user='postgres',
        password='123456',
        host='localhost',
        port='5432'
    )

    # Crear un objeto cursor para ejecutar las consultas
    cursor = conn.cursor()

    # Ejecutar una consulta SELECT para obtener los datos de la tabla PRECIOS
    consulta_select = 'SELECT * FROM "PRECIOS"'
    cursor.execute(consulta_select)

    # Obtener todos los resultados
    resultados = cursor.fetchall()

    # Imprimir los resultados
    for fila in resultados:
        print(f"Codigo:{fila[0]} ,Precio: Q{fila[1]}, Precio con IVA: Q{fila[2]}")

except Exception as e:
    print(f'Error durante la conexión a la DB, error: {e}')

finally:
    # Cerrar el cursor y la conexión
    if cursor is not None:
        cursor.close()
    if conn is not None:
        conn.close()