package com.example.api.resource;

import com.example.api.entity.Produto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Stateless
@Path("/produtos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Tag(name = "Produtos", description = "Operações relacionadas aos produtos")
public class ProdutoResource {
    
    @PersistenceContext(unitName = "primary")
    private EntityManager em;
    
    @POST
    @Operation(
        summary = "Criar novo produto",
        description = "Insere um novo produto no banco de dados"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "201",
            description = "Produto criado com sucesso",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = Produto.class)
            )
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Dados inválidos fornecidos"
        )
    })
    public Response criarProduto(
        @Parameter(description = "Dados do produto a ser criado", required = true)
        Produto produto
    ) {
        try {
            if (produto.getNome() == null || produto.getNome().trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"erro\": \"Nome do produto é obrigatório\"}")
                    .build();
            }
            
            if (produto.getPreco() == null || produto.getPreco().signum() <= 0) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"erro\": \"Preço deve ser maior que zero\"}")
                    .build();
            }
            
            em.persist(produto);
            em.flush();
            
            return Response.status(Response.Status.CREATED)
                .entity(produto)
                .build();
                
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("{\"erro\": \"Erro interno do servidor: " + e.getMessage() + "\"}")
                .build();
        }
    }
    
    @GET
    @Operation(
        summary = "Listar todos os produtos",
        description = "Retorna uma lista com todos os produtos cadastrados"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Lista de produtos retornada com sucesso",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = Produto.class)
            )
        )
    })
    public Response listarProdutos() {
        try {
            TypedQuery<Produto> query = em.createQuery("SELECT p FROM Produto p ORDER BY p.id", Produto.class);
            List<Produto> produtos = query.getResultList();
            
            return Response.ok(produtos).build();
            
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("{\"erro\": \"Erro interno do servidor: " + e.getMessage() + "\"}")
                .build();
        }
    }
    
    @GET
    @Path("/{id}")
    @Operation(
        summary = "Buscar produto por ID",
        description = "Retorna um produto específico pelo seu ID"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Produto encontrado",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = Produto.class)
            )
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Produto não encontrado"
        )
    })
    public Response buscarProduto(
        @Parameter(description = "ID do produto", required = true)
        @PathParam("id") Long id
    ) {
        try {
            Produto produto = em.find(Produto.class, id);
            
            if (produto == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"erro\": \"Produto não encontrado\"}")
                    .build();
            }
            
            return Response.ok(produto).build();
            
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("{\"erro\": \"Erro interno do servidor: " + e.getMessage() + "\"}")
                .build();
        }
    }
}

