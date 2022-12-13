package com.hiperium.city.timer.api.resources;

import com.hiperium.city.timer.api.model.Task;
import com.hiperium.city.timer.api.repository.JobsRepository;
import com.hiperium.city.timer.api.repository.TasksRepository;
import com.hiperium.city.timer.api.utils.ResourcesPath;
import com.hiperium.city.timer.api.utils.TasksUtils;
import io.quarkus.security.Authenticated;
import io.smallrye.mutiny.Uni;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.jboss.logging.Logger;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Objects;

import static javax.ws.rs.core.Response.Status.*;

@Authenticated
@Transactional
@ApplicationScoped
@Path(ResourcesPath.TASK)
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TaskResource {

    private static final Logger LOGGER = Logger.getLogger(TaskResource.class.getName());

    @ConfigProperty(name = "time.zone.id")
    String zoneId;

    @Inject
    JobsRepository jobsRepository;

    @Inject
    TasksRepository tasksRepository;

    @POST
    public Uni<Response> create(Task newTask) {
        LOGGER.debug("create() - START: " + newTask);
        if (Objects.isNull(newTask) || Objects.nonNull(newTask.getId())) {
            throw new WebApplicationException(
                    "Resource was not set properly for this request.", BAD_REQUEST);
        }
        return this.jobsRepository.create(newTask)
                .onItem().ifNotNull()
                .invoke(task -> {
                    newTask.setCreatedAt(ZonedDateTime.now(ZoneId.of(this.zoneId)));
                    newTask.setUpdatedAt(newTask.getCreatedAt());
                    this.tasksRepository.persist(newTask);
                })
                .map(createdTask -> Response.status(CREATED).entity(createdTask).build());
    }

    @GET
    @Path("{id}")
    public Uni<Response> find(Long id) {
        LOGGER.debug("find() - START: " + id);
        return Uni.createFrom().item(this.tasksRepository.findById(id))
                .onItem().ifNotNull().transform(entity -> Response.ok(entity).build())
                .onItem().ifNull().continueWith(Response.ok().status(NOT_FOUND)::build);
    }

    @PUT
    @Path("{id}")
    public Uni<Response> update(Long id, Task updatedJobTask) {
        LOGGER.debug("update() - START: " + updatedJobTask);
        if (Objects.isNull(id) || id <= 0L || Objects.isNull(updatedJobTask)) {
            throw new WebApplicationException(
                    "Resource attributes was not set properly on the request.", BAD_REQUEST);
        }
        return Uni.createFrom()
                .item(this.tasksRepository.findById(id))
                .onItem().ifNull().failWith(new WebApplicationException("Task missing from database.", NOT_FOUND))
                .onItem().ifNotNull()
                .call(entity -> this.jobsRepository.update(updatedJobTask))
                .invoke(registeredTask -> {
                    updatedJobTask.setUpdatedAt(ZonedDateTime.now(ZoneId.of(this.zoneId)));
                    TasksUtils.copyMutableProperties(updatedJobTask, registeredTask);
                })
                .map(taskUpdated -> Response.status(OK).entity(taskUpdated).build());
    }

    @DELETE
    @Path("{id}")
    public Uni<Response> delete(Long id) {
        LOGGER.debug("delete() - START: " + id);
        if (Objects.isNull(id) || id <= 0L) {
            throw new WebApplicationException(
                    "Resource ID was not set properly on the request.", BAD_REQUEST);
        }
        return Uni.createFrom()
                .item(this.tasksRepository.findById(id))
                .onItem().ifNull().failWith(new WebApplicationException("Task missing from database.", NOT_FOUND))
                .onItem().ifNotNull()
                .call(entity -> this.jobsRepository.delete(entity))
                .invoke(actualTask -> this.tasksRepository.deleteById(id))
                .map(taskUpdated -> Response.status(NO_CONTENT).build());
    }
}
