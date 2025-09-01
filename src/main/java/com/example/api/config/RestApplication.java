package com.example.api.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.servers.Server;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;
import java.util.HashSet;
import java.util.Set;

@ApplicationPath("/api")
@OpenAPIDefinition(
    info = @Info(
        title = "API de Produtos",
        version = "1.0.0",
        description = "API REST para gerenciamento de produtos com JBoss e PostgreSQL"
    ),
    servers = {
        @Server(url = "http://localhost:8080/jboss-api/api", description = "Servidor Local")
    }
)
public class RestApplication extends Application {
    
    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> classes = new HashSet<>();
        classes.add(com.example.api.resource.ProdutoResource.class);
        
        // Adicionar classes do Swagger
        classes.add(io.swagger.v3.jaxrs2.integration.resources.OpenApiResource.class);
        classes.add(io.swagger.v3.jaxrs2.integration.resources.AcceptHeaderOpenApiResource.class);
        
        return classes;
    }
}

