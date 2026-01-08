Simple Java App → Docker → Kubernetes (Step by Step)

java -version
mvn -version
docker --version
kubectl version --client


Kubernetes options (any one):

minikube (recommended)

Docker Desktop (K8s enabled)

kind

🔹 STEP 1: Create Simple Java Application
1️⃣ Create project structure
mkdir java-docker-k8s
cd java-docker-k8s
mkdir -p src/main/java

2️⃣ Create Java file
nano src/main/java/App.java

public class App {
    public static void main(String[] args) {
        System.out.println("Hello from Java Docker Kubernetes App");
        try {
            Thread.sleep(1000000); // keep app running
        } catch (Exception e) {}
    }
}

🔹 STEP 2: Create pom.xml (Maven Build)
nano pom.xml

<project xmlns="http://maven.apache.org/POM/4.0.0">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.example</groupId>
  <artifactId>java-app</artifactId>
  <version>1.0</version>

  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
          <source>11</source>
          <target>11</target>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>

🔹 STEP 3: Build Java App Locally
mvn clean package


✔ This creates the target/ folder
✔ Confirms Java app is working

🔹 STEP 4: Create Dockerfile
nano Dockerfile

FROM openjdk:11
WORKDIR /app
COPY target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]

🔹 STEP 5: Build & Run Docker Image
docker build -t java-k8s-app .
docker run -d --name java-app java-k8s-app


Check logs:

docker logs java-app


✔ If you see the message → Docker part done ✅

🔹 STEP 6: Start Kubernetes (Minikube)
minikube start

🔹 STEP 7: Create Kubernetes Deployment YAML
nano deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: java-app
  template:
    metadata:
      labels:
        app: java-app
    spec:
      containers:
        - name: java-app
          image: java-k8s-app
          imagePullPolicy: IfNotPresent


📌 imagePullPolicy: IfNotPresent is important for local images.

🔹 STEP 8: Create Kubernetes Service YAML
nano service.yml

apiVersion: v1
kind: Service
metadata:
  name: java-service
spec:
  type: NodePort
  selector:
    app: java-app
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30007

🔹 STEP 9: Deploy to Kubernetes
kubectl apply -f deployment.yml
kubectl apply -f service.yml


Check:

kubectl get pods
kubectl get svc

🔹 STEP 10: Access the Application
minikube ip


Open browser:

http://<minikube-ip>:30007


✔ App deployed on Kubernetes 🎉
