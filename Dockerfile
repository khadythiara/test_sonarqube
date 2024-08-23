# Étape 1 : Utiliser une image Maven officielle pour construire le projet
FROM maven:3.8.6-eclipse-temurin-17 AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers pom.xml et télécharger les dépendances Maven
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le reste des fichiers du projet et construire l'application
COPY src ./src
RUN mvn package -DskipTests

# Étape 2 : Utiliser une image Java légère pour exécuter l'application
FROM eclipse-temurin:17-jdk-jammy

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier JAR généré depuis l'étape de build
COPY --from=build /app/target/*.jar app.jar

# Exposer le port sur lequel l'application écoute
EXPOSE 8022

# Démarrer l'application Java
ENTRYPOINT ["java", "-jar", "app.jar"]
