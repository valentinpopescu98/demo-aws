# Stage 1: Build app
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Run app on a small image
FROM eclipse-temurin:17-jdk-alpine

# Set environment variables for IMDSv2 (metadata endpoint and token)
ENV AWS_METADATA_SERVICE_ENDPOINT="http://169.254.169.254"
ENV AWS_METADATA_SERVICE_TIMEOUT="5s"
ENV AWS_EC2_METADATA_DISABLED="false"

VOLUME /tmp
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]