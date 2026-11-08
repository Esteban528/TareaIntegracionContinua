# IMAGEN
FROM node:24-alpine3.22
WORKDIR /app

# Cargar dependencias y actualizar certificados
RUN corepack enable && corepack prepare pnpm@9.15.0 --activate
RUN apk add --no-cache curl \
  && mkdir -p /app/certs \
  && curl https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem \
     -o /app/certs/global-bundle.pem
COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile
COPY . .
# Puerto
EXPOSE 8080


# COrrer el servidor
CMD ["pnpm", "run", "dev"]
