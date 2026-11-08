# API Tienda de Regalos

CRUD de productos con Express y postgres

## Levantar

```bash
docker compose up --build -d
```

Para apagar:

```bash
docker compose down
```


## Endpoints

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/productos` | Lista todos los productos |
| GET | `/productos/:id` | Obtiene un producto |
| POST | `/productos` | Crea un producto |
| PUT | `/productos/:id` | Actualiza un producto |
| DELETE | `/productos/:id` | Elimina un producto |

## Ejemplos

Listar:

```bash
curl localhost:8080/productos
```

Obtener uno:

```bash
curl localhost:8080/productos/1
```

Crear:

```bash
curl -X POST localhost:8080/productos \
  -H 'Content-Type: application/json' \
  -d '{"nombre":"Llavero","descripcion":"Llavero de madera","precio":12000,"stock":30}'
```

Actualizar:

```bash
curl -X PUT localhost:8080/productos/1 \
  -H 'Content-Type: application/json' \
  -d '{"nombre":"Taza grande","descripcion":"Taza de 500ml","precio":30000,"stock":10}'
```

Eliminar:

```bash
curl -X DELETE localhost:8080/productos/1
```

## Respuestas

- `200` OK
- `201` producto creado
- `204` producto eliminado
- `404` `{"error":"No encontrado"}`
- `500` `{"error":"..."}`
