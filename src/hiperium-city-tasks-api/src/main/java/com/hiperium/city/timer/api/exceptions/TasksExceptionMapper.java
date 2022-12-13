package com.hiperium.city.timer.api.exceptions;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.jboss.logging.Logger;

import javax.inject.Inject;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;
import java.util.Objects;

/**
 * Create an HTTP response from an exception.
 * <p>
 * Response Example:
 *
 * <pre>
 *     HTTP/1.1 422 Unprocessable Entity
 *     Content-Length: 111
 *     Content-Type: application/json
 *     {
 *         "code": 422,
 *         "error": "Task ID was not set on request.",
 *         "exceptionType": "javax.ws.rs.WebApplicationException"
 *      }
 * </pre>
 */
@Provider
public class TasksExceptionMapper implements ExceptionMapper<Exception> {

    private static final Logger LOGGER = Logger.getLogger(TasksExceptionMapper.class.getName());

    @Inject
    ObjectMapper objectMapper;

    @Override
    public Response toResponse(Exception exception) {
        LOGGER.debug("Failed to handle request: " + exception.getMessage());
        int code = 500;
        if (exception instanceof WebApplicationException) {
            WebApplicationException webApplicationException = (WebApplicationException) exception;
            code = webApplicationException.getResponse().getStatus();
        }
        ObjectNode exceptionJson = objectMapper.createObjectNode();
        exceptionJson.put("exceptionType", ((Throwable) exception).getClass().getName());
        exceptionJson.put("code", code);
        if (Objects.nonNull(exception.getMessage())) {
            exceptionJson.put("error", exception.getMessage());
        }
        return Response.status(code)
                .entity(exceptionJson)
                .build();
    }
}
