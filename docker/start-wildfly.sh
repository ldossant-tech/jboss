#!/bin/bash
set -e

# Aguardar PostgreSQL estar disponível
echo "Aguardando PostgreSQL..."
until (echo > /dev/tcp/postgres/5432) >/dev/null 2>&1; do
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

# Adicionar módulo PostgreSQL (ignora erro se já existir)
if ! /opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="module info org.postgresql" >/dev/null 2>&1; then
  /opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="module add --name=org.postgresql --resources=/opt/jboss/wildfly/postgresql-42.6.0.jar --dependencies=jakarta.api,javax.transaction.api"
fi

# Adicionar driver PostgreSQL (ignora se já existe)
if ! /opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="/subsystem=datasources/jdbc-driver=postgresql:read-resource" >/dev/null 2>&1; then
  /opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="/subsystem=datasources/jdbc-driver=postgresql:add(driver-name=postgresql,driver-module-name=org.postgresql,driver-class-name=org.postgresql.Driver)"
fi

# Adicionar datasource (ignora se já existe)
/opt/jboss/wildfly/bin/jboss-cli.sh --connect <<'EOF'
if (outcome != success) of /subsystem=datasources/data-source=PostgreSQLDS:read-resource
  data-source add --jndi-name=java:jboss/datasources/PostgreSQLDS --name=PostgreSQLDS --connection-url=jdbc:postgresql://postgres:5432/apidb --driver-name=postgresql --user-name=apiuser --password=apipass --validate-on-match=true --background-validation=false --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter
end-if
EOF

# Habilitar datasource
/opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="data-source enable --name=PostgreSQLDS"

echo "Datasource configurado com sucesso!"

# Realizar deploy da aplicação após configuração do datasource
echo "Realizando deploy da aplicação..."
/opt/jboss/wildfly/bin/jboss-cli.sh --connect --command="deploy /opt/jboss/wildfly/jboss-api.war"
echo "Aplicação deployada com sucesso!"

# Aguardar o processo do WildFly
wait $WILDFLY_PID
