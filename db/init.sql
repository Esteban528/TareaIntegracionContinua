CREATE TABLE IF NOT EXISTS productos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  precio NUMERIC(10,2) NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0
);

INSERT INTO productos (nombre, descripcion, precio, stock) VALUES
  ('Taza personalizada', 'Taza de ceramica con mensaje', 25000, 20),
  ('Peluche oso', 'Oso de peluche mediano', 45000, 10),
  ('Caja de chocolates', 'Caja con 12 chocolates surtidos', 35000, 15);
