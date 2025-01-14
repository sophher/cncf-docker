FROM nginx:1.27.3 AS nginx
FROM cypress/browsers:22.13.0 AS browsers

FROM browsers AS base
EXPOSE 4200
RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm \
    corepack enable && \
    pnpm config set store-dir /root/.local/share/pnpm

ARG CACHE_BUST
FROM base AS lint
WORKDIR /usr/src
RUN --mount=type=bind,source=.,target=/usr/src,rw \
    --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm \
    --mount=type=cache,id=angular,target=/usr/src/.angular \
    pnpm install --frozen-lockfile &&  \
    pnpm run lint

ARG CACHE_BUST
FROM base AS tester
WORKDIR /usr/src
RUN --mount=type=bind,source=.,target=/usr/src,rw \
    --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm \
    --mount=type=cache,id=angular,target=/usr/src/.angular \
    pnpm install --frozen-lockfile && \
    pnpm run test && \
    mkdir -p /usr/app/coverage && \
    cp -a /usr/src/coverage /usr/app

FROM scratch AS test
COPY --from=tester /usr/app/coverage .

FROM base AS builder
WORKDIR /usr/src
RUN --mount=type=bind,source=.,target=/usr/src,rw \
    --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm \
    --mount=type=cache,id=angular,target=/usr/src/.angular \
    pnpm install --frozen-lockfile && \
    pnpm run build && \
    mkdir -p /usr/app/dist && \
    cp -a /usr/src/dist /usr/app

FROM nginx AS build
COPY --from=builder /usr/app/dist/cncf-docker/browser /usr/share/nginx/html

