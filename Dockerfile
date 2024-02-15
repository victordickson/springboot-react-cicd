# Stage 1: Use a base image with JDK for building Java applications
FROM maven:3.8.4-jdk-11 AS build

# Set working directory
WORKDIR /app

# Copy the entire project directory to the working directory
COPY . .

# Download dependencies if any changes in pom.xml
RUN mvn clean package

# Stage 2: Create the final image with Spring Boot and React build
FROM adoptopenjdk:11-jre-hotspot

# Set working directory
WORKDIR /app

# Copy the compiled Java Spring Boot application
COPY --from=build /app/target/*.jar app.jar

# Expose the port on which the Spring Boot application will run
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
