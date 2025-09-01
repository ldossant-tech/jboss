# ============================
# Etapa 1: Build da aplicação
# ============================
FROM maven:3.9.6-eclipse-temurin-11 AS build

# Diretório de trabalho
WORKDIR /app

# Copiar arquivos do projeto
COPY pom.xml .
COPY src ./src

# Compilar a aplicação (sem rodar testes)
RUN mvn clean package -DskipTests


# ============================
# Etapa 2: Imagem final WildFly
# ============================
FROM quay.io/wildfly/wildfly:27.0.1.Final-jdk11

# Copiar WAR gerado do estágio build para o deployments do WildFly
COPY --from=build /app/target/jboss-api.war /opt/jboss/wildfly/standalone/deployments/

# Baixar driver PostgreSQL
USER root
RUN curl -L -o /opt/jboss/wildfly/postgresql-42.6.0.jar https://jdbc.postgresql.org/download/postgresql-42.6.0.jar \
    && chmod 644 /opt/jboss/wildfly/postgresql-42.6.0.jar
USER jboss

# Copiar script de inicialização
COPY docker/start-wildfly.sh /opt/jboss/wildfly/bin/
USER root
RUN chmod +x /opt/jboss/wildfly/bin/start-wildfly.sh
USER jboss

# Expor porta
EXPOSE 8080

# Comando para iniciar o servidor (shell form para podman-compose)
CMD /opt/jboss/wildfly/bin/start-wildfly.sh
