package com.hiperium.city.timer.api.repository;

import com.hiperium.city.timer.api.model.Task;
import com.hiperium.city.timer.api.utils.JobsUtils;
import com.hiperium.city.timer.api.utils.TasksUtils;
import io.smallrye.mutiny.Uni;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.jboss.logging.Logger;
import org.quartz.*;
import org.quartz.impl.matchers.GroupMatcher;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.util.Date;
import java.util.Objects;

/**
 * @author Andres Solorzano
 */
@ApplicationScoped
public class JobsRepository {

    private static final Logger LOGGER = Logger.getLogger(JobsRepository.class.getName());

    @ConfigProperty(name = "time.zone.id")
    String zoneId;

    @Inject
    Scheduler scheduler;

    public Uni<Task> create(final Task task) {
        return Uni.createFrom().emitter(emitter -> {
            try {
                this.createAndScheduleJob(task);
                LOGGER.info("Successfully created Job for Task name: " + task.getName());
                emitter.complete(task);
            } catch (SchedulerException e) {
                LOGGER.error("Error trying to schedule the Job for Task name: " + task.getName(), e);
                emitter.fail(new UnsupportedOperationException(e.getMessage()));
            }
        });
    }

    public Uni<Task> update(final Task task) {
        return Uni.createFrom().emitter(emitter -> {
            try {
                Trigger actualTrigger = this.getCurrentTrigger(task);
                if (Objects.isNull(actualTrigger)) {
                    LOGGER.warn("Task Trigger not found. Creating a new one for Task ID: " + task.getId());
                    this.createAndScheduleJob(task);
                } else {
                    LOGGER.debug("Actual trigger to update: " + actualTrigger);
                    Trigger newTrigger = JobsUtils.createCronTriggerFromTask(task, this.zoneId);
                    Date newTriggerFirstFire = this.scheduler.rescheduleJob(actualTrigger.getKey(), newTrigger);
                    if (Objects.isNull(newTriggerFirstFire)) {
                        LOGGER.error("Cannot reschedule the Trigger for the Task ID: " + task.getId());
                    } else {
                        LOGGER.info("Successfully rescheduled trigger for Task ID: " + task.getId());
                    }
                }
                emitter.complete(task);
            } catch (SchedulerException e) {
                LOGGER.error(e.getMessage(), e);
                emitter.fail(new UnsupportedOperationException(e.getMessage()));
            }
        });
    }

    public Uni<Task> delete(final Task task) {
        return Uni.createFrom().emitter(emitter -> {
            try {
                if(this.scheduler.deleteJob(JobKey.jobKey(task.getJobId(), JobsUtils.TASK_GROUP_NAME))) {
                    LOGGER.info("Successfully deleted Job for Task ID: " + task.getId());
                } else {
                    LOGGER.warn("Cannot found a Job to delete for Task ID: " + task.getId());
                }
                emitter.complete(task);
            } catch (SchedulerException e) {
                LOGGER.error(e.getMessage(), e);
                emitter.fail(new UnsupportedOperationException(e.getMessage()));
            }
        });
    }

    private void createAndScheduleJob(Task task) throws SchedulerException {
        LOGGER.debug("createAndScheduleJob() - START: " + task.getName());
        task.setJobId(TasksUtils.generateUUID(31));
        JobDetail job = JobsUtils.createJobDetailFromTask(task);
        Trigger trigger = JobsUtils.createCronTriggerFromTask(task, this.zoneId);
        // TODO: Fix error SchedulerException: Based on configured schedule, the given trigger 'Task#...' will never fire.
        this.scheduler.scheduleJob(job, trigger);
        LOGGER.debug("createAndScheduleJob() - END: " + task.getJobId());
    }

    private Trigger getCurrentTrigger(Task task) throws SchedulerException {
        LOGGER.debug("getCurrentTrigger() - START: " + task.getJobId());
        Trigger trigger = null;
        for (JobKey jobKey : this.scheduler.getJobKeys(GroupMatcher.jobGroupEquals(JobsUtils.TASK_GROUP_NAME))) {
            LOGGER.debug("Job key name: " + jobKey.getName());
            if (jobKey.getName().equals(task.getJobId())) {
                TriggerKey triggerKey = TriggerKey.triggerKey(task.getJobId(), JobsUtils.TASK_GROUP_NAME);
                trigger = this.scheduler.getTrigger(triggerKey);
            }
        }
        LOGGER.debug("getTrigger() - END: " + trigger);
        return trigger;
    }
}
