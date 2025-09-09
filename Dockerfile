# Stage 1: Build Flutter web app
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app

# Cache dependencies first
COPY pubspec.yaml melos.yaml ./
COPY packages ./packages
COPY apps/app/pubspec.yaml ./apps/app/pubspec.yaml
RUN flutter config --enable-web
RUN dart pub get --directory=packages/core || true
RUN dart pub get --directory=packages/ui || true
RUN dart pub get --directory=packages/api_client || true
RUN dart pub get --directory=apps/app

# Copy rest of the source
COPY . .

# Build web with env
ARG ENCRYPTION_SALT
WORKDIR /app/apps/app
RUN echo "ENCRYPTION_SALT=${ENCRYPTION_SALT}" > .env.docker \
    && flutter build web --release --dart-define-from-file=.env.docker

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/apps/app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


