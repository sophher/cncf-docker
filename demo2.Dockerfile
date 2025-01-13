FROM nginx:1.27.3 AS nginx
FROM cypress/browsers:22.13.0 AS browsers

FROM browsers AS base
RUN npm install -g pnpm@latest-10
WORKDIR /usr/app
COPY . .
RUN pnpm install --frozen-lockfile

FROM base AS tester
RUN pnpm run test

FROM scratch AS test
COPY --from=tester /usr/app/coverage .

FROM base AS builder
RUN pnpm run build

FROM nginx AS build
COPY --from=builder /usr/app/dist/cncf-docker/browser /usr/share/nginx/html
