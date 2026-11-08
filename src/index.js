import express from "express";
import pg from "pg";

const pool = new pg.Pool({
  host: process.env.DB_HOST || "database",
  user: process.env.POSTGRES_USER || "postgres",
  password: process.env.POSTGRES_PASSWORD || "postgres",
  database: process.env.POSTGRES_DB || "postgres",
  port: 5432,
});

const app = express();
app.use(express.json());

app.get("/productos", async (req, res) => {
  const { rows } = await pool.query("SELECT * FROM productos ORDER BY id");
  res.json(rows);
});

app.get("/productos/:id", async (req, res) => {
  const { rows } = await pool.query("SELECT * FROM productos WHERE id = $1", [req.params.id]);
  if (!rows[0]) return res.status(404).json({ error: "No encontrado" });
  res.json(rows[0]);
});

app.post("/productos", async (req, res) => {
  const { nombre, descripcion, precio, stock } = req.body;
  const { rows } = await pool.query(
    "INSERT INTO productos (nombre, descripcion, precio, stock) VALUES ($1, $2, $3, $4) RETURNING *",
    [nombre, descripcion, precio, stock ?? 0]
  );
  res.status(201).json(rows[0]);
});

app.put("/productos/:id", async (req, res) => {
  const { nombre, descripcion, precio, stock } = req.body;
  const { rows } = await pool.query(
    "UPDATE productos SET nombre = $1, descripcion = $2, precio = $3, stock = $4 WHERE id = $5 RETURNING *",
    [nombre, descripcion, precio, stock, req.params.id]
  );
  if (!rows[0]) return res.status(404).json({ error: "No encontrado" });
  res.json(rows[0]);
});

app.delete("/productos/:id", async (req, res) => {
  const { rowCount } = await pool.query("DELETE FROM productos WHERE id = $1", [req.params.id]);
  if (!rowCount) return res.status(404).json({ error: "No encontrado" });
  res.status(204).end();
});

app.use((err, req, res, next) => {
  res.status(500).json({ error: err.message });
});

app.listen(8080, () => console.log("API en puerto 8080"));
