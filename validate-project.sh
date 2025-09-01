#!/bin/bash

echo "🔍 Validando estrutura do projeto JBoss API..."
echo "=============================================="

# Verificar arquivos principais
files=(
    "pom.xml"
    "Dockerfile"
    "docker-compose.yml"
    "podman-compose.yml"
    "README.md"
    "src/main/java/com/example/api/entity/Produto.java"
    "src/main/java/com/example/api/resource/ProdutoResource.java"
    "src/main/java/com/example/api/config/RestApplication.java"
    "src/main/java/com/example/api/config/CorsFilter.java"
    "src/main/resources/META-INF/persistence.xml"
    "src/main/webapp/WEB-INF/web.xml"
    "src/main/webapp/index.html"
    "docker/init-db.sql"
    "docker/start-wildfly.sh"
)

missing_files=0

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (FALTANDO)"
        missing_files=$((missing_files + 1))
    fi
done

echo ""
echo "📊 Resumo da validação:"
echo "----------------------"
echo "Total de arquivos verificados: ${#files[@]}"
echo "Arquivos encontrados: $((${#files[@]} - missing_files))"
echo "Arquivos faltando: $missing_files"

if [ $missing_files -eq 0 ]; then
    echo ""
    echo "🎉 Projeto validado com sucesso!"
    echo "📋 Para executar o projeto:"
    echo "   1. Certifique-se de ter podman ou docker instalado"
    echo "   2. Execute: podman-compose up --build"
    echo "   3. Ou execute: docker-compose up --build"
    echo "   4. Acesse: http://localhost:8080/jboss-api"
else
    echo ""
    echo "⚠️  Projeto incompleto. Verifique os arquivos faltando."
fi

echo ""
echo "📚 Documentação completa disponível no README.md"

