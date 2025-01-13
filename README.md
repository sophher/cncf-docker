# CNCF Docker

## Demo 1 - Typical Docker Build

```bash
pnpm install --frozen-lockfile
pnpm run test
pnpm run build
docker build --file demo1.Dockerfile --tag demo1 .
docker run --name demo1 -d -p 8080:80 demo1
curl http://localhost:8080
docker stop demo1
docker rm demo1
```

## Demo 2 - BuildKit
```bash
docker build --file demo2.Dockerfile --target test --output type=local,dest=coverage .
docker build --file demo2.Dockerfile --target build --tag demo2 .
docker run --name demo2 -d -p 8080:80 demo2
curl http://localhost:8080
docker stop demo2
docker rm demo2
```

## Demo 3 - Mounts

```bash
docker build --file demo3.Dockerfile --target test --output type=local,dest=coverage .
docker build --file demo3.Dockerfile --target build --tag demo3 .
docker run --name demo2 -d -p 8080:80 demo3
curl http://localhost:8080
docker stop demo3
docker rm demo3
```