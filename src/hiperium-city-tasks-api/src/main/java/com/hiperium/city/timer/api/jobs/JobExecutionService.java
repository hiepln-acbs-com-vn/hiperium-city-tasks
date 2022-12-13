package com.hiperium.city.timer.api.jobs;

import com.hiperium.city.timer.api.model.Task;
import com.hiperium.city.timer.api.utils.JobsUtils;
import com.hiperium.city.timer.api.repository.TasksRepository;
import io.quarkus.runtime.annotations.RegisterForReflection;
import org.jboss.logging.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import javax.inject.Inject;
import java.util.Objects;

/**
 * @author Andres Solorzano
 */
@RegisterForReflection
public class JobExecutionService implements Job {

    private static final Logger LOGGER = Logger.getLogger(JobExecutionService.class.getName());

    @Inject
    TasksRepository tasksRepository;

    public JobExecutionService() {
        // Nothing to implement
    }

    @Override
    public void execute(JobExecutionContext executionContext) {
        LOGGER.info("execute() - START");
        String jobId = (String) executionContext.getJobDetail().getJobDataMap().get(JobsUtils.TASK_JOB_ID_DATA_KEY);
        if (Objects.isNull(jobId) || jobId.isEmpty()) {
            LOGGER.error("execute() - The Job ID is NULL in the Execution Context.");
        } else {
            LOGGER.info("execute() - The Job ID to execute: " + jobId);
            Task task = this.tasksRepository.findByJobId(jobId);
            if (Objects.isNull(task)) {
                LOGGER.error("execute() - Task not found with Job ID: " + jobId);
            } else {
                LOGGER.info("execute() - Task executed successfully: " + task.getId());
            }
        }
    }
}
