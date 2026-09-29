# Retail Project

Esquema base de un proyecto retail en PostgreSQL con las tablas `clientes`, `productos` y `ventas`.

## Contenido

* `retail\_project.sql`: creación de la base de datos, DDL, carga inicial y operaciones de mantenimiento.



## Ejecución

Desde una terminal con `psql`:

1. Crea la base de datos `retail\_project`.
2. Se conecta a ella mediante `\\connect retail\_project`.
3. Crea `clientes` y `productos`.
4. Crea `ventas` después de las tablas referenciadas.
5. Ejecuta la carga inicial dentro de `BEGIN; ... COMMIT;`.
6. Ejecuta un `SELECT` previo al `UPDATE`.
7. Actualiza con `WHERE` los precios de la categoría `Periféricos`.
8. Ejecuta un `SELECT` previo al `DELETE`.
9. Elimina únicamente la venta de prueba con `id\_venta = 6`.

## Integridad

* Todas las tablas tienen `PRIMARY KEY`.
* `clientes.email` es `NOT NULL` y `UNIQUE`.
* `productos.id\_producto` utiliza `SERIAL`.
* `productos.precio` y `ventas.precio\_unitario` utilizan `DECIMAL`.
* `ventas` tiene claves foráneas hacia `clientes` y `productos`.
* Incluye restricciones `CHECK` para edad, precio, stock, cantidad y precio unitario.

## 

