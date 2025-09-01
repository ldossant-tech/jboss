# Usar imagem base do WildFly (JBoss)
FROM quay.io/wildfly/wildfly:27.0.1.Final-jdk11

# Definir usuário como root para instalações
USER root

# Instalar Maven e wget
RUN microdnf install -y maven wget && microdnf clean all

# Baixar driver PostgreSQL
RUN wget -O /opt/jboss/wildfly/postgresql-42.6.0.jar https://jdbc.postgresql.org/download/postgresql-42.6.0.jar

# Criar diretório de trabalho
WORKDIR /opt/app

# Copiar arquivos do projeto
COPY pom.xml .
COPY src ./src

# Compilar a aplicação
RUN mvn clean package -DskipTests

# Copiar o WAR para o diretório de deployments do WildFly
RUN cp target/jboss-api.war /opt/jboss/wildfly/standalone/deployments/

# Copiar script de inicialização
COPY docker/start-wildfly.sh /opt/jboss/wildfly/bin/
RUN chmod +x /opt/jboss/wildfly/bin/start-wildfly.sh

# Voltar para o usuário jboss
USER jboss

# Expor porta 8080
EXPOSE 8080

# Comando para iniciar o WildFly com configuração
CMD ["/opt/jboss/wildfly/bin/start-wildfly.sh"]

