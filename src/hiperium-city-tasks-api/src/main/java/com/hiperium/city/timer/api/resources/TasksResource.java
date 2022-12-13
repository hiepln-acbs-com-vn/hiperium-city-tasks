package com.hiperium.city.timer.api.resources;

import com.hiperium.city.timer.api.model.Task;
import com.hiperium.city.timer.api.repository.TasksRepository;
import com.hiperium.city.timer.api.utils.ResourcesPath;
import io.quarkus.security.Authenticated;
import org.jboss.logging.Logger;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.List;

@Authenticated
@ApplicationScoped
@Path(ResourcesPath.TASKS)
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TasksResource {

    private static final Logger LOGGER = Logger.getLogger(TasksResource.class.getName());

    @Inject
    TasksRepository tasksRepository;

    @GET
    public List<Task> findAll() {
        LOGGER.debug("findAll() - START");
        return this.tasksRepository.listAll();
    }
}
