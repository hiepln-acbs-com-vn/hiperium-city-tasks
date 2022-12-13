package com.hiperium.city.timer.api.repository;

import com.hiperium.city.timer.api.model.Task;
import io.quarkus.hibernate.orm.panache.PanacheRepository;

import javax.enterprise.context.ApplicationScoped;
import javax.transaction.Transactional;

@ApplicationScoped
public class TasksRepository implements PanacheRepository<Task> {

    @Transactional
    public Task findByJobId(String jobId) {
        return find("jobId", jobId).firstResult();
    }
}
