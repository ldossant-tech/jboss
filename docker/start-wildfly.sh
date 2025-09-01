#!/bin/bash

# Aguardar PostgreSQL estar disponível
echo "Aguardando PostgreSQL..."
while ! nc -z postgres 5432; do
  sleep 1
done
echo "PostgreSQL está disponível!"

# Iniciar WildFly em background
/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 &
WILDFLY_PID=$!

# Aguardar WildFly inicializar
echo "Aguardando WildFly inicializar..."
sleep 30

# Configurar datasource PostgreSQL
echo "Configurando datasource PostgreSQL..."

# Adicionar módulo PostgreSQL
/opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="module add --name=org.postgresql --resources=/opt/jboss/wildfly/postgresql-42.6.0.jar --dependencies=javax.api,javax.transaction.api"

# Adicionar driver PostgreSQL
/opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="/subsystem=datasources/jdbc-driver=postgresql:add(driver-name=\"postgresql\",driver-module-name=\"org.postgresql\",driver-class-name=org.postgresql.Driver)"

# Adicionar datasource
/opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="data-source add --jndi-name=java:jboss/datasources/PostgreSQLDS --name=PostgreSQLDS --connection-url=jdbc:postgresql://postgres:5432/apidb --driver-name=postgresql --user-name=apiuser --password=apipass --validate-on-match=true --background-validation=false --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter"

# Habilitar datasource
/opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="data-source enable --name=PostgreSQLDS"

echo "Datasource configurado com sucesso!"

# Aguardar o processo do WildFly
wait $WILDFLY_PID

