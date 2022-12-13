package com.hiperium.city.timer.api.utils;

import com.hiperium.city.timer.api.model.Task;
import com.hiperium.city.timer.api.utils.enums.DaysEnum;
import com.hiperium.city.timer.api.jobs.JobExecutionService;
import org.quartz.*;

import java.time.ZoneId;
import java.util.Calendar;
import java.util.*;

/**
 * @author Andres Solorzano
 */
public final class JobsUtils {

    public static final String TASK_GROUP_NAME = "Task#Group";
    public static final String TASK_JOB_ID_DATA_KEY = "taskJobId";

    private JobsUtils() {
    }

    public static JobDetail createJobDetailFromTask(Task task) {
        return JobBuilder.newJob(JobExecutionService.class)
                .withIdentity(task.getJobId(), TASK_GROUP_NAME)
                .usingJobData(TASK_JOB_ID_DATA_KEY, task.getJobId())
                .build();
    }

    public static CronTrigger createCronTriggerFromTask(Task task, String zoneId) {
        TriggerBuilder<CronTrigger> triggerBuilder = TriggerBuilder.newTrigger()
                .withIdentity(task.getJobId(), TASK_GROUP_NAME)
                .startNow()
                .withSchedule(CronScheduleBuilder
                        .atHourAndMinuteOnGivenDaysOfWeek(
                                task.getHour(),
                                task.getMinute(),
                                getIntValuesFromExecutionDays(task.getExecutionDays()))
                        .inTimeZone(TimeZone.getTimeZone(ZoneId.of(zoneId))));
        if (Objects.nonNull(task.getExecuteUntil())) {
            Calendar executeUntilCalendar = Calendar.getInstance(TimeZone.getTimeZone(ZoneId.of(zoneId)));
            executeUntilCalendar.set(Calendar.YEAR, task.getExecuteUntil().getYear());
            executeUntilCalendar.set(Calendar.MONTH, task.getExecuteUntil().getMonthValue() - 1);
            executeUntilCalendar.set(Calendar.DAY_OF_MONTH, task.getExecuteUntil().getDayOfMonth());
            executeUntilCalendar.set(Calendar.HOUR_OF_DAY, 23);
            executeUntilCalendar.set(Calendar.MINUTE, 59);
            executeUntilCalendar.set(Calendar.SECOND, 59);
            // TODO: Fix the error: "java.lang.IllegalArgumentException: End time cannot be before start time"
            triggerBuilder.endAt(executeUntilCalendar.getTime());
        }
        return triggerBuilder.build();
    }

    public static Integer[] getIntValuesFromExecutionDays(String taskExecutionDays) {
        List<Integer> intsDaysOfWeek = new ArrayList<>();
        for (String dayOfWeek : taskExecutionDays.split(",")) {
            DaysEnum daysEnum = DaysEnum.getEnumFromString(dayOfWeek);
            switch (daysEnum) {
                case MON:
                    intsDaysOfWeek.add(DateBuilder.MONDAY);
                    break;
                case TUE:
                    intsDaysOfWeek.add(DateBuilder.TUESDAY);
                    break;
                case WED:
                    intsDaysOfWeek.add(DateBuilder.WEDNESDAY);
                    break;
                case THU:
                    intsDaysOfWeek.add(DateBuilder.THURSDAY);
                    break;
                case FRI:
                    intsDaysOfWeek.add(DateBuilder.FRIDAY);
                    break;
                case SAT:
                    intsDaysOfWeek.add(DateBuilder.SATURDAY);
                    break;
                case SUN:
                    intsDaysOfWeek.add(DateBuilder.SUNDAY);
                    break;
                default:
                    throw new IllegalArgumentException(
                        "The day of the week does not match with the accepted ones: " + daysEnum);
            }
        }
        return intsDaysOfWeek.toArray(Integer[]::new);
    }
}
