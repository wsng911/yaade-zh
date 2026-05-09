# ---- Stage 1: Build frontend ----
FROM node:18-alpine AS frontend-builder

WORKDIR /app/client

COPY client/.npmrc ./
COPY client/package*.json ./
RUN npm install

COPY client/ ./
RUN npm run build

# ---- Stage 2: Build backend (Kotlin/Gradle) ----
FROM gradle:8.5-jdk17 AS backend-builder

WORKDIR /app

COPY server/ ./server/
COPY --from=frontend-builder /app/client/dist ./server/src/main/resources/webroot

WORKDIR /app/server
RUN gradle clean build -x test --no-daemon

# ---- Stage 3: Runtime ----
FROM amazoncorretto:17-alpine

WORKDIR /app

RUN mkdir -p /app/data

COPY --from=backend-builder /app/server/build/libs/dependencies/*.jar /app/libs/
COPY --from=backend-builder /app/server/build/resources/main /app/resources
COPY --from=backend-builder /app/server/build/classes/kotlin/main /app/classes
COPY --from=backend-builder /app/server/build/classes/java/main /app/classes
COPY --from=backend-builder /app/server/build/libs/*.jar /app/libs/

ENV CLASSPATH=/app/classes:/app/resources:/app/libs/*
ENV YAADE_HEAP_SIZE=""

ENV TZ=Asia/Shanghai
EXPOSE 9339

ENTRYPOINT ["sh", "-c", "if [ -z \"$YAADE_HEAP_SIZE\" ]; then java com.espero.yaade.MainKt; else java -Xmx${YAADE_HEAP_SIZE} com.espero.yaade.MainKt; fi"]
