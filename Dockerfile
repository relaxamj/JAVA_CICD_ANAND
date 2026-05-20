FROM eclipse-temurin:11

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 5001

CMD ["java","-jar","app.jar"]
