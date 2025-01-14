FROM nginx:1.27.3 AS nginx
FROM cypress/browsers:22.13.0 AS browsers

FROM browsers AS base
RUN corepack enable && \
    pnpm config set store-dir /root/.local/share/pnpm
WORKDIR /usr/app
COPY . .
RUN pnpm install --frozen-lockfile

ARG CACHE_BUST
FROM base AS lint
RUN pnpm run lint

ARG CACHE_BUST
FROM base AS tester
RUN pnpm run test

FROM scratch AS test
COPY --from=tester /usr/app/coverage .

FROM base AS builder
RUN pnpm run build

FROM nginx AS build
COPY --from=builder /usr/app/dist/cncf-docker/browser /usr/share/nginx/html
