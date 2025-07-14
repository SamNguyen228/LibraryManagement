# ===== Step 1: Build React (Vite) =====
FROM node:20-alpine AS frontend
WORKDIR /app

# Copy only package files for caching
COPY package*.json ./
RUN npm install

# Copy source code (bao gồm Vite + backend folder)
COPY . .

# Build frontend (React + Vite)
RUN npm run build

# ===== Step 2: Build Spring Boot backend =====
FROM maven:3.9.4-eclipse-temurin-17 AS backend
WORKDIR /backend
COPY backend /backend
RUN mvn clean package -DskipTests

# ===== Step 3: Final image =====
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy backend jar
COPY --from=backend /backend/target/*.jar app.jar

# Copy React Vite build into public folder
COPY --from=frontend /app/dist /app/public

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
