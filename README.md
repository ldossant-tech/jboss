# API de Produtos - JBoss/WildFly + PostgreSQL

Esta é uma API REST completa desenvolvida com JBoss/WildFly e PostgreSQL, utilizando podman-compose para orquestração dos containers.

## 🚀 Características

- **Framework**: JBoss/WildFly (Jakarta EE)
- **Banco de dados**: PostgreSQL 15
- **Documentação**: Swagger/OpenAPI 3
- **Orquestração**: Podman Compose
- **Endpoints**: Inserir e consultar produtos

## 📋 Pré-requisitos

- Podman
- Podman Compose

## 🛠️ Como executar

1. **Clone ou baixe o projeto**
2. **Navegue até o diretório do projeto**
   ```bash
   cd jboss-api-project
   ```

3. **Execute o podman-compose**
   ```bash
   podman-compose up --build
   ```

4. **Aguarde a inicialização** (pode levar alguns minutos na primeira execução)

5. **Acesse a aplicação**
   - Interface principal: http://localhost:8080/jboss-api
   - API OpenAPI JSON: http://localhost:8080/jboss-api/swagger
   - Swagger UI: https://petstore.swagger.io/?url=http://localhost:8080/jboss-api/swagger

## 📡 Endpoints da API

### Listar todos os produtos
```http
GET /api/produtos
```

### Criar novo produto
```http
POST /api/produtos
Content-Type: application/json

{
  "nome": "Nome do Produto",
  "preco": 99.99,
  "descricao": "Descrição do produto"
}
```

### Buscar produto por ID
```http
GET /api/produtos/{id}
```

## 🧪 Testando a API

### Usando curl

**Listar produtos:**
```bash
curl -X GET http://localhost:8080/jboss-api/api/produtos
```

**Criar produto:**
```bash
curl -X POST http://localhost:8080/jboss-api/api/produtos \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Smartphone Samsung",
    "preco": 1299.99,
    "descricao": "Smartphone Samsung Galaxy A54"
  }'
```

**Buscar produto por ID:**
```bash
curl -X GET http://localhost:8080/jboss-api/api/produtos/1
```

## 🗄️ Banco de Dados

O banco PostgreSQL é inicializado automaticamente com:
- **Database**: apidb
- **Usuário**: apiuser
- **Senha**: apipass
- **Porta**: 5432

A tabela `produtos` é criada automaticamente com alguns dados de exemplo.

## 🏗️ Estrutura do Projeto

```
jboss-api-project/
├── src/main/java/com/example/api/
│   ├── config/          # Configurações JAX-RS e CORS
│   ├── entity/          # Entidades JPA
│   └── resource/        # Recursos REST
├── src/main/resources/
│   └── META-INF/        # Configuração JPA
├── src/main/webapp/     # Recursos web
├── docker/              # Scripts Docker
├── pom.xml              # Dependências Maven
├── Dockerfile           # Imagem da aplicação
└── podman-compose.yml   # Orquestração dos serviços
```

## 🔧 Tecnologias Utilizadas

- **JBoss/WildFly 27**: Servidor de aplicação Jakarta EE
- **JAX-RS**: Framework REST
- **JPA/Hibernate**: Mapeamento objeto-relacional
- **PostgreSQL**: Banco de dados relacional
- **Swagger/OpenAPI**: Documentação da API
- **Maven**: Gerenciamento de dependências
- **Podman**: Containerização

## 📝 Notas

- A aplicação aguarda automaticamente o PostgreSQL estar disponível antes de inicializar
- O datasource é configurado automaticamente durante a inicialização
- CORS está habilitado para permitir requisições de qualquer origem
- A aplicação inclui validação básica dos dados de entrada

## 🛑 Parar a aplicação

```bash
podman-compose down
```

Para remover também os volumes:
```bash
podman-compose down -v
```

