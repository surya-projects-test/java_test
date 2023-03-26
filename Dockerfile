# Start with a base image containing Java runtime
FROM openjdk:11-jre-slim

# Set the working directory to /app
WORKDIR /app

# Copy the executable JAR file from the target directory into the container
COPY target/my-test-app.jar /app/test.jar

# Expose port 8080 for the Spring Boot application
EXPOSE 8080

# Run the application when the container starts
CMD ["java", "-jar", "test.jar"]

