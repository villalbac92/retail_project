
-- ============================================================
-- 1. BASE DE DATOS
-- ============================================================
-- Ejecutar este archivo desde una base administrativa (por ejemplo postgres).
CREATE DATABASE retail_project;

-- Si usas psql, cambia a la base recién creada:
\connect retail_project

-- ============================================================
-- 2. DDL - ESTRUCTURA
-- ============================================================

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    edad INTEGER NOT NULL,
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT chk_clientes_edad CHECK (edad >= 18)
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    categoria VARCHAR(80) NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_productos_precio CHECK (precio > 0),
    CONSTRAINT chk_productos_stock CHECK (stock >= 0)
);

-- Se crea después de clientes y productos para que las FK
-- tengan tablas de destino existentes.
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    fecha_venta DATE NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_ventas_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_ventas_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT chk_ventas_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_ventas_precio_unitario CHECK (precio_unitario > 0)
);

-- ============================================================
-- 3. DML - CARGA INICIAL
-- ============================================================
-- Los INSERT de las tres tablas se ejecutan dentro de una
-- transacción explícita. Si algún INSERT falla, puede hacerse
-- ROLLBACK para evitar una carga parcial.

BEGIN;

INSERT INTO clientes (nombre, email, edad) VALUES
    ('Ana García', 'ana.garcia@example.com', 28),
    ('Bruno López', 'bruno.lopez@example.com', 35),
    ('Carla Martínez', 'carla.martinez@example.com', 42),
    ('Diego Rodríguez', 'diego.rodriguez@example.com', 31),
    ('Elena Fernández', 'elena.fernandez@example.com', 26);

INSERT INTO productos (nombre, categoria, precio, stock) VALUES
    ('Notebook Pro 14', 'Notebooks', 1250.00, 15),
    ('Mouse Inalámbrico', 'Periféricos', 35.50, 80),
    ('Teclado Mecánico', 'Periféricos', 89.90, 45),
    ('Monitor 27 pulgadas', 'Monitores', 420.00, 20),
    ('Auriculares Bluetooth', 'Audio', 75.00, 60);

-- Se cargan 6 ventas para que, después del DELETE de prueba,
-- permanezcan al menos 5 registros en ventas.
INSERT INTO ventas
    (id_cliente, id_producto, cantidad, fecha_venta, precio_unitario)
VALUES
    (1, 1, 1, '2026-09-20', 1250.00),
    (2, 2, 2, '2026-09-21', 35.50),
    (3, 3, 1, '2026-09-22', 89.90),
    (4, 4, 1, '2026-09-23', 420.00),
    (5, 5, 2, '2026-09-24', 75.00),
    (1, 4, 1, '2026-09-25', 420.00);

COMMIT;

-- ============================================================
-- 4. MANTENIMIENTO SEGURO
-- ============================================================

-- SELECT previo para confirmar qué productos serán modificados.
SELECT id_producto, nombre, categoria, precio
FROM productos
WHERE categoria = 'Periféricos';

-- UPDATE masivo: aumenta un 5% el precio de toda la categoría
-- Periféricos. El WHERE evita modificar otras categorías.
UPDATE productos
SET precio = ROUND(precio * 1.05, 2)
WHERE categoria = 'Periféricos';

-- DELETE de un registro de prueba.
-- SELECT previo para confirmar exactamente qué venta se eliminará.
SELECT *
FROM ventas
WHERE id_venta = 6;

DELETE FROM ventas
WHERE id_venta = 6;


