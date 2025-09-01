package com.example.api.resource;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

@Path("/swagger-ui")
public class SwaggerUiResource {

    private static final String UI_ROOT = "/META-INF/resources/webjars/swagger-ui/5.11.10/";

    @GET
    @Produces(MediaType.TEXT_HTML)
    public Response getIndex() throws IOException {
        try (InputStream is = getResource("index.html")) {
            if (is == null) {
                return Response.status(Response.Status.NOT_FOUND).build();
            }
            String html = new String(is.readAllBytes(), StandardCharsets.UTF_8)
                    .replace("https://petstore.swagger.io/v2/swagger.json", "../openapi.json");
            return Response.ok(html).build();
        }
    }

    @GET
    @Path("{path:.*}")
    public Response getAsset(@PathParam("path") String path) throws IOException {
        try (InputStream is = getResource(path)) {
            if (is == null) {
                return Response.status(Response.Status.NOT_FOUND).build();
            }
            return Response.ok(is, contentType(path)).build();
        }
    }

    private InputStream getResource(String name) {
        return getClass().getResourceAsStream(UI_ROOT + name);
    }

    private String contentType(String path) {
        if (path.endsWith(".js")) return "application/javascript";
        if (path.endsWith(".css")) return "text/css";
        if (path.endsWith(".html")) return "text/html";
        if (path.endsWith(".png")) return "image/png";
        if (path.endsWith(".svg")) return "image/svg+xml";
        if (path.endsWith(".json")) return MediaType.APPLICATION_JSON;
        return MediaType.APPLICATION_OCTET_STREAM;
    }
}
