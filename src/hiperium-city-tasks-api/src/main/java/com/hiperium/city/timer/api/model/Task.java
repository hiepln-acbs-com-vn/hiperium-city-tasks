package com.hiperium.city.timer.api.model;

import javax.persistence.*;
import java.time.ZonedDateTime;

/**
 * @author Andres Solorzano
 */
@Entity
@Table(name = "HIP_CTY_TASKS")
public class Task {

    @Id
    @GeneratedValue
    private Long id;

    @Column(name = "name", length = 31, nullable = false)
    private String name;

    @Column(name = "job_id", length = 31, nullable = false)
    private String jobId;

    @Column(name = "hour", nullable = false)
    private Integer hour;

    @Column(name = "minute", nullable = false)
    private Integer minute;

    @Column(name = "execution_days", length = 127, nullable = false)
    private String executionDays;

    @Column(name = "execution_command", nullable = false)
    private String executionCommand;

    @Column(name = "execute_until")
    private ZonedDateTime executeUntil;

    @Column(name = "description")
    private String description;

    @Column(name = "created_at", nullable = false)
    private ZonedDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private ZonedDateTime updatedAt;

    public Task() {
        // Nothing to implement
    }

    public Task(String name, Integer hour, Integer minute, String executionDays,
                String executionCommand, ZonedDateTime executeUntil, String description) {
        this.name = name;
        this.hour = hour;
        this.minute = minute;
        this.executionDays = executionDays;
        this.executionCommand = executionCommand;
        this.executeUntil = executeUntil;
        this.description = description;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getJobId() {
        return jobId;
    }

    public void setJobId(String jobId) {
        this.jobId = jobId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getHour() {
        return hour;
    }

    public void setHour(Integer hour) {
        this.hour = hour;
    }

    public Integer getMinute() {
        return minute;
    }

    public void setMinute(Integer minute) {
        this.minute = minute;
    }

    public String getExecutionDays() {
        return executionDays;
    }

    public void setExecutionDays(String executionDays) {
        this.executionDays = executionDays;
    }

    public String getExecutionCommand() {
        return executionCommand;
    }

    public void setExecutionCommand(String executionCommand) {
        this.executionCommand = executionCommand;
    }

    public ZonedDateTime getExecuteUntil() {
        return executeUntil;
    }

    public void setExecuteUntil(ZonedDateTime executeUntil) {
        this.executeUntil = executeUntil;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ZonedDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(ZonedDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public ZonedDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(ZonedDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Task{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", jobId='" + jobId + '\'' +
                ", hour=" + hour +
                ", minute=" + minute +
                ", executionDays='" + executionDays + '\'' +
                ", executionCommand='" + executionCommand + '\'' +
                ", executeUntil=" + executeUntil +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
