# syntax=docker/dockerfile:1
FROM openjdk:22-jdk-slim
WORKDIR /app
COPY target/spring-boot-rest-api-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
