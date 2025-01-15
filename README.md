# CNCF Docker

## Demo 1 - Typical Docker Build

```bash
pnpm install --frozen-lockfile
pnpm run lint
pnpm run test
pnpm run build
docker login
docker build --file demo1.Dockerfile --tag sophher/cncf-docker:demo1 .
docker push sophher/cncf-docker:demo1
docker run --name demo1 -d -p 8080:80 sophher/cncf-docker:demo1
curl http://localhost:8080
docker stop demo1
docker rm demo1
```

## Demo 2 - BuildKit

```bash
docker login
docker build --file demo2.Dockerfile --target lint --output type=cacheonly --build-arg CACHE_BUST=$(date +%s) .
docker build --file demo2.Dockerfile --target test --output type=local,dest=coverage --build-arg CACHE_BUST=$(date +%s) .
docker build --file demo2.Dockerfile --target build --tag sophher/cncf-docker:demo2 .
docker push sophher/cncf-docker:demo2
docker run --name demo2 -d -p 8080:80 sophher/cncf-docker:demo2
curl http://localhost:8080
docker stop demo2
docker rm demo2
```

## Demo 3 - Mounts

```bash
docker login
docker build --file demo3.Dockerfile --target lint --output type=cacheonly --build-arg CACHE_BUST=$(date +%s) .
docker build --file demo3.Dockerfile --target test --output type=local,dest=coverage --build-arg CACHE_BUST=$(date +%s) .
docker build --file demo3.Dockerfile --target build --tag sophher/cncf-docker:demo3 .
docker push sophher/cncf-docker:demo3
docker run --name demo3 -d -p 8080:80 sophher/cncf-docker:demo3
curl http://localhost:8080
docker stop demo3
docker rm demo3
```

## Demo 4 - Buildx

```bash
docker login
docker buildx bake -f demo4.bake.hcl
docker push sophher/cncf-docker:demo4
docker run --name demo4 -d -p 8080:80 sophher/cncf-docker:demo4
curl http://localhost:8080
docker stop demo4
docker rm demo4
```

## Demo 5 - Docker Build Cloud

Setup:
- Download buildx binary from https://github.com/docker/buildx/releases/ as per your OS architecture
- Rename the binary to `docker-buildx`
- Place the binary in the below path :`~/.docker/cli-plugins`
- Give the binary execute rights: `chmod a+x ~/.docker/cli-plugins/docker-buildx`


```bash
docker login
docker buildx create --driver cloud sophher/cncf-docker
docker buildx bake --builder cloud-sophher-cncf-docker -f demo5.bake.hcl
docker push sophher/cncf-docker:demo5
docker run --name demo5 -d -p 8080:80 sophher/cncf-docker:demo5
curl http://localhost:8080
docker stop demo5
docker rm demo5
```

## Demo 6 - Docker Build Cloud + GitHub Actions

Setup:
- Enable CI/CD in GitHub
- Generate PAT Token in Docker Build Cloud
- Set Username + PAT Token